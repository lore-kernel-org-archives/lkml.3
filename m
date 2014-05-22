Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaEVQpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:45:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53001 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaEVQpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:45:18 -0400
Message-ID: <537E27DA.9040709@wwwdotorg.org>
Date: Thu, 22 May 2014 10:37:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org, linux@arm.linux.org.uk,
        nicolas.pitre@linaro.org, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH V4 2/3] cpufreq: add support for intermediate (stable)
 frequencies
References: <cover.1400662383.git.viresh.kumar@linaro.org> <59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
In-Reply-To: <59e1185a31e61c428aca9f4b8f0a69f182ee458e.1400662383.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 02:59 AM, Viresh Kumar wrote:
> Douglas Anderson, recently pointed out an interesting problem due to which
> udelay() was expiring earlier than it should.
> 
> While transitioning between frequencies few platforms may temporarily switch to
> a stable frequency, waiting for the main PLL to stabilize.
> 
> For example: When we transition between very low frequencies on exynos, like
> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
> No CPUFREQ notification is sent for that. That means there's a period of time
> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
> and 300MHz. And so udelay behaves badly.
> 
> To get this fixed in a generic way, lets introduce another set of callbacks
> get_intermediate() and target_intermediate(), only for drivers with
> target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.
> 
> get_intermediate() should return a stable intermediate frequency platform wants
> to switch to, and target_intermediate() should set CPU to to that frequency,
> before jumping to the frequency corresponding to 'index'. Core will take care of
> sending notifications and driver doesn't have to handle them in
> target_intermediate() or target_index().
> 
> NOTE: ->target_index() should restore to policy->restore_freq in case of
> failures as core would send notifications for that.

> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c

> +/* Must set freqs->new to intermediate frequency */
> +static int __target_intermediate(struct cpufreq_policy *policy,
> +				 struct cpufreq_freqs *freqs, int index)
> +{
> +	int ret;
> +
> +	freqs->new = cpufreq_driver->get_intermediate(policy, index);
> +
> +	/* We don't need to switch to intermediate freq */
> +	if (!freqs->new)
> +		return 0;
> +
> +	pr_debug("%s: cpu: %d, switching to intermediate freq: oldfreq: %u, intermediate freq: %u\n",
> +		 __func__, policy->cpu, freqs->old, freqs->new);
> +
> +	cpufreq_freq_transition_begin(policy, freqs);
> +	ret = cpufreq_driver->target_intermediate(policy, index);
> +	cpufreq_freq_transition_end(policy, freqs, ret);
> +
> +	if (ret)
> +		pr_err("%s: Failed to change to intermediate frequency: %d\n",
> +		       __func__, ret);
> +	else
> +		/* Set old freq to intermediate */
> +		freqs->old = freqs->new;
> +
> +	return ret;
> +}

It seems rather odd to set both freqs->old and freqs->new to the
intermediate frequency upon success. It feels like it would make more
sense to remove that final else clause above, and do the following where
this function is called:

	intermediate_freq = freqs.new;
	if (intermediate_freq)
		freqs.old = intermediate_freq
	freqs.new = freq_table[index].frequency

(or even return the intermediate frequency from the function)

?

But I suppose isolating all the inside __target_intermediate() isn't so bad.

>  static int __target_index(struct cpufreq_policy *policy,
>  			  struct cpufreq_frequency_table *freq_table, int index)
>  {
> -	struct cpufreq_freqs freqs;
> +	struct cpufreq_freqs freqs = {.old = policy->cur, .flags = 0};
> +	unsigned int intermediate_freq = 0;
>  	int retval = -EINVAL;
>  	bool notify;
>  
>  	notify = !(cpufreq_driver->flags & CPUFREQ_ASYNC_NOTIFICATION);
> -
>  	if (notify) {
> -		freqs.old = policy->cur;
> -		freqs.new = freq_table[index].frequency;
> -		freqs.flags = 0;
> +		/* Handle switching to intermediate frequency */
> +		if (cpufreq_driver->get_intermediate) {
> +			retval = __target_intermediate(policy, &freqs, index);
> +			if (retval)
> +				return retval;

Shouldn't this all be outside the if (notify) block, so that
__target_intermediate is always called, and it's just the notify
callbacks that gets skipped if (!notify)?

