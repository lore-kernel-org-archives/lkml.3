Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3C1Hl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 03:41:28 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:38210 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3C1Hl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 03:41:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130327224652.GB15786@jshin-Toonie>
References: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
	<1364423841-6920-3-git-send-email-jacob.shin@amd.com>
	<20130327224122.GA15786@jshin-Toonie>
	<20130327224652.GB15786@jshin-Toonie>
Date: Thu, 28 Mar 2013 13:11:25 +0530
Message-ID: <CAKohponxR=7Dekb4FHURvm1nuDVXqkNDd2or8U-qYFSUuDzE0Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: AMD "frequency sensitivity feedback"
 powersave bias for ondemand governor
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 04:16, Jacob Shin <jacob.shin@amd.com> wrote:
> diff --git a/drivers/cpufreq/amd_freq_sensitivity.c b/drivers/cpufreq/amd_freq_sensitivity.c
> +#include <linux/module.h>
> +
> +#include "cpufreq_governor.h"

These two are enough for you?

> +#define PROC_FEEDBACK_INTERFACE_SHIFT          11
> +#define CLASS_CODE_SHIFT                       56
> +#define CLASS_CODE_MASK                                0xff
> +#define CLASS_CODE_CORE_FREQUENCY_SENSITIVITY  0x01
> +
> +static u32 msr_addr;
> +
> +struct cpu_data_t {
> +       u64 actual;
> +       u64 reference;

types.h

> +       unsigned int freq_prev;
> +};
> +
> +static DEFINE_PER_CPU(struct cpu_data_t, cpu_data);

include/linux/percpu.h

> +static unsigned int amd_powersave_bias_target(struct cpufreq_policy *policy,
> +               unsigned int freq_next, unsigned int relation)
> +{
> +       int sensitivity;
> +       long d_actual, d_reference;
> +       struct msr actual, reference;
> +       struct cpu_data_t *data = &per_cpu(cpu_data, policy->cpu);
> +       struct dbs_data *od_data = policy->governor_data;
> +       struct od_dbs_tuners *od_tuners = od_data->tuners;
> +       struct od_cpu_dbs_info_s *od_info =
> +               od_data->cdata->get_cpu_dbs_info_s(policy->cpu);
> +
> +       rdmsr_on_cpu(policy->cpu, msr_addr, &actual.l, &actual.h);
> +       rdmsr_on_cpu(policy->cpu, msr_addr + 1, &reference.l, &reference.h);
> +       actual.h &= 0x00ffffff;
> +       reference.h &= 0x00ffffff;
> +
> +       if (!od_info->freq_table)
> +               goto out;
> +
> +       /* counter wrapped around, so push until next check */
> +       if (actual.q < data->actual || reference.q < data->reference) {
> +               freq_next = policy->cur;
> +               goto out;
> +       }
> +
> +       d_actual = actual.q - data->actual;
> +       d_reference = reference.q - data->reference;
> +
> +       /* divide by 0, so push as well */
> +       if (d_reference == 0) {
> +               freq_next = policy->cur;
> +               goto out;
> +       }
> +
> +       sensitivity = 1000 - (1000 * (d_reference - d_actual) / d_reference);
> +
> +       if (sensitivity > 1000)
> +               sensitivity = 1000;
> +       else if (sensitivity < 0)
> +               sensitivity = 0;
> +
> +       /* this workload is not CPU bound, so choose a lower freq */
> +       if (sensitivity < od_tuners->powersave_bias) {
> +               if (data->freq_prev == policy->cur)
> +                       freq_next = policy->cur;
> +
> +               if (freq_next > policy->cur)
> +                       freq_next = policy->cur;
> +               else if (freq_next < policy->cur)
> +                       freq_next = policy->min;
> +               else {
> +                       unsigned int index = 0;
> +
> +                       cpufreq_frequency_table_target(policy,
> +                               od_info->freq_table, policy->cur - 1,
> +                               CPUFREQ_RELATION_H, &index);
> +                       freq_next = od_info->freq_table[index].frequency;
> +               }
> +
> +               data->freq_prev = freq_next;
> +       } else
> +               data->freq_prev = 0;
> +
> +out:
> +       data->actual = actual.q;
> +       data->reference = reference.q;
> +       return freq_next;
> +}
> +
> +static struct od_ops od_ops = {
> +       .powersave_bias_target = amd_powersave_bias_target,
> +};
> +
> +static int __init amd_freq_sensitivity_init(void)

include/linux/init.h

> +{
> +       int i;
> +       u32 eax, edx, dummy;
> +
> +       if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
> +               return -ENODEV;
> +
> +       cpuid(0x80000007, &eax, &dummy, &dummy, &edx);
> +
> +       if (!(edx & (1 << PROC_FEEDBACK_INTERFACE_SHIFT)))
> +               return -ENODEV;
> +
> +       for (i = 0; i < (eax & 0xf); i++) {
> +               u64 val;
> +               u32 addr = MSR_AMD64_FREQ_SENSITIVITY + (i * 2);
> +
> +               rdmsrl(addr, val);
> +
> +               if (((val >> CLASS_CODE_SHIFT) & CLASS_CODE_MASK)
> +                       == CLASS_CODE_CORE_FREQUENCY_SENSITIVITY) {
> +                       msr_addr = addr;
> +                       break;
> +               }
> +       }
> +
> +       if (!msr_addr)
> +               return -ENODEV;
> +
> +       od_register_ops(&od_ops);
> +       return 0;
> +}
> +
> +static void __exit amd_freq_sensitivity_exit(void)
> +{
> +       od_unregister_ops(&od_ops);
> +}
> +
> +MODULE_AUTHOR("Jacob Shin <jacob.shin@amd.com>");
> +MODULE_DESCRIPTION("AMD 'frequency sensitivity feedback' powersave bias for "
> +               "the ondemand governor.");
> +MODULE_LICENSE("GPL");
> +
> +module_init(amd_freq_sensitivity_init);
> +module_exit(amd_freq_sensitivity_exit);

Add them directly below their respective routines without a blank line
inbetween.
