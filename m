Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaAPGbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:31:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPGa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:30:56 -0500
Date: Wed, 15 Jan 2014 22:30:44 -0800
From: tip-bot for Bin Gao <tipbot@zytor.com>
Message-ID: <tip-rgm7xmg7k6qnjlw3ynkcjsmh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bin.gao@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bin.gao@intel.com, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, tsc: Add static (MSR)
  TSC calibration on Intel Atom SoCs
Git-Commit-ID: 7da7c1561366ba8adb7275464ab44e84e1faa7e0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 15 Jan 2014 22:30:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7da7c1561366ba8adb7275464ab44e84e1faa7e0
Gitweb:     http://git.kernel.org/tip/7da7c1561366ba8adb7275464ab44e84e1faa7e0
Author:     Bin Gao <bin.gao@intel.com>
AuthorDate: Mon, 21 Oct 2013 09:16:33 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Jan 2014 22:28:48 -0800

x86, tsc: Add static (MSR) TSC calibration on Intel Atom SoCs

On SoCs that have the calibration MSRs available, either there is no
PIT, HPET or PMTIMER to calibrate against, or the PIT/HPET/PMTIMER is
driven from the same clock as the TSC, so calibration is redundant and
just slows down the boot.

TSC rate is caculated by this formula:
<maximum core-clock to bus-clock ratio> * <maximum resolved frequency>
The ratio and the resolved frequency ID can be obtained from MSR.
See Intel 64 and IA-32 System Programming Guid section 16.12 and 30.11.5
for details.

Signed-off-by: Bin Gao <bin.gao@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-rgm7xmg7k6qnjlw3ynkcjsmh@git.kernel.org
---
 arch/x86/include/asm/tsc.h |   3 ++
 arch/x86/kernel/Makefile   |   2 +-
 arch/x86/kernel/tsc.c      |  10 ++++
 arch/x86/kernel/tsc_msr.c  | 125 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 235be70..57ae63c 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -65,4 +65,7 @@ extern int notsc_setup(char *);
 extern void tsc_save_sched_clock_state(void);
 extern void tsc_restore_sched_clock_state(void);
 
+/* MSR based TSC calibration for Intel Atom SoC platforms */
+int try_msr_calibrate_tsc(unsigned long *fast_calibrate);
+
 #endif /* _ASM_X86_TSC_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index dbe9bd6..6dbbb1e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -32,7 +32,7 @@ obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
-obj-y			+= tsc.o io_delay.o rtc.o
+obj-y			+= tsc.o tsc_msr.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 930e5d4..e574716 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -419,6 +419,16 @@ unsigned long native_calibrate_tsc(void)
 	unsigned long flags, latch, ms, fast_calibrate;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
+	/* Calibrate TSC using MSR for Intel Atom SoCs */
+	local_irq_save(flags);
+	i = try_msr_calibrate_tsc(&fast_calibrate);
+	local_irq_restore(flags);
+	if (i >= 0) {
+		if (i == 0)
+			pr_warn("Fast TSC calibration using MSR failed\n");
+		return fast_calibrate;
+	}
+
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);
diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
new file mode 100644
index 0000000..c502772
--- /dev/null
+++ b/arch/x86/kernel/tsc_msr.c
@@ -0,0 +1,125 @@
+/*
+ * tsc_msr.c - MSR based TSC calibration on Intel Atom SoC platforms.
+ *
+ * TSC in Intel Atom SoC runs at a constant rate which can be figured
+ * by this formula:
+ * <maximum core-clock to bus-clock ratio> * <maximum resolved frequency>
+ * See Intel 64 and IA-32 System Programming Guid section 16.12 and 30.11.5
+ * for details.
+ * Especially some Intel Atom SoCs don't have PIT(i8254) or HPET, so MSR
+ * based calibration is the only option.
+ *
+ *
+ * Copyright (C) 2013 Intel Corporation
+ * Author: Bin Gao <bin.gao@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <asm/processor.h>
+#include <asm/setup.h>
+#include <asm/apic.h>
+#include <asm/param.h>
+
+/* CPU reference clock frequency: in KHz */
+#define FREQ_83		83200
+#define FREQ_100	99840
+#define FREQ_133	133200
+#define FREQ_166	166400
+
+#define MAX_NUM_FREQS	8
+
+/*
+ * According to Intel 64 and IA-32 System Programming Guide,
+ * if MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
+ * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
+ * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
+ * so we need manually differentiate SoC families. This is what the
+ * field msr_plat does.
+ */
+struct freq_desc {
+	u8 x86_family;	/* CPU family */
+	u8 x86_model;	/* model */
+	u8 msr_plat;	/* 1: use MSR_PLATFORM_INFO, 0: MSR_IA32_PERF_STATUS */
+	u32 freqs[MAX_NUM_FREQS];
+};
+
+static struct freq_desc freq_desc_tables[] = {
+	/* PNW */
+	{ 6, 0x27, 0, { 0, 0, 0, 0, 0, FREQ_100, 0, FREQ_83 } },
+	/* CLV+ */
+	{ 6, 0x35, 0, { 0, FREQ_133, 0, 0, 0, FREQ_100, 0, FREQ_83 } },
+	/* TNG */
+	{ 6, 0x4a, 1, { 0, FREQ_100, FREQ_133, 0, 0, 0, 0, 0 } },
+	/* VLV2 */
+	{ 6, 0x37, 1, { 0, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
+	/* ANN */
+	{ 6, 0x5a, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_100, 0, 0, 0, 0 } },
+};
+
+static int match_cpu(u8 family, u8 model)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(freq_desc_tables); i++) {
+		if ((family == freq_desc_tables[i].x86_family) &&
+			(model == freq_desc_tables[i].x86_model))
+			return i;
+	}
+
+	return -1;
+}
+
+/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz) */
+#define id_to_freq(cpu_index, freq_id) \
+	(freq_desc_tables[cpu_index].freqs[freq_id])
+
+/*
+ * Do MSR calibration only for known/supported CPUs.
+ * Return values:
+ * -1: CPU is unknown/unsupported for MSR based calibration
+ *  0: CPU is known/supported, but calibration failed
+ *  1: CPU is known/supported, and calibration succeeded
+ */
+int try_msr_calibrate_tsc(unsigned long *fast_calibrate)
+{
+	int cpu_index;
+	u32 lo, hi, ratio, freq_id, freq;
+
+	cpu_index = match_cpu(boot_cpu_data.x86, boot_cpu_data.x86_model);
+	if (cpu_index < 0)
+		return -1;
+
+	*fast_calibrate = 0;
+
+	if (freq_desc_tables[cpu_index].msr_plat) {
+		rdmsr(MSR_PLATFORM_INFO, lo, hi);
+		ratio = (lo >> 8) & 0x1f;
+	} else {
+		rdmsr(MSR_IA32_PERF_STATUS, lo, hi);
+		ratio = (hi >> 8) & 0x1f;
+	}
+	pr_info("Maximum core-clock to bus-clock ratio: 0x%x\n", ratio);
+
+	if (!ratio)
+		return 0;
+
+	/* Get FSB FREQ ID */
+	rdmsr(MSR_FSB_FREQ, lo, hi);
+	freq_id = lo & 0x7;
+	freq = id_to_freq(cpu_index, freq_id);
+	pr_info("Resolved frequency ID: %u, frequency: %u KHz\n",
+				freq_id, freq);
+	if (!freq)
+		return 0;
+
+	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
+	*fast_calibrate = freq * ratio;
+	pr_info("TSC runs at %lu KHz\n", *fast_calibrate);
+
+	lapic_timer_frequency = (freq * 1000) / HZ;
+	pr_info("lapic_timer_frequency = %d\n", lapic_timer_frequency);
+
+	return 1;
+}
