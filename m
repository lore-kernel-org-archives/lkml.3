Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaEFSQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:16:33 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:51168 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaEFSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:16:31 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, bsd@redhat.com
Subject: [RFC PATCH 4/4] KVM: emulate: put pointers in the fetch_cache
Date: Tue,  6 May 2014 20:16:15 +0200
Message-Id: <1399400175-23754-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>
References: <1399400175-23754-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies the code a bit, especially the overflow checks.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  4 ++--
 arch/x86/kvm/emulate.c             | 34 +++++++++++++++-------------------
 arch/x86/kvm/trace.h               |  6 +++---
 3 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 085d68868756..2467e5e1b894 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -269,8 +269,8 @@ struct operand {
 
 struct fetch_cache {
 	u8 data[15];
-	unsigned long start;
-	unsigned long end;
+	u8 *ptr;
+	u8 *end;
 };
 
 struct read_cache {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 245a2d0bfe68..3ab9310918a7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -708,16 +708,15 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
  */
 static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 {
-	struct fetch_cache *fc = &ctxt->fetch;
 	int rc;
-	int size, cur_size;
+	int size;
 	unsigned long linear;
-
+	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
-					  .ea  = fc->end };
-	cur_size = fc->end - fc->start;
-	size = min(15UL - cur_size,
-		   PAGE_SIZE - offset_in_page(fc->end));
+					   .ea = ctxt->eip + cur_size };
+
+	size = min(15UL ^ cur_size,
+		   PAGE_SIZE - offset_in_page(addr.ea));
 
 	/*
 	 * One instruction can only straddle two pages,
@@ -730,19 +729,18 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	rc = __linearize(ctxt, addr, size, false, true, &linear);
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
-	rc = ctxt->ops->fetch(ctxt, linear, fc->data + cur_size,
+	rc = ctxt->ops->fetch(ctxt, linear, ctxt->fetch.end,
 			      size, &ctxt->exception);
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
-	fc->end += size;
+	ctxt->fetch.end += size;
 	return X86EMUL_CONTINUE;
 }
 
 static __always_inline int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt,
 					       unsigned size)
 {
-	/* We have to be careful about overflow! */
-	if (unlikely(ctxt->_eip > ctxt->fetch.end - size))
+	if (unlikely(ctxt->fetch.end - ctxt->fetch.ptr < size))
 		return __do_insn_fetch_bytes(ctxt, size);
 	else
 		return X86EMUL_CONTINUE;
@@ -751,26 +749,24 @@ static __always_inline int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt,
 /* Fetch next part of the instruction being emulated. */
 #define insn_fetch(_type, _ctxt)					\
 ({	_type _x;							\
-	struct fetch_cache *_fc;					\
 									\
 	rc = do_insn_fetch_bytes(_ctxt, sizeof(_type));			\
 	if (rc != X86EMUL_CONTINUE)					\
 		goto done;						\
-	_fc = &ctxt->fetch;						\
-	_x = *(_type __aligned(1) *) &_fc->data[ctxt->_eip - _fc->start]; \
 	ctxt->_eip += sizeof(_type);					\
+	_x = *(_type __aligned(1) *) ctxt->fetch.ptr;			\
+	ctxt->fetch.ptr += sizeof(_type);				\
 	_x;								\
 })
 
 #define insn_fetch_arr(_arr, _size, _ctxt)				\
 ({									\
-	struct fetch_cache *_fc;					\
 	rc = do_insn_fetch_bytes(_ctxt, _size);				\
 	if (rc != X86EMUL_CONTINUE)					\
 		goto done;						\
-	_fc = &ctxt->fetch;						\
-	memcpy(_arr, &_fc->data[ctxt->_eip - _fc->start], _size);	\
 	ctxt->_eip += (_size);						\
+	memcpy(_arr, ctxt->fetch.ptr, _size);				\
+	ctxt->fetch.ptr += (_size);					\
 })
 
 /*
@@ -4273,8 +4269,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 
 	ctxt->memop.type = OP_NONE;
 	ctxt->_eip = ctxt->eip;
-	ctxt->fetch.start = ctxt->_eip;
-	ctxt->fetch.end = ctxt->fetch.start + insn_len;
+	ctxt->fetch.ptr = ctxt->fetch.data;
+	ctxt->fetch.end = ctxt->fetch.data + insn_len;
 	ctxt->opcode_len = 1;
 	if (insn_len > 0)
 		memcpy(ctxt->fetch.data, insn, insn_len);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 33574c95220d..e850a7d332be 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -721,10 +721,10 @@ TRACE_EVENT(kvm_emulate_insn,
 		),
 
 	TP_fast_assign(
-		__entry->rip = vcpu->arch.emulate_ctxt.fetch.start;
 		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
-		__entry->len = vcpu->arch.emulate_ctxt._eip
-			       - vcpu->arch.emulate_ctxt.fetch.start;
+		__entry->len = vcpu->arch.emulate_ctxt.fetch.ptr
+			       - vcpu->arch.emulate_ctxt.fetch.data;
+		__entry->rip = vcpu->arch.emulate_ctxt._eip - __entry->len;
 		memcpy(__entry->insn,
 		       vcpu->arch.emulate_ctxt.fetch.data,
 		       15);
-- 
1.8.3.1

