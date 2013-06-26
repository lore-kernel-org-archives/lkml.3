Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab3FZVsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:48:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52465 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab3FZVsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:48:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
Date: Wed, 26 Jun 2013 23:57:51 +0200
Message-ID: <2081161.dnl1xTqcUT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponyMG-uA93ZpH-KD+EOQPmk5tT_QoaQ7+NCEf48vYj5-w@mail.gmail.com>
References: <cover.1371630975.git.viresh.kumar@linaro.org> <2165396.dF1lQyPRVT@vostro.rjw.lan> <CAKohponyMG-uA93ZpH-KD+EOQPmk5tT_QoaQ7+NCEf48vYj5-w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 07:01:59 PM Viresh Kumar wrote:
> On 24 June 2013 19:03, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Looks OK, but since transition_ongoing is either 0 or 1 now, as far as I can
> > say, it would be better to make it a bool and use = true/false instead of
> > ++/-- I suppose.
> 
> Another fixup:
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 6ca7eac..49d942a 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -108,7 +108,7 @@ static BLOCKING_NOTIFIER_HEAD(cpufreq_policy_notifier_list);
>  static struct srcu_notifier_head cpufreq_transition_notifier_list;
> 
>  /* Tracks status of transition */
> -static int transition_ongoing;
> +static bool transition_ongoing;
> 
>  static bool init_cpufreq_transition_notifier_list_called;
>  static int __init init_cpufreq_transition_notifier_list(void)
> @@ -271,7 +271,7 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>                                 "In middle of another frequency transition\n"))
>                         return;
> 
> -               transition_ongoing++;
> +               transition_ongoing = true;
> 
>                 /* detect if the driver reported a value as "old frequency"
>                  * which is not equal to what the cpufreq core thinks is
> @@ -296,7 +296,7 @@ void __cpufreq_notify_transition(struct
> cpufreq_policy *policy,
>                                 "No frequency transition in progress\n"))
>                         return;
> 
> -               transition_ongoing--;
> +               transition_ongoing = false;
> 
>                 adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
>                 pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,

Well, now, seeing that the locking around this seems to be kind of haphazard,
I'm wondering what prevents two different threads from doing CPUFREQ_PRECHANGE
concurrently in such a way that thread A will check transition_ongoing
and thread B will check transition_ongoing and then both will set it if it
was 'false' before.  And then one of them will trigger the WARN() in
CPUFREQ_POSTCHANGE.

Is there any protection in place and if so then how does it work?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
