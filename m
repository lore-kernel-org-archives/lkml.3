Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbaGIWVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 18:21:44 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:42077 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352AbaGIWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 18:21:41 -0400
Date: Thu, 10 Jul 2014 00:21:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: tglx@linutronix.de, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        preeti@linux.vnet.ibm.com, khilman@linaro.org
Subject: Re: [RFC 1/7] hrtimer: Warn if hrtimer_start*() failed to enqueue
 hrtimer
Message-ID: <20140709222131.GD23881@localhost.localdomain>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
 <bc8cabd00810c2f91cb45a64514f5c4ca12d584c.1404888801.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc8cabd00810c2f91cb45a64514f5c4ca12d584c.1404888801.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:25:33PM +0530, Viresh Kumar wrote:
> hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
> only special case is when the hrtimer was in past. If it is getting enqueued to
> local CPUs's clock-base, we raise a softirq and exit, else we handle that on
> next interrupt on remote CPU.
> 
> At several places in kernel we check if hrtimer is enqueued properly with
> hrtimer_active(). This isn't required and can be dropped.
> 
> Before fixing that, lets make sure hrtimer is always enqueued properly by adding
> 
> 	WARN_ON_ONCE(!hrtimer_active(timer));
> 
> towards the end of __hrtimer_start_range_ns().
> 
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/hrtimer.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 3ab2899..cf40209 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1037,6 +1037,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
>  
>  	unlock_hrtimer_base(timer, &flags);
>  
> +	/* Make sure timer is enqueued */
> +	WARN_ON_ONCE(!hrtimer_active(timer));

Hmm, after reading Thomas reply, I think it's possible that the hrtimer expires
right after we unlock it and, if we are unlucky enough, before the hrtimer_active()
check.

In this case we might hit a false positive.

>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
> -- 
> 2.0.0.rc2
> 
