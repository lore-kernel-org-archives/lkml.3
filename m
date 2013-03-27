Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3C0WrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:47:06 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:52667
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab3C0WrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:47:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dI103dKc8kzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCCM6-01-478-02
X-M-MSG: 
Date: Wed, 27 Mar 2013 17:46:52 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130327224652.GB15786@jshin-Toonie>
References: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
 <1364423841-6920-3-git-send-email-jacob.shin@amd.com>
 <20130327224122.GA15786@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130327224122.GA15786@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 05:41:22PM -0500, Jacob Shin wrote:
> On Wed, Mar 27, 2013 at 05:37:21PM -0500, Jacob Shin wrote:

> So sorry .. this file did not get git add'ed. Will resend in a bit

Here is the correct patch 2/2:

Thanks!

---

>From 9b79ef03c72f613dcc0cdd3624a6154cb3e76244 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Fri, 22 Mar 2013 10:32:08 -0500
Subject: [PATCH 2/2] cpufreq: AMD "frequency sensitivity feedback" powersave
 bias for ondemand governor

Future AMD processors, starting with Family 16h, can provide software
with feedback on how the workload may respond to frequency change --
memory-bound workloads will not benefit from higher frequency, where
as compute-bound workloads will. This patch enables this "frequency
sensitivity feedback" to aid the ondemand governor to make better
frequency change decisions by hooking into the powersave bias.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/include/uapi/asm/msr-index.h  |    1 +
 drivers/cpufreq/Kconfig.x86            |   10 +++
 drivers/cpufreq/Makefile               |    1 +
 drivers/cpufreq/amd_freq_sensitivity.c |  149 ++++++++++++++++++++++++++++++++
 4 files changed, 161 insertions(+)
 create mode 100644 drivers/cpufreq/amd_freq_sensitivity.c

diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 7a060f4..b2e6c49 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -173,6 +173,7 @@
 #define MSR_AMD64_TSC_RATIO		0xc0000104
 #define MSR_AMD64_NB_CFG		0xc001001f
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
+#define MSR_AMD64_FREQ_SENSITIVITY	0xc0010080
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD64_DC_CFG		0xc0011022
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index d7dc0ed..6c714b0 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -129,6 +129,16 @@ config X86_POWERNOW_K8
 
 	  For details, take a look at <file:Documentation/cpu-freq/>.
 
+config X86_AMD_FREQ_SENSITIVITY
+	tristate "AMD 'frequency sensitivity feedback' powersave bias"
+	depends on CPU_FREQ_GOV_ONDEMAND && X86_ACPI_CPUFREQ
+	help
+	  This adds support for 'frequency sensitivity feedback' feature on
+	  supported AMD processors, which hooks into the ondemand governor's
+	  powersave bias to influence frequency change decisions.
+
+	  If in doubt, say N.
+
 config X86_GX_SUSPMOD
 	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
 	depends on X86_32 && PCI
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 863fd18..01dfdaf 100644
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
index 0000000..80669ae
--- /dev/null
+++ b/drivers/cpufreq/amd_freq_sensitivity.c
@@ -0,0 +1,149 @@
+/*
+ * amd_freq_sensitivity.c: AMD "frequency sensitivity feedback" powersave bias
+ *                         for ondemand governor.
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+
+#include "cpufreq_governor.h"
+
+#define PROC_FEEDBACK_INTERFACE_SHIFT		11
+#define CLASS_CODE_SHIFT			56
+#define CLASS_CODE_MASK				0xff
+#define CLASS_CODE_CORE_FREQUENCY_SENSITIVITY	0x01
+
+static u32 msr_addr;
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
+		unsigned int freq_next, unsigned int relation)
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
+	rdmsr_on_cpu(policy->cpu, msr_addr, &actual.l, &actual.h);
+	rdmsr_on_cpu(policy->cpu, msr_addr + 1, &reference.l, &reference.h);
+	actual.h &= 0x00ffffff;
+	reference.h &= 0x00ffffff;
+
+	if (!od_info->freq_table)
+		goto out;
+
+	/* counter wrapped around, so push until next check */
+	if (actual.q < data->actual || reference.q < data->reference) {
+		freq_next = policy->cur;
+		goto out;
+	}
+
+	d_actual = actual.q - data->actual;
+	d_reference = reference.q - data->reference;
+
+	/* divide by 0, so push as well */
+	if (d_reference == 0) {
+		freq_next = policy->cur;
+		goto out;
+	}
+
+	sensitivity = 1000 - (1000 * (d_reference - d_actual) / d_reference);
+
+	if (sensitivity > 1000)
+		sensitivity = 1000;
+	else if (sensitivity < 0)
+		sensitivity = 0;
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
+			unsigned int index = 0;
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
+static struct od_ops od_ops = {
+	.powersave_bias_target = amd_powersave_bias_target,
+};
+
+static int __init amd_freq_sensitivity_init(void)
+{
+	int i;
+	u32 eax, edx, dummy;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
+		return -ENODEV;
+
+	cpuid(0x80000007, &eax, &dummy, &dummy, &edx);
+
+	if (!(edx & (1 << PROC_FEEDBACK_INTERFACE_SHIFT)))
+		return -ENODEV;
+
+	for (i = 0; i < (eax & 0xf); i++) {
+		u64 val;
+		u32 addr = MSR_AMD64_FREQ_SENSITIVITY + (i * 2);
+
+		rdmsrl(addr, val);
+
+		if (((val >> CLASS_CODE_SHIFT) & CLASS_CODE_MASK)
+			== CLASS_CODE_CORE_FREQUENCY_SENSITIVITY) {
+			msr_addr = addr;
+			break;
+		}
+	}
+
+	if (!msr_addr)
+		return -ENODEV;
+
+	od_register_ops(&od_ops);
+	return 0;
+}
+
+static void __exit amd_freq_sensitivity_exit(void)
+{
+	od_unregister_ops(&od_ops);
+}
+
+MODULE_AUTHOR("Jacob Shin <jacob.shin@amd.com>");
+MODULE_DESCRIPTION("AMD 'frequency sensitivity feedback' powersave bias for "
+		"the ondemand governor.");
+MODULE_LICENSE("GPL");
+
+module_init(amd_freq_sensitivity_init);
+module_exit(amd_freq_sensitivity_exit);
-- 
1.7.9.5


