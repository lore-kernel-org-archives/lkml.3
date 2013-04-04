Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763001Ab3DDQT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:19:26 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:31878
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762956Ab3DDQTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:19:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKQNZR-02-9F0-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@alien8.de>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V4 2/2] cpufreq: AMD "frequency sensitivity feedback" powersave bias for ondemand governor
Date: Thu, 4 Apr 2013 11:19:04 -0500
Message-ID: <1365092344-11310-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Future AMD processors, starting with Family 16h, can provide software
with feedback on how the workload may respond to frequency change --
memory-bound workloads will not benefit from higher frequency, where
as compute-bound workloads will. This patch enables this "frequency
sensitivity feedback" to aid the ondemand governor to make better
frequency change decisions by hooking into the powersave bias.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 Documentation/cpu-freq/governors.txt   |   21 +++++
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/kernel/cpu/scattered.c        |    3 +-
 drivers/cpufreq/Kconfig.x86            |   17 ++++
 drivers/cpufreq/Makefile               |    1 +
 drivers/cpufreq/amd_freq_sensitivity.c |  148 ++++++++++++++++++++++++++++++++
 6 files changed, 190 insertions(+), 1 deletion(-)
 create mode 100644 drivers/cpufreq/amd_freq_sensitivity.c

diff --git a/Documentation/cpu-freq/governors.txt b/Documentation/cpu-freq/governors.txt
index 4dfed30..66f9cc3 100644
--- a/Documentation/cpu-freq/governors.txt
+++ b/Documentation/cpu-freq/governors.txt
@@ -167,6 +167,27 @@ of load evaluation and helping the CPU stay at its top speed when truly
 busy, rather than shifting back and forth in speed. This tunable has no
 effect on behavior at lower speeds/lower CPU loads.
 
+powersave_bias: this parameter takes a value between 0 to 1000. It
+defines the percentage (times 10) value of the target frequency that
+will be shaved off of the target. For example, when set to 100 -- 10%,
+when ondemand governor would have targeted 1000 MHz, it will target
+1000 MHz - (10% of 1000 MHz) = 900 MHz instead. This is set to 0
+(disabled) by default.
+When AMD frequency sensitivity powersave bias driver --
+drivers/cpufreq/amd_freq_sensitivity.c is loaded, this parameter
+defines the workload frequency sensitivity threshold in which a lower
+frequency is chosen instead of ondemand governor's original target.
+The frequency sensitivity is a hardware reported (on AMD Family 16h
+Processors and above) value between 0 to 100% that tells software how
+the performance of the workload running on a CPU will change when
+frequency changes. A workload with sensitivity of 0% (memory/IO-bound)
+will not perform any better on higher core frequency, whereas a
+workload with sensitivity of 100% (CPU-bound) will perform better
+higher the frequency. When the driver is loaded, this is set to 400
+by default -- for CPUs running workloads with sensitivity value below
+40%, a lower frequency is chosen. Unloading the driver or writing 0
+will disable this feature.
+
 
 2.5 Conservative
 ----------------
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 93fe929..9e22520 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -182,6 +182,7 @@
 #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
 #define X86_FEATURE_DTHERM	(7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	(7*32+ 8) /* AMD HW-PState */
+#define X86_FEATURE_PROC_FEEDBACK (7*32+ 9) /* AMD ProcFeedbackInterface */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index ee8e9ab..d92b5da 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -39,8 +39,9 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
-		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
+		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
+		{ X86_FEATURE_PROC_FEEDBACK,	CR_EDX,11, 0x80000007, 0 },
 		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },
 		{ X86_FEATURE_LBRV,		CR_EDX, 1, 0x8000000a, 0 },
 		{ X86_FEATURE_SVML,		CR_EDX, 2, 0x8000000a, 0 },
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index d7dc0ed..2b8a8c3 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -129,6 +129,23 @@ config X86_POWERNOW_K8
 
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
+config X86_AMD_FREQ_SENSITIVITY
+	tristate "AMD frequency sensitivity feedback powersave bias"
+	depends on CPU_FREQ_GOV_ONDEMAND && X86_ACPI_CPUFREQ && CPU_SUP_AMD
+	help
+	  This adds AMD-specific powersave bias function to the ondemand
+	  governor, which allows it to make more power-conscious frequency
+	  change decisions based on feedback from hardware (availble on AMD
+	  Family 16h and above).
+
+	  Hardware feedback tells software how "sensitive" to frequency changes
+	  the CPUs' workloads are. CPU-bound workloads will be more sensitive
+	  -- they will perform better as frequency increases. Memory/IO-bound
+	  workloads will be less sensitive -- they will not necessarily perform
+	  better as frequency increases.
+
+	  If in doubt, say N.
+
 config X86_GX_SUSPMOD
 	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
 	depends on X86_32 && PCI
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index ba9a3e1..aea81f2 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
 obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
 obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
+obj-$(CONFIG_X86_AMD_FREQ_SENSITIVITY)	+= amd_freq_sensitivity.o
 
 ##################################################################################
 # ARM SoC drivers
diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
new file mode 100644
index 0000000..f6b79ab
--- /dev/null
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -0,0 +1,148 @@
+/*
+ * amd_freq_sensitivity.c: AMD frequency sensitivity feedback powersave bias
+ *                         for the ondemand governor.
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Jacob Shin <jacob.shin@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/percpu-defs.h>
+#include <linux/init.h>
+#include <linux/mod_devicetable.h>
+
+#include <asm/msr.h>
+#include <asm/cpufeature.h>
+
+#include "cpufreq_governor.h"
+
+#define MSR_AMD64_FREQ_SENSITIVITY_ACTUAL	0xc0010080
+#define MSR_AMD64_FREQ_SENSITIVITY_REFERENCE	0xc0010081
+#define CLASS_CODE_SHIFT			56
+#define POWERSAVE_BIAS_MAX			1000
+#define POWERSAVE_BIAS_DEF			400
+
+struct cpu_data_t {
+	u64 actual;
+	u64 reference;
+	unsigned int freq_prev;
+};
+
+static DEFINE_PER_CPU(struct cpu_data_t, cpu_data);
+
+static unsigned int amd_powersave_bias_target(struct cpufreq_policy *policy,
+					      unsigned int freq_next,
+					      unsigned int relation)
+{
+	int sensitivity;
+	long d_actual, d_reference;
+	struct msr actual, reference;
+	struct cpu_data_t *data = &per_cpu(cpu_data, policy->cpu);
+	struct dbs_data *od_data = policy->governor_data;
+	struct od_dbs_tuners *od_tuners = od_data->tuners;
+	struct od_cpu_dbs_info_s *od_info =
+		od_data->cdata->get_cpu_dbs_info_s(policy->cpu);
+
+	if (!od_info->freq_table)
+		return freq_next;
+
+	rdmsr_on_cpu(policy->cpu, MSR_AMD64_FREQ_SENSITIVITY_ACTUAL,
+		&actual.l, &actual.h);
+	rdmsr_on_cpu(policy->cpu, MSR_AMD64_FREQ_SENSITIVITY_REFERENCE,
+		&reference.l, &reference.h);
+	actual.h &= 0x00ffffff;
+	reference.h &= 0x00ffffff;
+
+	/* counter wrapped around, so stay on current frequency */
+	if (actual.q < data->actual || reference.q < data->reference) {
+		freq_next = policy->cur;
+		goto out;
+	}
+
+	d_actual = actual.q - data->actual;
+	d_reference = reference.q - data->reference;
+
+	/* divide by 0, so stay on current frequency as well */
+	if (d_reference == 0) {
+		freq_next = policy->cur;
+		goto out;
+	}
+
+	sensitivity = POWERSAVE_BIAS_MAX -
+		(POWERSAVE_BIAS_MAX * (d_reference - d_actual) / d_reference);
+
+	clamp(sensitivity, 0, POWERSAVE_BIAS_MAX);
+
+	/* this workload is not CPU bound, so choose a lower freq */
+	if (sensitivity < od_tuners->powersave_bias) {
+		if (data->freq_prev == policy->cur)
+			freq_next = policy->cur;
+
+		if (freq_next > policy->cur)
+			freq_next = policy->cur;
+		else if (freq_next < policy->cur)
+			freq_next = policy->min;
+		else {
+			unsigned int index;
+
+			cpufreq_frequency_table_target(policy,
+				od_info->freq_table, policy->cur - 1,
+				CPUFREQ_RELATION_H, &index);
+			freq_next = od_info->freq_table[index].frequency;
+		}
+
+		data->freq_prev = freq_next;
+	} else
+		data->freq_prev = 0;
+
+out:
+	data->actual = actual.q;
+	data->reference = reference.q;
+	return freq_next;
+}
+
+static int __init amd_freq_sensitivity_init(void)
+{
+	u64 val;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return -ENODEV;
+
+	if (!static_cpu_has(X86_FEATURE_PROC_FEEDBACK))
+		return -ENODEV;
+
+	if (rdmsrl_safe(MSR_AMD64_FREQ_SENSITIVITY_ACTUAL, &val))
+		return -ENODEV;
+
+	if (!(val >> CLASS_CODE_SHIFT))
+		return -ENODEV;
+
+	od_register_powersave_bias_handler(amd_powersave_bias_target,
+			POWERSAVE_BIAS_DEF);
+	return 0;
+}
+late_initcall(amd_freq_sensitivity_init);
+
+static void __exit amd_freq_sensitivity_exit(void)
+{
+	od_unregister_powersave_bias_handler();
+}
+module_exit(amd_freq_sensitivity_exit);
+
+static const struct x86_cpu_id amd_freq_sensitivity_ids[] = {
+	X86_FEATURE_MATCH(X86_FEATURE_PROC_FEEDBACK),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, amd_freq_sensitivity_ids);
+
+MODULE_AUTHOR("Jacob Shin <jacob.shin@amd.com>");
+MODULE_DESCRIPTION("AMD frequency sensitivity feedback powersave bias for "
+		"the ondemand governor.");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5


