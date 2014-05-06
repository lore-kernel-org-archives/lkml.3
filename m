Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbaEFAlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933507AbaEFAlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:41:16 -0400
From: Bandan Das <bsd@redhat.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] KVM: x86: cache userspace address for faster fetches
Date: Mon,  5 May 2014 20:40:59 -0400
Message-Id: <1399336859-7227-4-git-send-email-bsd@redhat.com>
In-Reply-To: <1399336859-7227-1-git-send-email-bsd@redhat.com>
References: <1399336859-7227-1-git-send-email-bsd@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On every instruction fetch, kvm_read_guest_virt_helper
does the gva to gpa translation followed by searching for the
memslot. Store the gva hva mapping so that if there's a match
we can directly call __copy_from_user()

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |  7 ++++++-
 arch/x86/kvm/x86.c                 | 33 +++++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 085d688..20ccde4 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -323,10 +323,11 @@ struct x86_emulate_ctxt {
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
 	/*
-	 * The following five fields are cleared together,
+	 * The following six fields are cleared together,
 	 * the rest are initialized unconditionally in x86_decode_insn
 	 * or elsewhere
 	 */
+	bool addr_cache_valid;
 	u8 rex_prefix;
 	u8 lock_prefix;
 	u8 rep_prefix;
@@ -348,6 +349,10 @@ struct x86_emulate_ctxt {
 	struct fetch_cache fetch;
 	struct read_cache io_read;
 	struct read_cache mem_read;
+	struct {
+		gfn_t gfn;
+		unsigned long uaddr;
+	} addr_cache;
 };
 
 /* Repeat String Operation Prefix */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf69e3b..7afcfc7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4072,26 +4072,38 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 		unsigned long uaddr;
+		gfn_t gfn = addr >> PAGE_SHIFT;
 
-		ret = ctxt->ops->memory_prepare(ctxt, addr, toread,
-						exception, false,
-						NULL, &uaddr);
-		if (ret != X86EMUL_CONTINUE)
-			return ret;
+		if (ctxt->addr_cache_valid &&
+		    (ctxt->addr_cache.gfn == gfn))
+			uaddr = (ctxt->addr_cache.uaddr << PAGE_SHIFT) +
+				offset_in_page(addr);
+		else {
+			ret = ctxt->ops->memory_prepare(ctxt, addr, toread,
+							exception, false,
+							NULL, &uaddr);
+			if (ret != X86EMUL_CONTINUE)
+				return ret;
+
+			if (unlikely(kvm_is_error_hva(uaddr))) {
+				r = X86EMUL_PROPAGATE_FAULT;
+				return r;
+			}
 
-		if (unlikely(kvm_is_error_hva(uaddr))) {
-			r = X86EMUL_PROPAGATE_FAULT;
-			return r;
+			/* Cache gfn and hva */
+			ctxt->addr_cache.gfn = addr >> PAGE_SHIFT;
+			ctxt->addr_cache.uaddr = uaddr >> PAGE_SHIFT;
+			ctxt->addr_cache_valid = true;
 		}
 
 		ret = __copy_from_user(data, (void __user *)uaddr, toread);
 		if (ret < 0) {
 			r = X86EMUL_IO_NEEDED;
+			/* Where else should we invalidate cache ? */
+			ctxt->ops->memory_finish(ctxt, NULL, uaddr);
 			return r;
 		}
 
-		ctxt->ops->memory_finish(ctxt, NULL, uaddr);
-
 		bytes -= toread;
 		data += toread;
 		addr += toread;
@@ -4339,6 +4351,7 @@ static void emulator_memory_finish(struct x86_emulate_ctxt *ctxt,
 	struct kvm_memory_slot *memslot;
 	gfn_t gfn;
 
+	ctxt->addr_cache_valid = false;
 	if (!opaque)
 		return;
 
-- 
1.8.3.1

