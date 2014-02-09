Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaBINsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:48:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47120 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaBINsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:48:35 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 3/3] x86, intel: Convert to the new MSR accessors
Date: Sun,  9 Feb 2014 14:48:29 +0100
Message-Id: <1391953709-15400-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1391953709-15400-1-git-send-email-bp@alien8.de>
References: <1391953709-15400-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and save some lines of code.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/uapi/asm/msr-index.h |  6 ++++--
 arch/x86/kernel/cpu/intel.c           | 29 ++++++++---------------------
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index c19fc60ff062..0a93ea3e70da 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -368,14 +368,16 @@
 #define THERM_LOG_THRESHOLD1           (1 << 9)
 
 /* MISC_ENABLE bits: architectural */
-#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
+#define BIT_FAST_STRING				0
+#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << BIT_FAST_STRING)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
 #define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
 #define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
 #define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
 #define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
 #define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
-#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
+#define BIT_LIMIT_CPUID				22
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << BIT_LIMIT_CPUID);
 #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
 #define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3db61c644e44..ce12e535c9a6 100644
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
+		if (msr_clear_bit(MSR_IA32_MISC_ENABLE, BIT_LIMIT_CPUID) > 0) {
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
+		if (msr_clear_bit(MSR_IA32_MISC_ENABLE, BIT_FAST_STRING) > 0)
+			pr_info("kmemcheck: Disabling fast string operations\n");
 #endif
 
 	/*
@@ -229,12 +218,10 @@ static void intel_workarounds(struct cpuinfo_x86 *c)
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
-		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
-		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
-			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
-			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
-			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
-			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
+		if (msr_set_bit(MSR_IA32_MISC_ENABLE,
+				MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) > 0) {
+			pr_info("CPU: C0 stepping P4 Xeon detected.\n");
+			pr_info("CPU: Disabling hardware prefetching (Errata 037)\n");
 		}
 	}
 
-- 
1.8.5.2.192.g7794a68

