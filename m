Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762173Ab3DBTX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:23:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49859 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761237Ab3DBTX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:23:56 -0400
Date: Tue, 2 Apr 2013 21:23:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH V3 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
Message-ID: <20130402192352.GC17675@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Thomas Renninger <trenn@suse.de>
References: <1364926304-1799-1-git-send-email-jacob.shin@amd.com>
 <1364926304-1799-3-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1364926304-1799-3-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:11:44PM -0500, Jacob Shin wrote:
> Future AMD processors, starting with Family 16h, can provide software
> with feedback on how the workload may respond to frequency change --
> memory-bound workloads will not benefit from higher frequency, where
> as compute-bound workloads will. This patch enables this "frequency
> sensitivity feedback" to aid the ondemand governor to make better
> frequency change decisions by hooking into the powersave bias.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---

[ … ]

> --- a/drivers/cpufreq/Kconfig.x86
> +++ b/drivers/cpufreq/Kconfig.x86
> @@ -129,6 +129,23 @@ config X86_POWERNOW_K8
>  
>  	  For details, take a look at <file:Documentation/cpu-freq/>.
>  
> +config X86_AMD_FREQ_SENSITIVITY

/me is turning on his spell checker...

> +	tristate "AMD frequency sensitivity feedback powersave bias"
> +	depends on CPU_FREQ_GOV_ONDEMAND && X86_ACPI_CPUFREQ && CPU_SUP_AMD
> +	help
> +	  This adds AMD specific powersave bias function to the ondemand

		    AMD-specific

> +	  governor; which can be used to help ondemand governor make more power

	  "... governor, which allows it to make more power-conscious frequency
	  change decisions based on ..."

> +	  conscious frequency change decisions based on feedback from hardware
> +	  (availble on AMD Family 16h and above).

s/availble/available/

> +
> +	  Hardware feedback tells software how "sensitive" to frequency changes
> +	  the CPUs' workloads are. CPU-bound workloads will be more sensitive
> +	  -- they will perform better as frequency increases. Memory/IO-bound
> +	  workloads will be less sensitive -- they will not necessarily perform
> +	  better as frequnecy increases.

s/frequnecy/frequency/

> +
> +	  If in doubt, say N.
> +
>  config X86_GX_SUSPMOD
>  	tristate "Cyrix MediaGX/NatSemi Geode Suspend Modulation"
>  	depends on X86_32 && PCI
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 863fd18..01dfdaf 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
>  obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
>  obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
>  obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
> +obj-$(CONFIG_X86_AMD_FREQ_SENSITIVITY)	+= amd_freq_sensitivity.o
>  
>  ##################################################################################
>  # ARM SoC drivers
> diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
> new file mode 100644
> index 0000000..e3e62d2
> --- /dev/null
> +++ b/drivers/cpufreq/amd_freq_sensitivity.c
> @@ -0,0 +1,150 @@
> +/*
> + * amd_freq_sensitivity.c: AMD frequency sensitivity feedback powersave bias
> + *                         for the ondemand governor.
> + *
> + * Copyright (C) 2013 Advanced Micro Devices, Inc.
> + *
> + * Author: Jacob Shin <jacob.shin@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/percpu-defs.h>
> +#include <linux/init.h>
> +#include <linux/mod_devicetable.h>
> +
> +#include <asm/msr.h>
> +#include <asm/cpufeature.h>
> +
> +#include "cpufreq_governor.h"
> +
> +#define MSR_AMD64_FREQ_SENSITIVITY_ACTUAL	0xc0010080
> +#define MSR_AMD64_FREQ_SENSITIVITY_REFERENCE	0xc0010081
> +#define CLASS_CODE_SHIFT			56
> +#define CLASS_CODE_CORE_FREQ_SENSITIVITY	0x01
> +#define POWERSAVE_BIAS_MAX			1000
> +
> +struct cpu_data_t {
> +	u64 actual;
> +	u64 reference;
> +	unsigned int freq_prev;
> +};
> +
> +static DEFINE_PER_CPU(struct cpu_data_t, cpu_data);
> +
> +static unsigned int amd_powersave_bias_target(struct cpufreq_policy *policy,
> +					      unsigned int freq_next,
> +					      unsigned int relation)
> +{
> +	int sensitivity;
> +	long d_actual, d_reference;
> +	struct msr actual, reference;
> +	struct cpu_data_t *data = &per_cpu(cpu_data, policy->cpu);
> +	struct dbs_data *od_data = policy->governor_data;
> +	struct od_dbs_tuners *od_tuners = od_data->tuners;
> +	struct od_cpu_dbs_info_s *od_info =
> +		od_data->cdata->get_cpu_dbs_info_s(policy->cpu);
> +
> +	if (!od_info->freq_table)
> +		return freq_next;
> +
> +	rdmsr_on_cpu(policy->cpu, MSR_AMD64_FREQ_SENSITIVITY_ACTUAL,
> +		&actual.l, &actual.h);
> +	rdmsr_on_cpu(policy->cpu, MSR_AMD64_FREQ_SENSITIVITY_REFERENCE,
> +		&reference.l, &reference.h);
> +	actual.h &= 0x00ffffff;
> +	reference.h &= 0x00ffffff;
> +
> +	/* counter wrapped around, so stay on current frequency */
> +	if (actual.q < data->actual || reference.q < data->reference) {
> +		freq_next = policy->cur;
> +		goto out;
> +	}
> +
> +	d_actual = actual.q - data->actual;
> +	d_reference = reference.q - data->reference;
> +
> +	/* divide by 0, so stay on current frequency as well */
> +	if (d_reference == 0) {
> +		freq_next = policy->cur;
> +		goto out;
> +	}
> +
> +	sensitivity = POWERSAVE_BIAS_MAX -
> +		(POWERSAVE_BIAS_MAX * (d_reference - d_actual) / d_reference);
> +
> +	clamp(sensitivity, 0, POWERSAVE_BIAS_MAX);
> +
> +	/* this workload is not CPU bound, so choose a lower freq */
> +	if (sensitivity < od_tuners->powersave_bias) {

Ok, I still didn't get an answer to that: don't we want to use this
feature by default, even without looking at ->powersave_bias? I mean,
with feedback from the hardware, we kinda know better than the user, no?

> +		if (data->freq_prev == policy->cur)
> +			freq_next = policy->cur;
> +
> +		if (freq_next > policy->cur)
> +			freq_next = policy->cur;
> +		else if (freq_next < policy->cur)
> +			freq_next = policy->min;
> +		else {
> +			unsigned int index;
> +
> +			cpufreq_frequency_table_target(policy,
> +				od_info->freq_table, policy->cur - 1,
> +				CPUFREQ_RELATION_H, &index);
> +			freq_next = od_info->freq_table[index].frequency;
> +		}
> +
> +		data->freq_prev = freq_next;
> +	} else
> +		data->freq_prev = 0;
> +
> +out:
> +	data->actual = actual.q;
> +	data->reference = reference.q;
> +	return freq_next;
> +}
> +
> +static int __init amd_freq_sensitivity_init(void)
> +{
> +	int err;
> +	u64 val;
> +
> +	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> +		return -ENODEV;
> +
> +	if (!static_cpu_has(X86_FEATURE_PROC_FEEDBACK))
> +		return -ENODEV;
> +
> +	err = rdmsrl_safe(MSR_AMD64_FREQ_SENSITIVITY_ACTUAL, &val);
> +

extraneous newline.

> +	if (err)
> +		return -ENODEV;
> +
> +	if ((val >> CLASS_CODE_SHIFT) != CLASS_CODE_CORE_FREQ_SENSITIVITY)
> +		return -ENODEV;

If this CLASS_CODE_CORE_FREQ_SENSITIVITY is always going to be a
non-null value, you can simplify the check even more, as I proposed
earlier:

	if (val >> CLASS_CODE_SHIFT)
		...

and drop CLASS_CODE_CORE_FREQ_SENSITIVITY.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
