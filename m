Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaLHFtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:49:04 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:55574 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaLHFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:49:01 -0500
MIME-Version: 1.0
In-Reply-To: <1417806260-9264-7-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
	<1417806260-9264-7-git-send-email-javi.merino@arm.com>
Date: Mon, 8 Dec 2014 11:19:00 +0530
X-Google-Sender-Auth: T_5H8VZqzTSUhYfevX5bfXr3I_4
Message-ID: <CAOh2x==BKyS08th2d4r0Q2UGqhzAwj6sqOgFsH6J0pWup+OU_A@mail.gmail.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        punit.agrawal@arm.com, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javi,

Looks like ARM's exchange server screwed up your patch?

This is how I see it with gmail's show-original option:

+=09cpufreq_device->dyn_power_table =3D power_table;
+=09cpufreq_device->dyn_power_table_entries =3D i;
+

I have seen this a lot, while I was in ARM. Had to adopt some work-arounds to
get over it. :)

On Sat, Dec 6, 2014 at 12:34 AM, Javi Merino <javi.merino@arm.com> wrote:

> diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c

> +static int build_dyn_power_table(struct cpufreq_cooling_device *cpufreq_device,
> +                               u32 capacitance)
> +{
> +       struct power_table *power_table;
> +       struct dev_pm_opp *opp;
> +       struct device *dev = NULL;
> +       int num_opps, cpu, i, ret = 0;

Why not initialize num_opps and i to 0 here?

> +       unsigned long freq;
> +
> +       num_opps = 0;
> +
> +       rcu_read_lock();
> +
> +       for_each_cpu(cpu, &cpufreq_device->allowed_cpus) {

All these CPUs must be sharing the OPPs as they must be supplied
from a single clock line. But probably you need to iterate over all
because you don't know which ones share OPP. Right ? Probably
the work I am doing around getting new OPP bindings might solve
this..

> +               dev = get_cpu_device(cpu);
> +               if (!dev)

Is this allowed? I understand you can continue, but this is not
possible. Right ? So, print a error here?

> +                       continue;
> +
> +               num_opps = dev_pm_opp_get_opp_count(dev);
> +               if (num_opps > 0) {
> +                       break;
> +               } else if (num_opps < 0) {
> +                       ret = num_opps;
> +                       goto unlock;
> +               }
> +       }
> +
> +       if (num_opps == 0) {
> +               ret = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       power_table = kcalloc(num_opps, sizeof(*power_table), GFP_KERNEL);
> +
> +       i = 0;

Either initialize i at the beginning or in the initialization part of
for loop below.

> +       for (freq = 0;
> +            opp = dev_pm_opp_find_freq_ceil(dev, &freq), !IS_ERR(opp);
> +            freq++) {
> +               u32 freq_mhz, voltage_mv;
> +               u64 power;
> +
> +               freq_mhz = freq / 1000000;
> +               voltage_mv = dev_pm_opp_get_voltage(opp) / 1000;
> +
> +               /*
> +                * Do the multiplication with MHz and millivolt so as
> +                * to not overflow.
> +                */
> +               power = (u64)capacitance * freq_mhz * voltage_mv * voltage_mv;
> +               do_div(power, 1000000000);
> +
> +               /* frequency is stored in power_table in KHz */
> +               power_table[i].frequency = freq / 1000;
> +               power_table[i].power = power;
> +
> +               i++;

Why here and not with freq++?

> +       }
> +
> +       if (i == 0) {
> +               ret = PTR_ERR(opp);
> +               goto unlock;
> +       }
> +
> +       cpufreq_device->dyn_power_table = power_table;
> +       cpufreq_device->dyn_power_table_entries = i;
> +
> +unlock:
> +       rcu_read_unlock();
> +       return ret;
> +}
> +
> +static u32 cpu_freq_to_power(struct cpufreq_cooling_device *cpufreq_device,
> +                       u32 freq)

Because the patch is screwed up a bit, I really can't see if the 'u'
or u32 is directly
below the 's' of struct cpufreq_cooling_device. Running checkpatch with --strict
will take care of that probably. Sorry if you have already taken care of that..

> +{
> +       int i;
> +       struct power_table *pt = cpufreq_device->dyn_power_table;
> +
> +       for (i = 1; i < cpufreq_device->dyn_power_table_entries; i++)
> +               if (freq < pt[i].frequency)
> +                       break;
> +
> +       return pt[i - 1].power;
> +}

> +static u32 get_static_power(struct cpufreq_cooling_device *cpufreq_device,
> +                       unsigned long freq)
> +{
> +       struct device *cpu_dev;
> +       struct dev_pm_opp *opp;
> +       unsigned long voltage;
> +       struct cpumask *cpumask = &cpufreq_device->allowed_cpus;
> +       unsigned long freq_hz = freq * 1000;
> +
> +       if (!cpufreq_device->plat_get_static_power)
> +               return 0;
> +
> +       cpu_dev = get_cpu_device(cpumask_any(cpumask));

Similar to the way you have used for-each-cpu earlier, the cpu
returned from above maynot have opps attached to it. Right ?

Probably you can keep a copy of the cpu_dev we have opps attached
with somewhere and reuse it.

> +
> +       rcu_read_lock();
> +
> +       opp = dev_pm_opp_find_freq_exact(cpu_dev, freq_hz, true);

So, this might fail if I am not wrong.

> +       voltage = dev_pm_opp_get_voltage(opp);
> +
> +       rcu_read_unlock();
> +
> +       if (voltage == 0) {
> +               dev_warn_ratelimited(cpu_dev,
> +                               "Failed to get voltage for frequency %lu: %ld\n",
> +                               freq_hz, IS_ERR(opp) ? PTR_ERR(opp) : 0);
> +               return 0;
> +       }
> +
> +       return cpufreq_device->plat_get_static_power(cpumask, voltage);
> +}
