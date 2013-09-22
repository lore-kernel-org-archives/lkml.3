Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3IVOqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:46:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53481 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3IVOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:45:06 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre@andrep.de>, Joerg Roedel <joro@8bytes.org>,
        X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 3/6] kvm, emulator: Rename VendorSpecific flag
Date: Sun, 22 Sep 2013 16:44:52 +0200
Message-Id: <1379861095-628-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379861095-628-1-git-send-email-bp@alien8.de>
References: <1379861095-628-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Call it EmulateOnUD which is exactly what we're trying to do with
vendor-specific instructions.

Rename ->only_vendor_specific_insn to something shorter, while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/kvm_emulate.h |  2 +-
 arch/x86/kvm/emulate.c             | 14 +++++++-------
 arch/x86/kvm/x86.c                 |  3 +--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 92a176ad456c..24ec1216596e 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -274,7 +274,7 @@ struct x86_emulate_ctxt {
 
 	bool guest_mode; /* guest running a nested guest */
 	bool perm_ok; /* do not check permissions if true */
-	bool only_vendor_specific_insn;
+	bool ud;	/* inject an #UD if host doesn't support insn */
 
 	bool have_exception;
 	struct x86_exception exception;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index bfae4a433091..67277bcb377a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -130,7 +130,7 @@
 #define Mov         (1<<20)
 /* Misc flags */
 #define Prot        (1<<21) /* instruction generates #UD if not in prot-mode */
-#define VendorSpecific (1<<22) /* Vendor specific instruction */
+#define EmulateOnUD (1<<22) /* Emulate if unsupported by the host */
 #define NoAccess    (1<<23) /* Don't access memory (lea/invlpg/verr etc) */
 #define Op3264      (1<<24) /* Operand is 64b in long mode, 32b otherwise */
 #define Undefined   (1<<25) /* No Such Instruction */
@@ -3491,7 +3491,7 @@ static const struct opcode group7_rm1[] = {
 
 static const struct opcode group7_rm3[] = {
 	DIP(SrcNone | Prot | Priv,		vmrun,		check_svme_pa),
-	II(SrcNone  | Prot | VendorSpecific,	em_vmmcall,	vmmcall),
+	II(SrcNone  | Prot | EmulateOnUD,	em_vmmcall,	vmmcall),
 	DIP(SrcNone | Prot | Priv,		vmload,		check_svme_pa),
 	DIP(SrcNone | Prot | Priv,		vmsave,		check_svme_pa),
 	DIP(SrcNone | Prot | Priv,		stgi,		check_svme),
@@ -3576,7 +3576,7 @@ static const struct group_dual group7 = { {
 	II(SrcMem16 | Mov | Priv,		em_lmsw, lmsw),
 	II(SrcMem | ByteOp | Priv | NoAccess,	em_invlpg, invlpg),
 }, {
-	I(SrcNone | Priv | VendorSpecific,	em_vmcall),
+	I(SrcNone | Priv | EmulateOnUD,	em_vmcall),
 	EXT(0, group7_rm1),
 	N, EXT(0, group7_rm3),
 	II(SrcNone | DstMem | Mov,		em_smsw, smsw), N,
@@ -3798,7 +3798,7 @@ static const struct opcode opcode_table[256] = {
 static const struct opcode twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	G(0, group6), GD(0, &group7), N, N,
-	N, I(ImplicitOps | VendorSpecific, em_syscall),
+	N, I(ImplicitOps | EmulateOnUD, em_syscall),
 	II(ImplicitOps | Priv, em_clts, clts), N,
 	DI(ImplicitOps | Priv, invd), DI(ImplicitOps | Priv, wbinvd), N, N,
 	N, D(ImplicitOps | ModRM), N, N,
@@ -3818,8 +3818,8 @@ static const struct opcode twobyte_table[256] = {
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	II(ImplicitOps | Priv, em_rdmsr, rdmsr),
 	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
-	I(ImplicitOps | VendorSpecific, em_sysenter),
-	I(ImplicitOps | Priv | VendorSpecific, em_sysexit),
+	I(ImplicitOps | EmulateOnUD, em_sysenter),
+	I(ImplicitOps | Priv | EmulateOnUD, em_sysexit),
 	N, N,
 	N, N, N, N, N, N, N, N,
 	/* 0x40 - 0x4F */
@@ -4256,7 +4256,7 @@ done_prefixes:
 	if (ctxt->d == 0 || (ctxt->d & NotImpl))
 		return EMULATION_FAILED;
 
-	if (!(ctxt->d & VendorSpecific) && ctxt->only_vendor_specific_insn)
+	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
 		return EMULATION_FAILED;
 
 	if (mode == X86EMUL_MODE_PROT64 && (ctxt->d & Stack))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f2ea40b80cf..0767d9f4c5bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5097,8 +5097,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		ctxt->have_exception = false;
 		ctxt->perm_ok = false;
 
-		ctxt->only_vendor_specific_insn
-			= emulation_type & EMULTYPE_TRAP_UD;
+		ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
 
 		r = x86_decode_insn(ctxt, insn, insn_len);
 
-- 
1.8.4

