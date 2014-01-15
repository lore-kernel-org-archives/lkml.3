Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaAOWnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:43:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbaAOWnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:43:14 -0500
Date: Wed, 15 Jan 2014 14:43:01 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-bc20aa48bbb3068224a1c91f8332971fdb689fad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fei.yang@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, mark.f.brown@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fei.yang@intel.com, david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, mark.f.brown@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1387224459-25746-4-git-send-email-david.a.cohen@linux.intel.com>
References: <1387224459-25746-4-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid:
  Add Merrifield platform support
Git-Commit-ID: bc20aa48bbb3068224a1c91f8332971fdb689fad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 15 Jan 2014 14:43:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc20aa48bbb3068224a1c91f8332971fdb689fad
Gitweb:     http://git.kernel.org/tip/bc20aa48bbb3068224a1c91f8332971fdb689fad
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Mon, 16 Dec 2013 12:07:38 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Jan 2014 14:38:58 -0800

x86, intel-mid: Add Merrifield platform support

This code was partially based on Mark Brown's previous work.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1387224459-25746-4-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: Fei Yang <fei.yang@intel.com>
Cc: Mark F. Brown <mark.f.brown@intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/intel-mid.h                   |   2 +
 arch/x86/pci/intel_mid_pci.c                       |   6 +-
 arch/x86/platform/intel-mid/Makefile               |   2 +-
 arch/x86/platform/intel-mid/intel-mid.c            |   4 +
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |   1 +
 arch/x86/platform/intel-mid/mrfl.c                 | 103 +++++++++++++++++++++
 arch/x86/platform/intel-mid/sfi.c                  |  34 +++++--
 7 files changed, 144 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index f8a8314..e34e097 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -52,6 +52,7 @@ enum intel_mid_cpu_type {
 	/* 1 was Moorestown */
 	INTEL_MID_CPU_CHIP_PENWELL = 2,
 	INTEL_MID_CPU_CHIP_CLOVERVIEW,
+	INTEL_MID_CPU_CHIP_TANGIER,
 };
 
 extern enum intel_mid_cpu_type __intel_mid_cpu_chip;
@@ -82,6 +83,7 @@ struct intel_mid_ops {
 #define INTEL_MID_OPS_INIT {\
 	DECLARE_INTEL_MID_OPS_INIT(penwell, INTEL_MID_CPU_CHIP_PENWELL), \
 	DECLARE_INTEL_MID_OPS_INIT(cloverview, INTEL_MID_CPU_CHIP_CLOVERVIEW), \
+	DECLARE_INTEL_MID_OPS_INIT(tangier, INTEL_MID_CPU_CHIP_TANGIER) \
 };
 
 #ifdef CONFIG_X86_INTEL_MID
diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index 51384ca..84b9d67 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -31,6 +31,7 @@
 #include <asm/pci_x86.h>
 #include <asm/hw_irq.h>
 #include <asm/io_apic.h>
+#include <asm/intel-mid.h>
 
 #define PCIE_CAP_OFFSET	0x100
 
@@ -219,7 +220,10 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
 	irq_attr.ioapic = mp_find_ioapic(dev->irq);
 	irq_attr.ioapic_pin = dev->irq;
 	irq_attr.trigger = 1; /* level */
-	irq_attr.polarity = 1; /* active low */
+	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER)
+		irq_attr.polarity = 0; /* active high */
+	else
+		irq_attr.polarity = 1; /* active low */
 	io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
 
 	return 0;
diff --git a/arch/x86/platform/intel-mid/Makefile b/arch/x86/platform/intel-mid/Makefile
index 78a14ba..0a8ee70 100644
--- a/arch/x86/platform/intel-mid/Makefile
+++ b/arch/x86/platform/intel-mid/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o intel_mid_vrtc.o mfld.o
+obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o intel_mid_vrtc.o mfld.o mrfl.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID) += early_printk_intel_mid.o
 
 # SFI specific code
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 4095584..1bbedc4 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -116,6 +116,10 @@ static void intel_mid_arch_setup(void)
 	case 0x35:
 		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_CLOVERVIEW;
 		break;
+	case 0x3C:
+	case 0x4A:
+		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_TANGIER;
+		break;
 	case 0x27:
 	default:
 		__intel_mid_cpu_chip = INTEL_MID_CPU_CHIP_PENWELL;
diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
index 9ebce04..a537ffc 100644
--- a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -16,3 +16,4 @@
  */
 extern void * __cpuinit get_penwell_ops(void) __attribute__((weak));
 extern void * __cpuinit get_cloverview_ops(void) __attribute__((weak));
+extern void * __init get_tangier_ops(void) __attribute__((weak));
diff --git a/arch/x86/platform/intel-mid/mrfl.c b/arch/x86/platform/intel-mid/mrfl.c
new file mode 100644
index 0000000..09d1015
--- /dev/null
+++ b/arch/x86/platform/intel-mid/mrfl.c
@@ -0,0 +1,103 @@
+/*
+ * mrfl.c: Intel Merrifield platform specific setup code
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
+
+#include "intel_mid_weak_decls.h"
+
+static unsigned long __init tangier_calibrate_tsc(void)
+{
+	unsigned long fast_calibrate;
+	u32 lo, hi, ratio, fsb, bus_freq;
+
+	/* *********************** */
+	/* Compute TSC:Ratio * FSB */
+	/* *********************** */
+
+	/* Compute Ratio */
+	rdmsr(MSR_PLATFORM_INFO, lo, hi);
+	pr_debug("IA32 PLATFORM_INFO is 0x%x : %x\n", hi, lo);
+
+	ratio = (lo >> 8) & 0xFF;
+	pr_debug("ratio is %d\n", ratio);
+	if (!ratio) {
+		pr_err("Read a zero ratio, force tsc ratio to 4 ...\n");
+		ratio = 4;
+	}
+
+	/* Compute FSB */
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	pr_debug("Actual FSB frequency detected by SOC 0x%x : %x\n",
+			hi, lo);
+
+	bus_freq = lo & 0x7;
+	pr_debug("bus_freq = 0x%x\n", bus_freq);
+
+	if (bus_freq == 0)
+		fsb = FSB_FREQ_100SKU;
+	else if (bus_freq == 1)
+		fsb = FSB_FREQ_100SKU;
+	else if (bus_freq == 2)
+		fsb = FSB_FREQ_133SKU;
+	else if (bus_freq == 3)
+		fsb = FSB_FREQ_167SKU;
+	else if (bus_freq == 4)
+		fsb = FSB_FREQ_83SKU;
+	else if (bus_freq == 5)
+		fsb = FSB_FREQ_400SKU;
+	else if (bus_freq == 6)
+		fsb = FSB_FREQ_267SKU;
+	else if (bus_freq == 7)
+		fsb = FSB_FREQ_333SKU;
+	else {
+		BUG();
+		pr_err("Invalid bus_freq! Setting to minimal value!\n");
+		fsb = FSB_FREQ_100SKU;
+	}
+
+	/* TSC = FSB Freq * Resolved HFM Ratio */
+	fast_calibrate = ratio * fsb;
+	pr_debug("calculate tangier tsc %lu KHz\n", fast_calibrate);
+
+	/* ************************************ */
+	/* Calculate Local APIC Timer Frequency */
+	/* ************************************ */
+	lapic_timer_frequency = (fsb * 1000) / HZ;
+
+	pr_debug("Setting lapic_timer_frequency = %d\n",
+			lapic_timer_frequency);
+
+	/* mark tsc clocksource as reliable */
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC_RELIABLE);
+
+	if (fast_calibrate)
+		return fast_calibrate;
+
+	return 0;
+}
+
+static void __init tangier_arch_setup(void)
+{
+	x86_platform.calibrate_tsc = tangier_calibrate_tsc;
+}
+
+/* tangier arch ops */
+static struct intel_mid_ops tangier_ops = {
+	.arch_setup = tangier_arch_setup,
+};
+
+void * __cpuinit get_tangier_ops()
+{
+	return &tangier_ops;
+}
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index c84c1ca..80a5228 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -443,13 +443,35 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 			 * so we have to enable them one by one here
 			 */
 			ioapic = mp_find_ioapic(irq);
-			irq_attr.ioapic = ioapic;
-			irq_attr.ioapic_pin = irq;
-			irq_attr.trigger = 1;
-			irq_attr.polarity = 1;
-			io_apic_set_pci_routing(NULL, irq, &irq_attr);
-		} else
+			if (ioapic >= 0) {
+				irq_attr.ioapic = ioapic;
+				irq_attr.ioapic_pin = irq;
+				irq_attr.trigger = 1;
+				if (intel_mid_identify_cpu() ==
+						INTEL_MID_CPU_CHIP_TANGIER) {
+					if (!strncmp(pentry->name,
+							"r69001-ts-i2c", 13))
+						/* active low */
+						irq_attr.polarity = 1;
+					else if (!strncmp(pentry->name,
+							"synaptics_3202", 14))
+						/* active low */
+						irq_attr.polarity = 1;
+					else if (irq == 41)
+						/* fast_int_1 */
+						irq_attr.polarity = 1;
+					else
+						/* active high */
+						irq_attr.polarity = 0;
+				} else {
+					/* PNW and CLV go with active low */
+					irq_attr.polarity = 1;
+				}
+				io_apic_set_pci_routing(NULL, irq, &irq_attr);
+			}
+		} else {
 			irq = 0; /* No irq */
+		}
 
 		dev = get_device_id(pentry->type, pentry->name);
 
