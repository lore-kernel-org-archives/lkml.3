Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933790AbaFINBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:01:23 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57439 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570AbaFIM7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:59:54 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: bdas@redhat.com, gleb@kernel.org
Subject: [PATCH 22/25] KVM: emulate: put pointers in the fetch_cache
Date: Mon,  9 Jun 2014 14:59:10 +0200
Message-Id: <1402318753-23362-23-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>
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
index 692b0bfadf91..012fff3fea0d 100644
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
index 6ec0be2d2461..6b44f90a9bb0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -709,16 +709,15 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
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
+					   .ea = ctxt->eip + cur_size };
+
 	size = min(15UL - cur_size,
-		   PAGE_SIZE - offset_in_page(fc->end));
+		   PAGE_SIZE - offset_in_page(addr.ea));
 
 	/*
 	 * One instruction can only straddle two pages,
@@ -731,19 +730,18 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
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
@@ -752,26 +750,24 @@ static __always_inline int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt,
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
@@ -4302,8 +4298,8 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	ctxt->memop.type = OP_NONE;
 	ctxt->memopp = NULL;
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


