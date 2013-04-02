Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3DBTjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:39:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab3DBTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:39:20 -0400
Date: Tue, 2 Apr 2013 12:38:26 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-7d7dc116e56c8a1ba4beb36d06a77a48fe5f750b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1363788448-31325-7-git-send-email-bp@alien8.de>
References: <1363788448-31325-7-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Convert AMD Erratum 400
Git-Commit-ID: 7d7dc116e56c8a1ba4beb36d06a77a48fe5f750b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 12:38:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d7dc116e56c8a1ba4beb36d06a77a48fe5f750b
Gitweb:     http://git.kernel.org/tip/7d7dc116e56c8a1ba4beb36d06a77a48fe5f750b
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Mar 2013 15:07:28 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 2 Apr 2013 10:12:55 -0700

x86, cpu: Convert AMD Erratum 400

Convert AMD erratum 400 to the bug infrastructure. Then, retract all
exports for modules since they're not needed now and make the AMD
erratum checking machinery local to amd.c. Use forward declarations to
avoid shuffling too much code around needlessly.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1363788448-31325-7-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/include/asm/processor.h  | 19 -------------------
 arch/x86/kernel/cpu/amd.c         | 23 ++++++++++++++++-------
 arch/x86/kernel/process.c         |  2 +-
 4 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4cfb5c9..272fdcc 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -226,6 +226,7 @@
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
 #define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e044ef3..22224b3 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -970,25 +970,6 @@ unsigned long calc_aperfmperf_ratio(struct aperfmperf *old,
 	return ratio;
 }
 
-/*
- * AMD errata checking
- */
-#ifdef CONFIG_CPU_SUP_AMD
-extern const int amd_erratum_400[];
-extern bool cpu_has_amd_erratum(const int *);
-
-#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
-#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
-#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
-	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
-#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
-#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
-#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
-
-#else
-#define cpu_has_amd_erratum(x)	(false)
-#endif /* CONFIG_CPU_SUP_AMD */
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 85f84e1..9a2a716 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -514,6 +514,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 }
 
 static const int amd_erratum_383[];
+static const int amd_erratum_400[];
+static bool cpu_has_amd_erratum(const int *erratum);
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
@@ -734,6 +736,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 			set_cpu_bug(c, X86_BUG_AMD_TLB_MMATCH);
 	}
 
+	if (cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_bug(c, X86_BUG_AMD_APIC_C1E);
+
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
 }
 
@@ -852,8 +857,7 @@ cpu_dev_register(amd_cpu_dev);
  * AMD_OSVW_ERRATUM() macros. The latter is intended for newer errata that
  * have an OSVW id assigned, which it takes as first argument. Both take a
  * variable number of family-specific model-stepping ranges created by
- * AMD_MODEL_RANGE(). Each erratum also has to be declared as extern const
- * int[] in arch/x86/include/asm/processor.h.
+ * AMD_MODEL_RANGE().
  *
  * Example:
  *
@@ -863,15 +867,22 @@ cpu_dev_register(amd_cpu_dev);
  *			   AMD_MODEL_RANGE(0x10, 0x9, 0x0, 0x9, 0x0));
  */
 
-const int amd_erratum_400[] =
+#define AMD_LEGACY_ERRATUM(...)		{ -1, __VA_ARGS__, 0 }
+#define AMD_OSVW_ERRATUM(osvw_id, ...)	{ osvw_id, __VA_ARGS__, 0 }
+#define AMD_MODEL_RANGE(f, m_start, s_start, m_end, s_end) \
+	((f << 24) | (m_start << 16) | (s_start << 12) | (m_end << 4) | (s_end))
+#define AMD_MODEL_RANGE_FAMILY(range)	(((range) >> 24) & 0xff)
+#define AMD_MODEL_RANGE_START(range)	(((range) >> 12) & 0xfff)
+#define AMD_MODEL_RANGE_END(range)	((range) & 0xfff)
+
+static const int amd_erratum_400[] =
 	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
-EXPORT_SYMBOL_GPL(amd_erratum_400);
 
 static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
-bool cpu_has_amd_erratum(const int *erratum)
+static bool cpu_has_amd_erratum(const int *erratum)
 {
 	struct cpuinfo_x86 *cpu = __this_cpu_ptr(&cpu_info);
 	int osvw_id = *erratum++;
@@ -912,5 +923,3 @@ bool cpu_has_amd_erratum(const int *erratum)
 
 	return false;
 }
-
-EXPORT_SYMBOL_GPL(cpu_has_amd_erratum);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..e718f15 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -495,7 +495,7 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 	if (x86_idle)
 		return;
 
-	if (cpu_has_amd_erratum(amd_erratum_400)) {
+	if (cpu_has_bug(c, X86_BUG_AMD_APIC_C1E)) {
 		/* E400: APIC timer interrupt does not wake up CPU from C1e */
 		pr_info("using AMD E400 aware idle routine\n");
 		x86_idle = amd_e400_idle;
