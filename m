Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaB1Kwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:52:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:35456 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaB1Kwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:52:41 -0500
Date: Fri, 28 Feb 2014 11:52:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tj@kernel.org, peterz@infradead.org,
        mingo@kernel.org
Subject: Re: [PATCH 2/2] timer: Make sure TIMER_FLAG_MASK bits are free in
 allocated base
In-Reply-To: <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1402281151180.18573@ionos.tec.linutronix.de>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org> <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Viresh Kumar wrote:

> Currently we are using two lowest bit of base for internal purpose and so they
> both should be zero in the allocated address. The code was doing the right thing
> before this patch came in:
> 
> commit c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3
> Author: Tejun Heo <tj@kernel.org>
> Date:   Wed Aug 8 11:10:28 2012 -0700
> 
>     timer: Implement TIMER_IRQSAFE
> 
> Tejun probably forgot to update this piece of code which checks if the lowest
> 'n' bits are zero or not and so wasn't updated according to the new flag. Lets
> use TIMER_FLAG_MASK in the calculations here, so that this code wouldn't require
> a change later on with another flag in.

Are you planning to introduce more flag horror? Don't go there. The
timer_list code is about to be rewritten completely and I'm not going
to add new features to the existing code base.

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/timer.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index e8e7839..d52a8ff 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1548,9 +1548,8 @@ static int init_timers_cpu(int cpu)
>  			if (!base)
>  				return -ENOMEM;
>  
> -			/* Make sure that tvec_base is 2 byte aligned */
> -			if (tbase_get_deferrable(base)) {
> -				WARN_ON(1);
> +			/* Make sure tvec_base has TIMER_FLAG_MASK bits free */
> +			if (WARN_ON(base != tbase_get_base(base))) {
>  				kfree(base);
>  				return -ENOMEM;
>  			}
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> 
