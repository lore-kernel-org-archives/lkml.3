Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210Ab3DISac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:30:32 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:46416 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934557Ab3DISa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:30:28 -0400
Date: Tue, 9 Apr 2013 11:30:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
Message-ID: <20130409183020.GD6186@mtj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
 <91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
 <20130331181931.GA7533@htj.dyndns.org>
 <CAKohpomGSkz6_YqDzaTYEsJfVmcg2=TvdgquWqTvd-nmtOmoaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomGSkz6_YqDzaTYEsJfVmcg2=TvdgquWqTvd-nmtOmoaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo!

On Tue, Apr 09, 2013 at 01:00:59PM +0530, Viresh Kumar wrote:
> +	workqueue.power_efficient
> +			Workqueues can be performance or power oriented. For
> +			performance we may want to keep them running on a single
> +			cpu, so that it remains cache hot. For power we can give
> +			scheduler the liberty to choose target cpu for running
> +			work handler.
> +
> +			Later one (Power oriented WQ) can be achieved if the
> +			workqueue is allocated with WQ_UNBOUND flag. Enabling
> +			power_efficient boot param will convert
> +			WQ_POWER_EFFICIENT flag to WQ_UNBOUND on wq allocation.
> +			This requires CONFIG_WQ_POWER_EFFICIENT to be enabled.
> +			WQ_POWER_EFFICIENT is unused if power_efficient is not
> +			set in boot params.

Looks mostly good to me but I think it'd be better if the parameter
name is a bit more specific.

> @@ -299,6 +299,9 @@ enum {
>  	WQ_HIGHPRI		= 1 << 4, /* high priority */
>  	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
>  	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
> +	WQ_POWER_EFFICIENT	= 1 << 7, /* WQ_UNBOUND, for power
> +					   * saving, if wq_power_efficient is
> +					   * enabled. Unused otherwise. */

Ditto for the flag name.  It's not a requirement tho.  If you can
think of something which is a bit more specific to what it does while
not being unreasonably long, great.  If not, we'll live.

> @@ -271,6 +271,11 @@ static cpumask_var_t *wq_numa_possible_cpumask;
>  static bool wq_disable_numa;
>  module_param_named(disable_numa, wq_disable_numa, bool, 0444);
> 
> +#ifdef CONFIG_WQ_POWER_EFFICIENT
> +static bool wq_power_efficient = 0;
> +module_param_named(power_efficient, wq_power_efficient, bool, 0444);
> +#endif

I don't think we need to make the whole thing configurable.  Turning
it off isn't gonna save much - my gut tells me it's gonna be four
instructions. :)

What I meant was that the default value for the parameter would
probably be need to be configurable so that mobile people don't have
to include the kernel param all the time or patch the kernel
themselves.

> +	if (flags & WQ_POWER_EFFICIENT) {
> +		flags &= ~WQ_POWER_EFFICIENT;

No need to clear the flag.

> +#ifdef CONFIG_WQ_POWER_EFFICIENT
> +		if (wq_power_efficient)
> +			flags |= WQ_UNBOUND;
> +#endif

Thanks!

-- 
tejun
