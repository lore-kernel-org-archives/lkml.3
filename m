Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaFBPgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:36:00 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:37075 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaFBPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofpkmBag
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofpkmBag
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853174"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 8/9] KVM: x86: Return error on cmpxchg16b emulation
Date: Mon,  2 Jun 2014 18:34:10 +0300
Message-Id: <1401723251-8034-9-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmpxchg16b is currently unimplemented in the emulator. The least we can do is
return error upon the emulation of this instruction.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 3da8d82..a151f8d 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1999,6 +1999,9 @@ static int em_cmpxchg8b(struct x86_emulate_ctxt *ctxt)
 {
 	u64 old = ctxt->dst.orig_val64;
 
+	if (ctxt->dst.bytes == 16)
+		return X86EMUL_UNHANDLEABLE;
+
 	if (((u32) (old >> 0) != (u32) reg_read(ctxt, VCPU_REGS_RAX)) ||
 	    ((u32) (old >> 32) != (u32) reg_read(ctxt, VCPU_REGS_RDX))) {
 		*reg_write(ctxt, VCPU_REGS_RAX) = (u32) (old >> 0);
@@ -4077,7 +4080,7 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->orig_val = op->val;
 		break;
 	case OpMem64:
-		ctxt->memop.bytes = 8;
+		ctxt->memop.bytes = (ctxt->op_bytes == 8) ? 16 : 8;
 		goto mem_common;
 	case OpAcc:
 		op->type = OP_REG;
-- 
1.9.1

