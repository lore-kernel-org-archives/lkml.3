Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaAOWnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:43:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57025 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaAOWnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:43:01 -0500
Date: Wed, 15 Jan 2014 14:42:49 -0800
From: tip-bot for Kuppuswamy Sathyanarayanan <tipbot@zytor.com>
Message-ID: <tip-85611e3febe78955a519f5f9eb47b941525c8c76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fei.yang@intel.com, david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fei.yang@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1387224459-25746-3-git-send-email-david.a.cohen@linux.intel.com>
References: <1387224459-25746-3-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid:
  Add Clovertrail platform support
Git-Commit-ID: 85611e3febe78955a519f5f9eb47b941525c8c76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 15 Jan 2014 14:42:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85611e3febe78955a519f5f9eb47b941525c8c76
Gitweb:     http://git.kernel.org/tip/85611e3febe78955a519f5f9eb47b941525c8c76
Author:     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
AuthorDate: Mon, 16 Dec 2013 12:07:37 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Jan 2014 14:38:58 -0800

x86, intel-mid: Add Clovertrail platform support

This patch adds Clovertrail support on intel-mid and makes it more
flexible to support other SoCs.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1387224459-25746-3-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Fei Yang <fei.yang@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h                   | 46 +++++++++++++++++++++-
 arch/x86/platform/intel-mid/intel-mid.c            | 39 ++++++++++++++++--
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |  7 +++-
 arch/x86/platform/intel-mid/mfld.c                 | 32 +++++++++++++--
 4 files changed, 113 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index 459769d..f8a8314 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -51,10 +51,39 @@ struct devs_id {
 enum intel_mid_cpu_type {
 	/* 1 was Moorestown */
 	INTEL_MID_CPU_CHIP_PENWELL = 2,
+	INTEL_MID_CPU_CHIP_CLOVERVIEW,
 };
 
 extern enum intel_mid_cpu_type __intel_mid_cpu_chip;
 
+/**
+ * struct intel_mid_ops - Interface between intel-mid & sub archs
+ * @arch_setup: arch_setup function to re-initialize platform
+ *             structures (x86_init, x86_platform_init)
+ *
+ * This structure can be extended if any new interface is required
+ * between intel-mid & its sub arch files.
+ */
+struct intel_mid_ops {
+	void (*arch_setup)(void);
+};
+
+/* Helper API's for INTEL_MID_OPS_INIT */
+#define DECLARE_INTEL_MID_OPS_INIT(cpuname, cpuid)	\
+				[cpuid] = get_##cpuname##_ops
+
+/* Maximum number of CPU ops */
+#define MAX_CPU_OPS(a) (sizeof(a)/sizeof(void *))
+
+/*
+ * For every new cpu addition, a weak get_<cpuname>_ops() function needs be
+ * declared in arch/x86/platform/intel_mid/intel_mid_weak_decls.h.
+ */
+#define INTEL_MID_OPS_INIT {\
+	DECLARE_INTEL_MID_OPS_INIT(penwell, INTEL_MID_CPU_CHIP_PENWELL), \
+	DECLARE_INTEL_MID_OPS_INIT(cloverview, INTEL_MID_CPU_CHIP_CLOVERVIEW), \
+};
+
 #ifdef CONFIG_X86_INTEL_MID
 
 static inline enum intel_mid_cpu_type intel_mid_identify_cpu(void)
@@ -86,8 +115,21 @@ extern enum intel_mid_timer_options intel_mid_timer_options;
  * Penwell uses spread spectrum clock, so the freq number is not exactly
  * the same as reported by MSR based on SDM.
  */
-#define PENWELL_FSB_FREQ_83SKU         83200
-#define PENWELL_FSB_FREQ_100SKU        99840
+#define FSB_FREQ_83SKU	83200
+#define FSB_FREQ_100SKU	99840
+#define FSB_FREQ_133SKU	133000
+
+#define FSB_FREQ_167SKU	167000
+#define FSB_FREQ_200SKU	200000
+#define FSB_FREQ_267SKU	267000
+#define FSB_FREQ_333SKU	333000
+#define FSB_FREQ_400SKU	400000
+
+/* Bus Select SoC Fuse value */
+#define BSEL_SOC_FUSE_MASK	0x7
+#define BSEL_SOC_FUSE_001	0x1 /* FSB 133MHz */
+#define BSEL_SOC_FUSE_101	0x5 /* FSB 100MHz */
+#define BSEL_SOC_FUSE_111	0x7 /* FSB 83MHz */
 
 #define SFI_MTMR_MAX_NUM 8
 #define SFI_MRTC_MAX	8
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 527d6d5..4095584 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -60,14 +60,27 @@
 
 enum intel_mid_timer_options intel_mid_timer_options;
 
+/* intel_mid_ops to store sub arch ops */
+struct intel_mid_ops *intel_mid_ops;
+/* getter function for sub arch ops*/
+static void *(*get_intel_mid_ops[])(void) = INTEL_MID_OPS_INIT;
 enum intel_mid_cpu_type __intel_mid_cpu_chip;
 EXPORT_SYMBOL_GPL(__intel_mid_cpu_chip);
 
+static void intel_mid_power_off(void)
+{
+};
+
 static void intel_mid_reboot(void)
 {
 	intel_scu_ipc_simple_command(IPCMSG_COLD_BOOT, 0);
 }
 
+static unsigned long __init intel_mid_calibrate_tsc(void)
+{
+	return 0;
+}
+
 static void __init intel_mid_time_init(void)
 {
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
@@ -92,13 +105,33 @@ static void __init intel_mid_time_init(void)
 
 static void intel_mid_arch_setup(void)
 {
-	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
-		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
-	else {
+	if (boot_cpu_data.x86 != 6) {
 		pr_err("Unknown Intel MID CPU (%d:%d), default to Penwell\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);
 		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
+		goto out;
+	}
+
+	switch (boot_cpu_data.x86_model) {
+	case 0x35:
+		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_CLOVERVIEW;
+		break;
+	case 0x27:
+	default:
+		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
+		break;
 	}
+
+	if (__intel_mid_cpu_chip < MAX_CPU_OPS(get_intel_mid_ops))
+		intel_mid_ops = get_intel_mid_ops[__intel_mid_cpu_chip]();
+	else {
+		intel_mid_ops = get_intel_mid_ops[INTEL_MID_CPU_CHIP_PENWELL]();
+		pr_info("ARCH: Uknown SoC, assuming PENWELL!\n");
+	}
+
+out:
+	if (intel_mid_ops->arch_setup)
+		intel_mid_ops->arch_setup();
 }
 
 /* MID systems don't have i8042 controller */
diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index 519beb7..9ebce04 100644
--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -11,5 +11,8 @@
 
 
 /* __attribute__((weak)) makes these declarations overridable */
-extern void intel_mid_power_off(void) __attribute__((weak));
-extern unsigned long __init intel_mid_calibrate_tsc(void) __attribute__((weak));
+/* For every CPU addition a new get_<cpuname>_ops interface needs
+ * to be added.
+ */
+extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
+extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
index c7ff83c..4f7884e 100644
--- a/arch/x86/platform/intel-mid/mfld.c
+++ b/arch/x86/platform/intel-mid/mfld.c
@@ -15,11 +15,19 @@
 #include <asm/intel-mid.h>
 #include <asm/intel_mid_vrtc.h>
 
-void intel_mid_power_off(void)
+#include "intel_mid_weak_decls.h"
+
+static void penwell_arch_setup(void);
+/* penwell arch ops */
+static struct intel_mid_ops penwell_ops = {
+	.arch_setup = penwell_arch_setup,
+};
+
+static void mfld_power_off(void)
 {
 }
 
-unsigned long __init intel_mid_calibrate_tsc(void)
+static unsigned long __init mfld_calibrate_tsc(void)
 {
 	unsigned long fast_calibrate;
 	u32 lo, hi, ratio, fsb;
@@ -35,9 +43,9 @@ unsigned long __init intel_mid_calibrate_tsc(void)
 	}
 	rdmsr(MSR_FSB_FREQ, lo, hi);
 	if ((lo & 0x7) == 0x7)
-		fsb = PENWELL_FSB_FREQ_83SKU;
+		fsb = FSB_FREQ_83SKU;
 	else
-		fsb = PENWELL_FSB_FREQ_100SKU;
+		fsb = FSB_FREQ_100SKU;
 	fast_calibrate = ratio * fsb;
 	pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
 	lapic_timer_frequency = fsb * 1000 / HZ;
@@ -49,3 +57,19 @@ unsigned long __init intel_mid_calibrate_tsc(void)
 
 	return 0;
 }
+
+static void __init penwell_arch_setup()
+{
+	x86_platform.calibrate_tsc = mfld_calibrate_tsc;
+	pm_power_off = mfld_power_off;
+}
+
+void * __cpuinit get_penwell_ops()
+{
+	return &penwell_ops;
+}
+
+void * __cpuinit get_cloverview_ops()
+{
+	return &penwell_ops;
+}
