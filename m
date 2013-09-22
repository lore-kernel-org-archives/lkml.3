Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3IVOqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:46:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53489 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab3IVOpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:45:07 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Andre Przywara <andre@andrep.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/6] kvm: Emulate MOVBE
Date: Sun, 22 Sep 2013 16:44:54 +0200
Message-Id: <1379861095-628-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379861095-628-1-git-send-email-bp@alien8.de>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This basically came from the need to be able to boot 32-bit Atom SMP
guests on an AMD host, i.e. a host which doesn't support MOVBE. As a
matter of fact, qemu has since recently received MOVBE support but we
cannot share that with kvm emulation and thus we have to do this in the
host. We're waay faster in kvm anyway. :-)

So, we piggyback on the #UD path and emulate the MOVBE functionality.
With it, an 8-core SMP guest boots in under 6 seconds.

Also, requesting MOVBE emulation needs to happen explicitly to work,
i.e. qemu -cpu n270,+movbe...

Just FYI, a fairly straight-forward boot of a MOVBE-enabled 3.9-rc6+
kernel in kvm executes MOVBE ~60K times.

Signed-off-by: Andre Przywara <andre@andrep.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kvm/cpuid.c   | 18 ++++++++++++++++-
 arch/x86/kvm/emulate.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index eca357095a49..986cf7cc74f3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -190,6 +190,22 @@ static bool supported_xcr0_bit(unsigned bit)
 static int __do_cpuid_ent_emulated(struct kvm_cpuid_entry2 *entry,
 				   u32 func, u32 index, int *nent, int maxnent)
 {
+	switch (func) {
+	case 0:
+		entry->eax = 1;		/* only one leaf currently */
+		++*nent;
+		break;
+	case 1:
+		entry->ecx = F(MOVBE);
+		++*nent;
+		break;
+	default:
+		break;
+	}
+
+	entry->function = func;
+	entry->index = index;
+
 	return 0;
 }
 
@@ -559,7 +575,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 		return -EINVAL;
 
 	r = -ENOMEM;
-	cpuid_entries = vmalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
+	cpuid_entries = vzalloc(sizeof(struct kvm_cpuid_entry2) * cpuid->nent);
 	if (!cpuid_entries)
 		goto out;
 
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 72093d76c769..fba4a75d82cf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2950,6 +2950,46 @@ static int em_mov(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+#define FFL(x) bit(X86_FEATURE_##x)
+
+static int em_movbe(struct x86_emulate_ctxt *ctxt)
+{
+	u32 ebx, ecx, edx, eax = 1;
+	u16 tmp;
+
+	/*
+	 * Check MOVBE is set in the guest-visible CPUID leaf.
+	 */
+	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx);
+	if (!(ecx & FFL(MOVBE)))
+		return emulate_ud(ctxt);
+
+	switch (ctxt->op_bytes) {
+	case 2:
+		/*
+		 * From MOVBE definition: "...When the operand size is 16 bits,
+		 * the upper word of the destination register remains unchanged
+		 * ..."
+		 *
+		 * Both casting ->valptr and ->val to u16 breaks strict aliasing
+		 * rules so we have to do the operation almost per hand.
+		 */
+		tmp = (u16)ctxt->src.val;
+		ctxt->dst.val &= ~0xffffUL;
+		ctxt->dst.val |= (unsigned long)swab16(tmp);
+		break;
+	case 4:
+		ctxt->dst.val = swab32((u32)ctxt->src.val);
+		break;
+	case 8:
+		ctxt->dst.val = swab64(ctxt->src.val);
+		break;
+	default:
+		return X86EMUL_PROPAGATE_FAULT;
+	}
+	return X86EMUL_CONTINUE;
+}
+
 static int em_cr_write(struct x86_emulate_ctxt *ctxt)
 {
 	if (ctxt->ops->set_cr(ctxt, ctxt->modrm_reg, ctxt->src.val))
@@ -3881,11 +3921,11 @@ static const struct opcode twobyte_table[256] = {
 };
 
 static const struct gprefix third_opcode_byte_0xf0 = {
-	N, N, N, N
+	I(DstReg | SrcMem | Mov, em_movbe), N, N, N
 };
 
 static const struct gprefix third_opcode_byte_0xf1 = {
-	N, N, N, N
+	I(DstMem | SrcReg | Mov, em_movbe), N, N, N
 };
 
 /*
@@ -3895,8 +3935,13 @@ static const struct gprefix third_opcode_byte_0xf1 = {
 static const struct opcode opcode_map_0f_38[256] = {
 	/* 0x00 - 0x7f */
 	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
-	/* 0x80 - 0xff */
-	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N)
+	/* 0x80 - 0xef */
+	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
+	/* 0xf0 - 0xf1 */
+	GP(EmulateOnUD | ModRM | Prefix, &third_opcode_byte_0xf0),
+	GP(EmulateOnUD | ModRM | Prefix, &third_opcode_byte_0xf1),
+	/* 0xf2 - 0xff */
+	N, N, X4(N), X8(N)
 };
 
 #undef D
-- 
1.8.4

