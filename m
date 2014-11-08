Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaKHBiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:38:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58545 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752822AbaKHBiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:38:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, robert.schoene@tu-dresden.de,
        sboyd@codeaurora.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 4/5] cpufreq, policy->initialized count must be atomic
Date: Sat, 08 Nov 2014 02:59:11 +0100
Message-ID: <1546924.3iEqBWAUvW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415199239-19019-5-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com> <1415199239-19019-5-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 09:53:58 AM Prarit Bhargava wrote:
> The policy->initialized value can be modified from several cpus concurrently if
> !CPUFREQ_HAVE_GOVERNOR_PER_POLICY.  This leads to a situation where a
> governor maybe switched out even though the governor->initialized is greater
> than one.  It must be switched to atomic_t and protected with a mutex to
> make sure that future read/writes obtain the correct data.

Same comments as for [3/5].  If you add a new mutex, you can avoid using
atomic_t.

> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> ---
>  drivers/cpufreq/cpufreq.c          |   12 +++++++++---
>  drivers/cpufreq/cpufreq_governor.c |    4 ++--
>  include/linux/cpufreq.h            |    3 ++-
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index e33cb15..cf11de6 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -2059,10 +2059,12 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
>  	ret = policy->governor->governor(policy, event);
>  
>  	if (!ret) {
> +		mutex_lock(&policy->governor->initialized_mutex);
>  		if (event == CPUFREQ_GOV_POLICY_INIT)
> -			policy->governor->initialized++;
> +			atomic_inc(&policy->governor->initialized);
>  		else if (event == CPUFREQ_GOV_POLICY_EXIT)
> -			policy->governor->initialized--;
> +			atomic_dec(&policy->governor->initialized);
> +		mutex_unlock(&policy->governor->initialized_mutex);
>  	} else {
>  		/* Restore original values */
>  		mutex_lock(&cpufreq_governor_lock);
> @@ -2092,7 +2094,11 @@ int cpufreq_register_governor(struct cpufreq_governor *governor)
>  
>  	mutex_lock(&cpufreq_governor_mutex);
>  
> -	governor->initialized = 0;
> +	mutex_init(&governor->initialized_mutex);
> +	mutex_lock(&governor->initialized_mutex);
> +	atomic_set(&governor->initialized, 0);
> +	mutex_unlock(&governor->initialized_mutex);
> +
>  	err = -EBUSY;
>  	if (__find_governor(governor->name) == NULL) {
>  		err = 0;
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 32ad9db..b1ee597 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -315,7 +315,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  					latency * LATENCY_MULTIPLIER));
>  
>  		if ((cdata->governor == GOV_CONSERVATIVE) &&
> -				(!policy->governor->initialized)) {
> +		    (!atomic_read(&policy->governor->initialized))) {
>  			struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
>  
>  			cpufreq_register_notifier(cs_ops->notifier_block,
> @@ -336,7 +336,7 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>  				cpufreq_put_global_kobject();
>  
>  			if ((dbs_data->cdata->governor == GOV_CONSERVATIVE) &&
> -				(policy->governor->initialized == 1)) {
> +			    atomic_read(&policy->governor->initialized) == 1) {
>  				struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
>  
>  				cpufreq_unregister_notifier(cs_ops->notifier_block,
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index 43909ad..73cec45 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -431,7 +431,8 @@ static inline unsigned long cpufreq_scale(unsigned long old, u_int div,
>  
>  struct cpufreq_governor {
>  	char	name[CPUFREQ_NAME_LEN];
> -	int	initialized;
> +	struct mutex initialized_mutex;
> +	atomic_t initialized;
>  	int	(*governor)	(struct cpufreq_policy *policy,
>  				 unsigned int event);
>  	ssize_t	(*show_setspeed)	(struct cpufreq_policy *policy,
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
