Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3ETNnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:43:11 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:53957 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3ETNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130520132355.GF12690@pd.tnic>
References: <20130520045023.GA12690@pd.tnic>
	<5199C169.7060504@linux.vnet.ibm.com>
	<20130520064727.GD12690@pd.tnic>
	<5199C990.3020602@linux.vnet.ibm.com>
	<5199CB59.1020309@linux.vnet.ibm.com>
	<CAKohponk-FQpHOx407FL63ZCYVgz2C-ScvZQBQFVxddbL+fS=A@mail.gmail.com>
	<5199CFD0.9030101@linux.vnet.ibm.com>
	<5199E54D.7030407@linux.vnet.ibm.com>
	<CAKohponS+tCkZyVpDO9fEMQCfsn5h=N235sj5sBGUkD2qKY=cQ@mail.gmail.com>
	<5199EBB5.7060209@linux.vnet.ibm.com>
	<20130520132355.GF12690@pd.tnic>
Date: Mon, 20 May 2013 19:13:08 +0530
Message-ID: <CAKohpokEdnmR4wsAqZgxnLOd5MAn6RNEFYwJQ8Xv1EdRbX1tkQ@mail.gmail.com>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 May 2013 18:53, Borislav Petkov <bp@alien8.de> wrote:
> I just confirmed that policy->cpus contains offlined cores with this:
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 5af40ad82d23..e8c25f71e9b6 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -169,6 +169,9 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
>  {
>         struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>
> +       if (WARN_ON(!cpu_online(cpu)))
> +               return;
> +
>         mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
>  }

Hmm, so for sure there is some locking issue there.
Have you tried my patch? I am not sure if it will fix everything but may
fix it.

> see splats collection below.
>
> And I don't think your fix above addresses the issue for the simple
> reason that if cpus go offline *before* you do get_online_cpus(), then
> policy->cpus will already contain offlined cpus.
>
> Rather, a better fix would be, IMHO, to do this (it works here, of course):
>
> ---
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 5af40ad82d23..58541b164494 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -17,6 +17,7 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>  #include <asm/cputime.h>
> +#include <linux/cpu.h>
>  #include <linux/cpufreq.h>
>  #include <linux/cpumask.h>
>  #include <linux/export.h>
> @@ -169,7 +170,15 @@ static inline void __gov_queue_work(int cpu, struct dbs_data *dbs_data,
>  {
>         struct cpu_dbs_common_info *cdbs = dbs_data->cdata->get_cpu_cdbs(cpu);
>
> +       get_online_cpus();
> +
> +       if (!cpu_online(cpu))
> +               goto out;
> +
>         mod_delayed_work_on(cpu, system_wq, &cdbs->work, delay);
> +
> + out:
> +       put_online_cpus();
>  }
>
>  void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,

This looks fine, but I want to fix the locking rather than just
hiding the issue. :)
