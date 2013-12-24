Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab3LXAV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:21:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55513 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757569Ab3LXAVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:21:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed to come back after resume
Date: Tue, 24 Dec 2013 01:35:20 +0100
Message-ID: <1614824.4yERnS53EQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52B85AA4.6070609@linaro.org>
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org> <87pponx07s.fsf@nemi.mork.no> <52B85AA4.6070609@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 23, 2013 09:15:40 PM viresh kumar wrote:
> On Monday 23 December 2013 05:12 PM, Bjørn Mork wrote:
> > That would be great.  This could be just me.  I am quite good at
> > breaking stuff.
> 
> No its not you. While we tried to make sure everything is preserved,
> few special things still stayed out :)
> 
> And they are solved with this patch, log should be good enough to give
> proper reasoning:
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Mon, 23 Dec 2013 20:51:54 +0530
> Subject: [PATCH] cpufreq: preserve user_policy across suspend/resume
> 
> In __cpufreq_add_dev() we are reinitializing user_policy with default values and
> hence would loose values of user_policy.{min|max|policy|governor} fields.
> 
> Preserve them by not overriding these for suspend/resume.

OK

Can you please combine this with the patch you sent previously (if that one
is still necessary) and resubmit with a new subject?

Rafael


> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 16d7b4a..c5c3dac 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -839,9 +839,6 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
> 
>  	/* set default policy */
>  	ret = cpufreq_set_policy(policy, &new_policy);
> -	policy->user_policy.policy = policy->policy;
> -	policy->user_policy.governor = policy->governor;
> -
>  	if (ret) {
>  		pr_debug("setting policy failed\n");
>  		if (cpufreq_driver->exit)
> @@ -1069,8 +1066,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>  	 */
>  	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
> 
> -	policy->user_policy.min = policy->min;
> -	policy->user_policy.max = policy->max;
> +	if (!frozen) {
> +		policy->user_policy.min = policy->min;
> +		policy->user_policy.max = policy->max;
> +	}
> 
>  	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
>  				     CPUFREQ_START, policy);
> @@ -1101,6 +1100,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
> 
>  	cpufreq_init_policy(policy);
> 
> +	if (!frozen) {
> +		policy->user_policy.policy = policy->policy;
> +		policy->user_policy.governor = policy->governor;
> +	}
> +
>  	kobject_uevent(&policy->kobj, KOBJ_ADD);
>  	up_read(&cpufreq_rwsem);
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
