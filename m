Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3FXLeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:34:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48958 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab3FXLeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:34:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com
Subject: Re: [PATCH 13/13] cpufreq: make sure frequency transitions are serialized
Date: Mon, 24 Jun 2013 13:43:48 +0200
Message-ID: <1894928.On8nI7rMdZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <0bebf56a27f799a282cc00d0c17c187f9941f122.1371630975.git.viresh.kumar@linaro.org>
References: <cover.1371630975.git.viresh.kumar@linaro.org> <0bebf56a27f799a282cc00d0c17c187f9941f122.1371630975.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 02:23:07 PM Viresh Kumar wrote:
> Whenever we are changing frequency of a cpu, we are calling PRECHANGE and
> POSTCHANGE notifiers. They must be serialized. i.e. PRECHANGE or POSTCHANGE
> shouldn't be called twice contiguously.
> 
> This can happen due to bugs in users of __cpufreq_driver_target() or actual
> cpufreq drivers who are sending these notifiers.
> 
> This patch adds some protection against this. Now, we keep track of the last
> transaction and see if something went wrong.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 2d53f47..92cb8b3 100644
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
> @@ -264,6 +267,8 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  	switch (state) {
>  
>  	case CPUFREQ_PRECHANGE:
> +		WARN_ON(transition_ongoing++);
> +
>  		/* detect if the driver reported a value as "old frequency"
>  		 * which is not equal to what the cpufreq core thinks is
>  		 * "old frequency".
> @@ -283,6 +288,8 @@ void __cpufreq_notify_transition(struct cpufreq_policy *policy,
>  		break;
>  
>  	case CPUFREQ_POSTCHANGE:
> +		WARN_ON(!transition_ongoing--);

Shouldn't we try to avoid going into the negative range here?

> +
>  		adjust_jiffies(CPUFREQ_POSTCHANGE, freqs);
>  		pr_debug("FREQ: %lu - CPU: %lu", (unsigned long)freqs->new,
>  			(unsigned long)freqs->cpu);
> @@ -1458,6 +1465,8 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>  
>  	if (cpufreq_disabled())
>  		return -ENODEV;
> +	if (transition_ongoing)
> +		return -EBUSY;
>  
>  	/* Make sure that target_freq is within supported range */
>  	if (target_freq > policy->max)
> 

Rafael

