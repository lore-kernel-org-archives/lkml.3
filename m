Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaJ0OcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:32:00 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45332 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaJ0Ob6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:31:58 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: namit@cs.technion.ac.il, bp@suse.de, stable@vger.kernel.org
Subject: [PATCH] KVM: emulator: fix execution close to the segment limit
Date: Mon, 27 Oct 2014 15:31:46 +0100
Message-Id: <1414420306-2771-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emulation of code that is 14 bytes to the segment limit or closer
(e.g. RIP = 0xFFFFFFF2 after reset) is broken because we try to read as
many as 15 bytes from the beginning of the instruction, and __linearize
fails when the passed (address, size) pair reaches out of the segment.

To fix this, let __linearize return the maximum accessible size (clamped
to 2^32-1) for usage in __do_insn_fetch_bytes, and avoid the limit check
by passing zero for the desired size.

For expand-down segments, __linearize is performing a redundant check.
(u32)(addr.ea + size - 1) <= lim can only happen if addr.ea is close
to 4GB; in this case, addr.ea + size - 1 will also fail the check against
the upper bound of the segment (which is provided by the D/B bit).
After eliminating the redundant check, it is simple to compute
the *max_size for expand-down segments too.

Now that the limit check is done in __do_insn_fetch_bytes, we want
to inject a general protection fault there if size < op_size (like
__linearize would have done), instead of just aborting.

This fixes booting Tiano Core from emulated flash with EPT disabled.

Cc: stable@vger.kernel.org
Fixes: 719d5a9b2487e0562f178f61e323c3dc18a8b200
Reported-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8aa66068712f..69af43a896c6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -641,7 +641,8 @@ static bool insn_aligned(struct x86_emulate_ctxt *ctxt, unsigned size)
 
 static int __linearize(struct x86_emulate_ctxt *ctxt,
 		     struct segmented_address addr,
-		     unsigned size, bool write, bool fetch,
+		     unsigned *max_size, unsigned size,
+		     bool write, bool fetch,
 		     ulong *linear)
 {
 	struct desc_struct desc;
@@ -652,10 +653,15 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
 	unsigned cpl;
 
 	la = seg_base(ctxt, addr.seg) + addr.ea;
+	*max_size = 0;
 	switch (ctxt->mode) {
 	case X86EMUL_MODE_PROT64:
 		if (((signed long)la << 16) >> 16 != la)
 			return emulate_gp(ctxt, 0);
+
+		*max_size = min_t(u64, ~0u, (1ul << 48) - la);
+		if (size > *max_size)
+			goto bad;
 		break;
 	default:
 		usable = ctxt->ops->get_segment(ctxt, &sel, &desc, NULL,
@@ -673,20 +679,25 @@ static int __linearize(struct x86_emulate_ctxt *ctxt,
 		if ((ctxt->mode == X86EMUL_MODE_REAL) && !fetch &&
 		    (ctxt->d & NoBigReal)) {
 			/* la is between zero and 0xffff */
-			if (la > 0xffff || (u32)(la + size - 1) > 0xffff)
+			if (la > 0xffff)
 				goto bad;
+			*max_size = 0x10000 - la;
 		} else if ((desc.type & 8) || !(desc.type & 4)) {
 			/* expand-up segment */
-			if (addr.ea > lim || (u32)(addr.ea + size - 1) > lim)
+			if (addr.ea > lim)
 				goto bad;
+			*max_size = min_t(u64, ~0u, (u64)lim + 1 - addr.ea);
 		} else {
 			/* expand-down segment */
-			if (addr.ea <= lim || (u32)(addr.ea + size - 1) <= lim)
+			if (addr.ea <= lim)
 				goto bad;
 			lim = desc.d ? 0xffffffff : 0xffff;
-			if (addr.ea > lim || (u32)(addr.ea + size - 1) > lim)
+			if (addr.ea > lim)
 				goto bad;
+			*max_size = min_t(u64, ~0u, (u64)lim + 1 - addr.ea);
 		}
+		if (size > *max_size)
+			goto bad;
 		cpl = ctxt->ops->cpl(ctxt);
 		if (!(desc.type & 8)) {
 			/* data segment */
@@ -721,7 +732,8 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 		     unsigned size, bool write,
 		     ulong *linear)
 {
-	return __linearize(ctxt, addr, size, write, false, linear);
+	unsigned max_size;
+	return __linearize(ctxt, addr, &max_size, size, write, false, linear);
 }
 
 
@@ -746,17 +758,27 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
 static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 {
 	int rc;
-	unsigned size;
+	unsigned size, max_size;
 	unsigned long linear;
 	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = ctxt->eip + cur_size };
 
-	size = 15UL ^ cur_size;
-	rc = __linearize(ctxt, addr, size, false, true, &linear);
+	/*
+	 * We do not know exactly how many bytes will be needed, and
+	 * __linearize is expensive, so fetch as much as possible.  We
+	 * just have to avoid going beyond the 15 byte limit, the end
+	 * of the segment, or the end of the page.
+	 *
+	 * __linearize is called with size 0 so that it does not do any
+	 * boundary check itself.  Instead, we use max_size to check
+	 * against op_size.
+	 */
+	rc = __linearize(ctxt, addr, &max_size, 0, false, true, &linear);
 	if (unlikely(rc != X86EMUL_CONTINUE))
 		return rc;
 
+	size = min_t(unsigned, 15UL ^ cur_size, max_size);
 	size = min_t(unsigned, size, PAGE_SIZE - offset_in_page(linear));
 
 	/*
@@ -766,7 +788,8 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	 * still, we must have hit the 15-byte boundary.
 	 */
 	if (unlikely(size < op_size))
-		return X86EMUL_UNHANDLEABLE;
+		return emulate_gp(ctxt, 0);
+
 	rc = ctxt->ops->fetch(ctxt, linear, ctxt->fetch.end,
 			      size, &ctxt->exception);
 	if (unlikely(rc != X86EMUL_CONTINUE))
-- 
1.8.3.1

