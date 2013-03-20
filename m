Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab3CTOHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:07:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41228 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3CTOHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:07:36 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 6/6] x86, cpu: Convert AMD Erratum 400
Date: Wed, 20 Mar 2013 15:07:28 +0100
Message-Id: <1363788448-31325-7-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363788448-31325-1-git-send-email-bp@alien8.de>
References: <1363788448-31325-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Convert AMD erratum 400 to the bug infrastructure. Then, retract all
exports for modules since they're not needed now and make the AMD
erratum checking machinery local to amd.c. Use forward declarations to
avoid shuffling too much code around needlessly.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/include/asm/processor.h  | 19 -------------------
 arch/x86/kernel/cpu/amd.c         | 23 ++++++++++++++++-------
 arch/x86/kernel/process.c         |  2 +-
 4 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4cfb5c9f6029..272fdccda5d5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -226,6 +226,7 @@
 #define X86_BUG_FDIV		X86_BUG(1) /* FPU FDIV */
 #define X86_BUG_COMA		X86_BUG(2) /* Cyrix 6x86 coma */
 #define X86_BUG_AMD_TLB_MMATCH	X86_BUG(3) /* AMD Erratum 383 */
+#define X86_BUG_AMD_APIC_C1E	X86_BUG(4) /* AMD Erratum 400 */
 
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e044ef35f91f..22224b3b43bb 100644
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
index 85f84e13d2dd..9a2a71669c5d 100644
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
index 14ae10031ff0..e718f150c880 100644
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
-- 
1.8.1.3.535.ga923c31

