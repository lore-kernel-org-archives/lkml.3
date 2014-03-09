Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaCIRF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:05:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33385 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaCIRFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:05:31 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/3] x86, Intel: Convert to the new MSR accessors
Date: Sun,  9 Mar 2014 18:05:25 +0100
Message-Id: <1394384725-10796-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394384725-10796-1-git-send-email-bp@alien8.de>
References: <1394384725-10796-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and save some lines of code.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/uapi/asm/msr-index.h |  9 ++++++---
 arch/x86/kernel/cpu/intel.c           | 30 +++++++-----------------------
 2 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index c19fc60ff062..045e6db6f58a 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -368,14 +368,16 @@
 #define THERM_LOG_THRESHOLD1           (1 << 9)
 
 /* MISC_ENABLE bits: architectural */
-#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
+#define MSR_BIT_FAST_STRING				0
+#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << MSR_BIT_FAST_STRING)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
 #define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
 #define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
 #define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
 #define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
 #define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
-#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
+#define MSR_BIT_LIMIT_CPUID				22
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << MSR_BIT_LIMIT_CPUID);
 #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
 #define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
 
@@ -385,7 +387,8 @@
 #define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE	(1ULL << 4)
 #define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE	(1ULL << 6)
 #define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK	(1ULL << 8)
-#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << 9)
+#define MSR_BIT_PRF_DIS				9
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << MSR_BIT_PRF_DIS)
 #define MSR_IA32_MISC_ENABLE_FERR		(1ULL << 10)
 #define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX	(1ULL << 10)
 #define MSR_IA32_MISC_ENABLE_TM2		(1ULL << 13)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5cd9bfabd645..44ca6317af43 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,11 +31,7 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-
-		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
-			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
-			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		if (msr_clear_bit(MSR_IA32_MISC_ENABLE, MSR_BIT_LIMIT_CPUID) > 0) {
 			c->cpuid_level = cpuid_eax(0);
 			get_cpu_cap(c);
 		}
@@ -129,16 +125,9 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	 * Ingo Molnar reported a Pentium D (model 6) and a Xeon
 	 * (model 2) with the same problem.
 	 */
-	if (c->x86 == 15) {
-		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-
-		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
-
-			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
-			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
-		}
-	}
+	if (c->x86 == 15)
+		if (msr_clear_bit(MSR_IA32_MISC_ENABLE, MSR_BIT_FAST_STRING) > 0)
+			pr_info("kmemcheck: Disabling fast string operations\n");
 #endif
 
 	/*
@@ -197,8 +186,6 @@ static void intel_smp_check(struct cpuinfo_x86 *c)
 
 static void intel_workarounds(struct cpuinfo_x86 *c)
 {
-	unsigned long lo, hi;
-
 #ifdef CONFIG_X86_F00F_BUG
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
@@ -229,12 +216,9 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
-		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
-		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
-			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
-			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
-			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
-			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
+		if (msr_set_bit(MSR_IA32_MISC_ENABLE, MSR_BIT_PRF_DIS) > 0) {
+			pr_info("CPU: C0 stepping P4 Xeon detected.\n");
+			pr_info("CPU: Disabling hardware prefetching (Errata 037)\n");
 		}
 	}
 
-- 
1.9.0

