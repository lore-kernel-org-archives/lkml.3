Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaDAIgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:36:12 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42203 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaDAIgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:36:10 -0400
Date: Tue, 1 Apr 2014 10:36:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/cpufeature changes for v3.15
Message-ID: <20140401083606.GA23836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpufeature-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cpufeature-for-linus

   # HEAD: da4aaa7d860c63a1bfd3c73cf8309afe2840c5b9 x86, cpufeature: If we disable CLFLUSH, we should disable CLFLUSHOPT

Two refinements to clflushopt support.

  out-of-topic modifications in x86-cpufeature-for-linus:
  ---------------------------------------------------------
  drivers/gpu/drm/gma500/mmu.c       # 840d283: x86, cpufeature: Rename X86_FEATU

 Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, cpufeature: Rename X86_FEATURE_CLFLSH to X86_FEATURE_CLFLUSH
      x86, cpufeature: If we disable CLFLUSH, we should disable CLFLUSHOPT


 arch/x86/include/asm/cpufeature.h | 4 ++--
 arch/x86/kernel/cpu/common.c      | 3 ++-
 arch/x86/kernel/smpboot.c         | 2 +-
 arch/x86/kvm/cpuid.c              | 2 +-
 drivers/gpu/drm/gma500/mmu.c      | 2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bc507d7..63211ef 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -37,7 +37,7 @@
 #define X86_FEATURE_PAT		(0*32+16) /* Page Attribute Table */
 #define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
 #define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
-#define X86_FEATURE_CLFLSH	(0*32+19) /* "clflush" CLFLUSH instruction */
+#define X86_FEATURE_CLFLUSH	(0*32+19) /* CLFLUSH instruction */
 #define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
 #define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
 #define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
@@ -318,7 +318,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_pmm_enabled	boot_cpu_has(X86_FEATURE_PMM_EN)
 #define cpu_has_ds		boot_cpu_has(X86_FEATURE_DS)
 #define cpu_has_pebs		boot_cpu_has(X86_FEATURE_PEBS)
-#define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
+#define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLUSH)
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8e28bf2..cca53d8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1025,7 +1025,8 @@ __setup("show_msr=", setup_show_msr);
 
 static __init int setup_noclflush(char *arg)
 {
-	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
+	setup_clear_cpu_cap(X86_FEATURE_CLFLUSH);
+	setup_clear_cpu_cap(X86_FEATURE_CLFLUSHOPT);
 	return 1;
 }
 __setup("noclflush", setup_noclflush);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a32da80..ffc78c3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1379,7 +1379,7 @@ static inline void mwait_play_dead(void)
 
 	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-	if (!this_cpu_has(X86_FEATURE_CLFLSH))
+	if (!this_cpu_has(X86_FEATURE_CLFLUSH))
 		return;
 	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c697625..e5503d8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -263,7 +263,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(TSC) | F(MSR) | F(PAE) | F(MCE) |
 		F(CX8) | F(APIC) | 0 /* Reserved */ | F(SEP) |
 		F(MTRR) | F(PGE) | F(MCA) | F(CMOV) |
-		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLSH) |
+		F(PAT) | F(PSE36) | 0 /* PSN */ | F(CLFLUSH) |
 		0 /* Reserved, DS, ACPI */ | F(MMX) |
 		F(FXSR) | F(XMM) | F(XMM2) | F(SELFSNOOP) |
 		0 /* HTT, TM, Reserved, PBE */;
diff --git a/drivers/gpu/drm/gma500/mmu.c b/drivers/gpu/drm/gma500/mmu.c
index 49bac41..c3e67ba 100644
--- a/drivers/gpu/drm/gma500/mmu.c
+++ b/drivers/gpu/drm/gma500/mmu.c
@@ -520,7 +520,7 @@ struct psb_mmu_driver *psb_mmu_driver_init(uint8_t __iomem * registers,
 
 	driver->has_clflush = 0;
 
-	if (boot_cpu_has(X86_FEATURE_CLFLSH)) {
+	if (boot_cpu_has(X86_FEATURE_CLFLUSH)) {
 		uint32_t tfms, misc, cap0, cap4, clflush_size;
 
 		/*
