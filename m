Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FXNNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:13:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49094 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3FXNNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:13:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
Date: Mon, 24 Jun 2013 15:23:08 +0200
Message-ID: <11846442.bozySFIXTh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohpo=8oZKiq1ghuipitbfMp-bPxpWPQbGx5SLj9+_nGegCfA@mail.gmail.com>
References: <cover.1371630975.git.viresh.kumar@linaro.org> <1894928.On8nI7rMdZ@vostro.rjw.lan> <CAKohpo=8oZKiq1ghuipitbfMp-bPxpWPQbGx5SLj9+_nGegCfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 06:38:17 PM Viresh Kumar wrote:
> On 24 June 2013 17:13, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Wednesday, June 19, 2013 02:23:07 PM Viresh Kumar wrote:
> >>       case CPUFREQ_POSTCHANGE:
> >> +             WARN_ON(!transition_ongoing--);
> >
> > Shouldn't we try to avoid going into the negative range here?
> 
> What about this patch? Find it attached to apply.
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2d53f47..6624694 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -107,6 +107,9 @@ static void handle_update(struct work_struct *work);
>  static BLOCKING_NOTIFIER_HEAD(cpufreq_policy_notifier_list);
>  static struct srcu_notifier_head cpufreq_transition_notifier_list;
> 
> +/* Tracks status of transition */
> +static int transition_ongoing;
> +
>  static bool init_cpufreq_transition_notifier_list_called;
>  static int __init init_cpufreq_transition_notifier_list(void)
>  {
> @@ -264,6 +267,13 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>         switch (state) {
> 
>         case CPUFREQ_PRECHANGE:
> +               if (transition_ongoing) {
> +                       WARN(1, "In middle of another frequency transition\n");
> +                       return;
> +               }

You can do

	if (WARN(transition_ongoing, "<text>"))
		return;

and below analogously.

> +
> +               transition_ongoing++;
> +
>                 /* detect if the driver reported a value as "old frequency"
>                  * which is not equal to what the cpufreq core thinks is
>                  * "old frequency".
> @@ -283,6 +293,13 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>                 break;
> 
>         case CPUFREQ_POSTCHANGE:
> +               if (!transition_ongoing) {
> +                       WARN(1, "No frequency transition in progress\n");
> +                       return;
> +               }
> +
> +               transition_ongoing--;
> +
>                 adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
>                 pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
>                         (unsigned long)freqs->cpu);
> @@ -1458,6 +1475,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
> 
>         if (cpufreq_disabled())
>                 return -ENODEV;
> +       if (transition_ongoing)
> +               return -EBUSY;
> 
>         /* Make sure that target_freq is within supported range */
>         if (target_freq > policy->max)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
