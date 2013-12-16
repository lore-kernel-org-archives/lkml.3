Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3LPUEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:04:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:26898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab3LPUC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:02:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,496,1384329600"; 
   d="scan'208";a="453170456"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: bhelgaas@google.com, david.a.cohen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH v2 1/4] x86: intel-mid: move Medfield code out of intel-mid.c core file
Date: Mon, 16 Dec 2013 12:07:36 -0800
Message-Id: <1387224459-25746-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order make the driver more portable and support other Intel Mid
platforms we need to move Medfield code from intel-mid.c core to its own
mfld.c file.

This patch does no functional change.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/platform/intel-mid/Makefile               |  4 +-
 arch/x86/platform/intel-mid/intel-mid.c            | 37 +---------------
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h | 15 +++++++
 arch/x86/platform/intel-mid/mfld.c                 | 51 ++++++++++++++++++++++
 4 files changed, 70 insertions(+), 37 deletions(-)
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_weak_decls.h
 create mode 100644 arch/x86/platform/intel-mid/mfld.c

diff --git a/arch/x86/platform/intel-mid/Makefile b/arch/x86/platform/intel-mid/Makefile
index 01cc29ea5ff7..78a14ba0e0db 100644
--- a/arch/x86/platform/intel-mid/Makefile
+++ b/arch/x86/platform/intel-mid/Makefile
@@ -1,6 +1,6 @@
-obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o
-obj-$(CONFIG_X86_INTEL_MID) += intel_mid_vrtc.o
+obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o intel_mid_vrtc.o mfld.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID) += early_printk_intel_mid.o
+
 # SFI specific code
 ifdef CONFIG_X86_INTEL_MID
 obj-$(CONFIG_SFI) += sfi.o device_libs/
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index f90e290f689f..527d6d50643d 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -35,6 +35,8 @@
 #include <asm/apb_timer.h>
 #include <asm/reboot.h>
 
+#include "intel_mid_weak_decls.h"
+
 /*
  * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
  * cmdline option x86_intel_mid_timer can be used to override the configuration
@@ -61,46 +63,11 @@ enum intel_mid_timer_options intel_mid_timer_options;
 enum intel_mid_cpu_type __intel_mid_cpu_chip;
 EXPORT_SYMBOL_GPL(__intel_mid_cpu_chip);
 
-static void intel_mid_power_off(void)
-{
-}
-
 static void intel_mid_reboot(void)
 {
 	intel_scu_ipc_simple_command(IPCMSG_COLD_BOOT, 0);
 }
 
-static unsigned long __init intel_mid_calibrate_tsc(void)
-{
-	unsigned long fast_calibrate;
-	u32 lo, hi, ratio, fsb;
-
-	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
-	pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
-	ratio = (hi >> 8) & 0x1f;
-	pr_debug("ratio is %d\n", ratio);
-	if (!ratio) {
-		pr_err("read a zero ratio, should be incorrect!\n");
-		pr_err("force tsc ratio to 16 ...\n");
-		ratio = 16;
-	}
-	rdmsr(MSR_FSB_FREQ, lo, hi);
-	if ((lo & 0x7) == 0x7)
-		fsb = PENWELL_FSB_FREQ_83SKU;
-	else
-		fsb = PENWELL_FSB_FREQ_100SKU;
-	fast_calibrate = ratio * fsb;
-	pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
-	lapic_timer_frequency = fsb * 1000 / HZ;
-	/* mark tsc clocksource as reliable */
-	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
-
-	if (fast_calibrate)
-		return fast_calibrate;
-
-	return 0;
-}
-
 static void __init intel_mid_time_init(void)
 {
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
new file mode 100644
index 000000000000..519beb75ba4c
--- /dev/null
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -0,0 +1,15 @@
+/*
+ * intel_mid_weak_decls.h: Weak declarations of intel-mid.c
+ *
+ * (C) Copyright 2013 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
+/* __attribute__((weak)) makes these declarations overridable */
+extern void intel_mid_power_off(void) __attribute__((weak));
+extern unsigned long __init intel_mid_calibrate_tsc(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mfld.c b/arch/x86/platform/intel-mid/mfld.c
new file mode 100644
index 000000000000..c7ff83c4576d
--- /dev/null
+++ b/arch/x86/platform/intel-mid/mfld.c
@@ -0,0 +1,51 @@
+/*
+ * mfld.c: Intel Medfield platform setup code
+ *
+ * (C) Copyright 2013 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+
+#include <asm/apic.h>
+#include <asm/intel-mid.h>
+#include <asm/intel_mid_vrtc.h>
+
+void intel_mid_power_off(void)
+{
+}
+
+unsigned long __init intel_mid_calibrate_tsc(void)
+{
+	unsigned long fast_calibrate;
+	u32 lo, hi, ratio, fsb;
+
+	rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
+	pr_debug("IA32 perf status is 0x%x, 0x%0x\n", lo, hi);
+	ratio = (hi >> 8) & 0x1f;
+	pr_debug("ratio is %d\n", ratio);
+	if (!ratio) {
+		pr_err("read a zero ratio, should be incorrect!\n");
+		pr_err("force tsc ratio to 16 ...\n");
+		ratio = 16;
+	}
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	if ((lo & 0x7) == 0x7)
+		fsb = PENWELL_FSB_FREQ_83SKU;
+	else
+		fsb = PENWELL_FSB_FREQ_100SKU;
+	fast_calibrate = ratio * fsb;
+	pr_debug("read penwell tsc %lu khz\n", fast_calibrate);
+	lapic_timer_frequency = fsb * 1000 / HZ;
+	/* mark tsc clocksource as reliable */
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
+
+	if (fast_calibrate)
+		return fast_calibrate;
+
+	return 0;
+}
-- 
1.8.4.2

