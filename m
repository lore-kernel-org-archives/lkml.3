Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaIHRs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:48:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51452 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbaIHRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:47:56 -0400
X-Sasl-enc: EZY4rAbJfms05A4hJTdVKv8VBROarOk9Hyh/hjY1arAS 1410197886
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 6/8] x86, microcode, intel: use cpuid explicitly instead of sync_core
Date: Mon,  8 Sep 2014 14:37:52 -0300
Message-Id: <1410197875-19252-7-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The protocol to safely read MSR 8BH, described in the Intel SDM vol 3A,
section 9.11.7.1, explicitly determines that cpuid with EAX=1 must be
used between the wrmsr(0x8B, 0); and the rdmsr(0x8B).

The microcode driver was abusing sync_core() to do this, probably
because it predates by nearly a decade the current "asm volatile
(:::"memory")" implementation of native_cpuid(), which is required for
the Intel MSR 8BH access protocol.

sync_core() semanthics are that of being a speculative execution
barrier, and not "run cpuid with EAX=1".

Change the Intel microcode driver to use native_cpuid instead, which is
more appropriate.  native_cpuid() is already in use by the early
microcode driver in one place.

Some small code reordering was done to avoid calling cpuid twice in
collect_cpu_info_early().

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/include/asm/microcode_intel.h      |   12 ++++++++++++
 arch/x86/kernel/cpu/microcode/intel.c       |    6 ++----
 arch/x86/kernel/cpu/microcode/intel_early.c |   25 +++++++------------------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index bbe296e..d40a45e 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -84,4 +84,16 @@ static inline int save_mc_for_early(u8 *mc)
 }
 #endif
 
+static inline unsigned int intel_ucode_cpuid_1(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+
+	eax = 1;
+	ecx = 0;
+	/* extremely important: must be asm volatile(:::"memory") */
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	return eax;
+}
+
 #endif /* _ASM_X86_MICROCODE_INTEL_H */
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index e99cdd8..2182cec 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -94,8 +94,6 @@ static void __collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 
-	csig->sig = cpuid_eax(0x00000001);
-
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {
 		/* get processor flags from MSR 0x17 */
 		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
@@ -104,7 +102,7 @@ static void __collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	/* get the current microcode revision from MSR 0x8B */
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	sync_core();
+	csig->sig = intel_ucode_cpuid_1(); /* a cpuid(1) must happen here */
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
 	csig->rev = val[1];
@@ -174,7 +172,7 @@ static int apply_microcode_intel(int cpu)
 
 	/* get the current revision from MSR 0x8B */
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	sync_core();
+	intel_ucode_cpuid_1();
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
 	if (val[1] != mc_intel->hdr.rev) {
diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 8ad50d6..92629a8 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -379,7 +379,6 @@ static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 	unsigned int val[2];
 	u8 x86, x86_model;
 	struct cpu_signature csig;
-	unsigned int eax, ebx, ecx, edx;
 
 	csig.sig = 0;
 	csig.pf = 0;
@@ -387,10 +386,11 @@ static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 
 	memset(uci, 0, sizeof(*uci));
 
-	eax = 0x00000001;
-	ecx = 0;
-	native_cpuid(&eax, &ebx, &ecx, &edx);
-	csig.sig = eax;
+	/* get the current revision from MSR 0x8B */
+	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+	csig.sig = intel_ucode_cpuid_1(); /* a cpuid(1) must happen here */
+	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+	csig.rev = val[1];
 
 	x86 = get_x86_family(csig.sig);
 	x86_model = get_x86_model(csig.sig);
@@ -400,15 +400,6 @@ static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 		native_rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
 		csig.pf = 1 << ((val[1] >> 18) & 7);
 	}
-	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-
-	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
-
-	/* get the current revision from MSR 0x8B */
-	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-
-	csig.rev = val[1];
 
 	uci->cpu_sig = csig;
 	uci->valid = 1;
@@ -679,12 +670,10 @@ static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
 	native_wrmsr(MSR_IA32_UCODE_WRITE,
 	      (unsigned long) mc_intel->bits,
 	      (unsigned long) mc_intel->bits >> 16 >> 16);
-	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-
-	/* As documented in the SDM: Do a CPUID 1 here */
-	sync_core();
 
 	/* get the current revision from MSR 0x8B */
+	native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+	intel_ucode_cpuid_1();
 	native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 	if (val[1] != mc_intel->hdr.rev) {
 		print_ucode(INTEL_EARLYMCU_REJECTED, uci, mc_intel->hdr.rev);
-- 
1.7.10.4

