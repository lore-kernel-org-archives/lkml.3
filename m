Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaC0FjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:39:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:36438 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaC0FjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:39:24 -0400
Date: Thu, 27 Mar 2014 06:39:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org
Subject: Re: [PATCH 1/2] hrtimer: don't add clock-base to active_bases if
 already present
In-Reply-To: <3c77c9453e42b7a914c15ef67a8ee142d3543a48.1395897612.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1403270637120.10699@ionos.tec.linutronix.de>
References: <cover.1395832156.git.viresh.kumar@linaro.org> <3c77c9453e42b7a914c15ef67a8ee142d3543a48.1395897612.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2014, Viresh Kumar wrote:

> If active_bases already has entry for a particular clock type, then we don't
> need to rewrite it while queuing a hrtimer.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Initially I thought of doing this but then thought better remove active_bases
> completely and so didn't sent this one. Now it might find some place for itself
> :).
> 
>  kernel/hrtimer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index da351ad..acfef5f 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -864,8 +864,9 @@ static int enqueue_hrtimer(struct hrtimer *timer,
>  {
>  	debug_activate(timer);
>  
> +	if (!timerqueue_getnext(&base->active))
> +		base->cpu_base->active_bases |= 1 << base->index;
>  	timerqueue_add(&base->active, &timer->node);
> -	base->cpu_base->active_bases |= 1 << base->index;

The conditional is more expensive than actually doing the OR operation
at least on x86 as it results in a branch.

Thanks,

	tglx
