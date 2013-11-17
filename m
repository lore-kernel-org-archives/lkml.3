Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3KQObx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 09:31:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62990 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752639Ab3KQObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 09:31:49 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] Cpufreq: Make governor data on nonboot cpus across system suspend/resume
Date: Sun, 17 Nov 2013 15:44:24 +0100
Message-ID: <3555392.CLJaBWE9DL@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5288425A.6000501@linaro.org>
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan> <1384616184-6197-1-git-send-email-tianyu.lan@intel.com> <5288425A.6000501@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 17, 2013 09:43:14 AM viresh kumar wrote:
> On 16 November 2013 21:06, Lan Tianyu <tianyu.lan@intel.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > @@ -1818,9 +1818,13 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> >                 mutex_unlock(&cpufreq_governor_lock);
> >         }
> >
> > -       if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
> > -                       ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> > +       if ((event == CPUFREQ_GOV_POLICY_INIT) && ret) {
> > +               module_put(policy->governor->owner);
> > +               if (ret == -EALREADY)
> > +                       return 0;
> > +       } else if ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret) {
> >                 module_put(policy->governor->owner);
> > +       }
> 
> This can still be written more efficiently I believe:
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 138ebe9..54e28e1 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1866,10 +1866,12 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>         ret = policy->governor->governor(policy, event);
> 
>         if (!ret) {
> -               if (event == CPUFREQ_GOV_POLICY_INIT)
> +               if (event == CPUFREQ_GOV_POLICY_INIT) {
>                         policy->governor->initialized++;
> -               else if (event == CPUFREQ_GOV_POLICY_EXIT)
> +               } else if (event == CPUFREQ_GOV_POLICY_EXIT) {
>                         policy->governor->initialized--;
> +                       module_put(policy->governor->owner);
> +               }
>         } else {
>                 /* Restore original values */
>                 mutex_lock(&cpufreq_governor_lock);
> @@ -1877,13 +1879,14 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>                         policy->governor_enabled = true;
>                 else if (event == CPUFREQ_GOV_START)
>                         policy->governor_enabled = false;
> +               else if (event == CPUFREQ_GOV_POLICY_INIT)
> +                       if (ret == -EALREADY) {

You can write this as

               else if (event == CPUFREQ_GOV_POLICY_INIT && ret == -EALREADY) {

> +                               module_put(policy->governor->owner);
> +                               ret = 0;
> +                       }
>                 mutex_unlock(&cpufreq_governor_lock);
>         }
> 
> -       if (((event == CPUFREQ_GOV_POLICY_INIT) && ret) ||
> -                       ((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> -               module_put(policy->governor->owner);
> -
>         return ret;

Apart from the above I agree.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
