Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3A3HDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:03:46 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:59263 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3A3HDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:03:41 -0500
MIME-Version: 1.0
In-Reply-To: <1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
	<1356620142-8680-2-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 30 Jan 2013 12:33:40 +0530
X-Google-Sender-Auth: 9agPKA4d6by0xJAE8SiU5CDiAD4
Message-ID: <CAOh2x==SG32h-BbrnLN8gwiYNz7bS-REVcmXN67fdYPqFVmCiA@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: handle SW coordinated CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am starting to follow cpufreq patches religiously now and so have to come
back to this old thread due to some crash we got :)

Its still not pushed upstream, so better to get it resolved before 3.9.

On Thu, Dec 27, 2012 at 8:25 PM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c

>  static inline void dbs_timer_init(struct dbs_data *dbs_data,
> -               struct cpu_dbs_common_info *cdbs, unsigned int sampling_rate)
> +                                 struct cpu_dbs_common_info *cdbs,
> +                                 unsigned int sampling_rate,
> +                                 int cpu)
>  {
>         int delay = delay_for_sampling_rate(sampling_rate);
> +       struct cpu_dbs_common_info *cdbs_local = dbs_data->get_cpu_cdbs(cpu);

I couldn't understand the real need for this, as it should really give
back the same
pointer pointed out by: cdbs and hence no need of cpu in params too..

I may be wrong here :)

>
> -       INIT_DEFERRABLE_WORK(&cdbs->work, dbs_data->gov_dbs_timer);
> -       schedule_delayed_work_on(cdbs->cpu, &cdbs->work, delay);
> +       schedule_delayed_work_on(cpu, &cdbs_local->work, delay);
>  }
>
>  static inline void dbs_timer_exit(struct cpu_dbs_common_info *cdbs)
> @@ -217,6 +227,10 @@ int cpufreq_governor_dbs(struct dbs_data *dbs_data,
>                         if (ignore_nice)
>                                 j_cdbs->prev_cpu_nice =
>                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
> +
> +                       mutex_init(&j_cdbs->timer_mutex);
> +                       INIT_DEFERRABLE_WORK(&j_cdbs->work,
> +                                            dbs_data->gov_dbs_timer);
>                 }
>
>                 /*
> @@ -275,15 +289,33 @@ second_time:
>                 }
>                 mutex_unlock(&dbs_data->mutex);
>
> -               mutex_init(&cpu_cdbs->timer_mutex);
> -               dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate);
> +               if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
> +                       for_each_cpu(j, policy->cpus) {
> +                               struct cpu_dbs_common_info *j_cdbs;
> +
> +                               j_cdbs = dbs_data->get_cpu_cdbs(j);
> +                               dbs_timer_init(dbs_data, j_cdbs,
> +                                              *sampling_rate, j);
> +                       }
> +               } else {
> +                       dbs_timer_init(dbs_data, cpu_cdbs, *sampling_rate, cpu);
> +               }

do you really need this else part? In case of uniprocessor systems also, the if
block should be enough. Isn't it?

>                 break;
>
>         case CPUFREQ_GOV_STOP:
>                 if (dbs_data->governor == GOV_CONSERVATIVE)
>                         cs_dbs_info->enable = 0;
>
> -               dbs_timer_exit(cpu_cdbs);
> +               if (dbs_sw_coordinated_cpus(cpu_cdbs)) {
> +                       for_each_cpu(j, policy->cpus) {
> +                               struct cpu_dbs_common_info *j_cdbs;
> +
> +                               j_cdbs = dbs_data->get_cpu_cdbs(j);
> +                               dbs_timer_exit(j_cdbs);
> +                       }
> +               } else {
> +                       dbs_timer_exit(cpu_cdbs);
> +               }

ditto.

>                 mutex_lock(&dbs_data->mutex);
>                 mutex_destroy(&cpu_cdbs->timer_mutex);
> diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
> index f661654..5bf6fb8 100644
> --- a/drivers/cpufreq/cpufreq_governor.h
> +++ b/drivers/cpufreq/cpufreq_governor.h
> @@ -171,6 +171,7 @@ static inline int delay_for_sampling_rate(unsigned int sampling_rate)
>
>  u64 get_cpu_idle_time(unsigned int cpu, u64 *wall);
>  void dbs_check_cpu(struct dbs_data *dbs_data, int cpu);
> +bool dbs_sw_coordinated_cpus(struct cpu_dbs_common_info *cdbs);
>  int cpufreq_governor_dbs(struct dbs_data *dbs_data,
>                 struct cpufreq_policy *policy, unsigned int event);
>  #endif /* _CPUFREQ_GOVERNER_H */
> diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> index 7731f7c..93bb56d 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -243,7 +243,8 @@ static void od_dbs_timer(struct work_struct *work)
>                 }
>         }
>
> -       schedule_delayed_work_on(cpu, &dbs_info->cdbs.work, delay);
> +       schedule_delayed_work_on(smp_processor_id(), &dbs_info->cdbs.work,
> +                       delay);
>         mutex_unlock(&dbs_info->cdbs.timer_mutex);
>  }
>
> --
> 1.7.12.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
