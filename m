Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946586Ab3BHPTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:19:37 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:40729 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946062Ab3BHPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:19:34 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAOh2x=nB1LpoiUjg2zDT6TvL6vM9q0D4kDG1cFZPtEnSvZc07w@mail.gmail.com>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
	<CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
	<CA+icZUUaFb8zvdkY2JLz5h_7CBgaTzyyTphGid+GkigV+NfVKA@mail.gmail.com>
	<2612804.Hcyse1lRVO@vostro.rjw.lan>
	<CA+icZUWQNU-z4VnVDneFmfAT=nyFB-r+9_vm2Ett1i-Rg5FMqA@mail.gmail.com>
	<CAOh2x=nB1LpoiUjg2zDT6TvL6vM9q0D4kDG1cFZPtEnSvZc07w@mail.gmail.com>
Date: Fri, 8 Feb 2013 16:19:33 +0100
Message-ID: <CA+icZUW+iPmoz9iFzg+LEdK9UTfgkySEE79Gdc64RSo_RWmsog@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 8 [ smp|cpufreq: WARNING: at
 kernel/smp.c:245 smp_call_function_single ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Hillf Danton <dhillf@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 3:50 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On Fri, Feb 8, 2013 at 7:45 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> "...some...changes..." is not very concrete :-).
>> Which commit(s) caused this trouble?
>>
>> Is current (meanwhile updated?) linux-pm.git#linux-next good (didn't
>> check last commit-ids of your tree from Next/ dir)?
>
> Attached patch would fix it for you and it looks like and is going to be
> pulled in by Rafael:
>
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Fri, 8 Feb 2013 10:35:31 +0530
> Subject: [PATCH] cpufreq: Remove unnecessary locking
>
> I have placed some locks intentionally around calls to driver->ops (init/exit),
> which look to be wrong as these calls can call routines that potentially sleep.
>
> Lets remove these locks.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

( 0001-cpufreq-Remove-unnecessary-locking.patch fixes the issue here! )

- Sedat -

> ---
>  drivers/cpufreq/cpufreq.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 5d8a422..04aab05 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -795,10 +795,8 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
>
>         if (ret) {
>                 pr_debug("setting policy failed\n");
> -               spin_lock_irqsave(&cpufreq_driver_lock, flags);
>                 if (driver->exit)
>                         driver->exit(policy);
> -               spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>         }
>         return ret;
>
> @@ -920,17 +918,14 @@ static int cpufreq_add_dev(struct device *dev,
> struct subsys_interface *sif)
>         init_completion(&policy->kobj_unregister);
>         INIT_WORK(&policy->update, handle_update);
>
> -       spin_lock_irqsave(&cpufreq_driver_lock, flags);
>         /* call driver. From then on the cpufreq must be able
>          * to accept all calls to ->verify and ->setpolicy for this CPU
>          */
>         ret = driver->init(policy);
>         if (ret) {
>                 pr_debug("initialization failed\n");
> -               spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>                 goto err_set_policy_cpu;
>         }
> -       spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
>         /* related cpus should atleast have policy->cpus */
>         cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
> @@ -1100,10 +1095,8 @@ static int __cpufreq_remove_dev(struct device
> *dev, struct subsys_interface *sif
>                 wait_for_completion(cmp);
>                 pr_debug("wait complete\n");
>
> -               spin_lock_irqsave(&cpufreq_driver_lock, flags);
>                 if (driver->exit)
>                         driver->exit(data);
> -               spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
>
>                 free_cpumask_var(data->related_cpus);
>                 free_cpumask_var(data->cpus);
