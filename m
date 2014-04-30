Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbaD3Kfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:35:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:49407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223AbaD3Kfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:35:38 -0400
Date: Wed, 30 Apr 2014 12:35:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stuart Hayes <stuart.w.hayes@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hrtimer: invalid timeout set after hang_detected
In-Reply-To: <53602DC6.2060101@gmail.com>
Message-ID: <alpine.DEB.2.02.1404301207270.6261@ionos.tec.linutronix.de>
References: <53602DC6.2060101@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stuart,

On Tue, 29 Apr 2014, Stuart Hayes wrote:

> Make hrtimer_force_reprogram() not reprogram the clock event device if hang_detected has been set in hrtimer_interrupt().
> 

Please use proper line breaks for the changelog.

> This can occur, for instance, if a CPU goes idle and calls
> tick_nohz_stop_sched_tick() after hang_detected is set.  The
> function tick_nohz_stop_sched_tick() will call hrtimer_start() to
> reprogram the sched_timer to a longer timeout.  hrtimer_start() will
> call __hrtimer_start_range_ns(), which first calls remove_hrtimer()
> to remove sched_timer, then hrtimer_enqueue_reprogram() to add it
> with its new timeout.  The problem is that remove_hrtimer() calls
> __remove_hrtimer(), which calls hrtimer_force_reprogram(), and
> hrtimer_force_reprogram() ignores hang_detected and will reprogram
> the clock event device to the next soonest hrtimer expiry, which
> could be, say, 11 seconds away.  This overwrites the value that was
> programmed into the clock event device when hang_detected was set
> (which was no more than 100ms).  Then hrtimer_enqueue_reprogram()
> calls hrtimer_reprogram(), which observes hang_detected and does not
> reprogram the clock event device, so the device remains set to the
> val ue of, in this example, 11 seconds, during which time no clock
> event device interrupts occur and no timer expiration functions are
> run.

I took the liberty to rewrite the changelog. Please have a look and
judge yourself whats easier to grasp.

> 
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> ---
> 
> --- linux-3.15-rc3/kernel_orig/hrtimer.c	2014-04-29 13:10:58.087832963 -0400
> +++ linux-3.15-rc3/kernel/hrtimer.c	2014-04-29 15:42:49.581084736 -0400
> @@ -569,6 +569,15 @@ hrtimer_force_reprogram(struct hrtimer_c
>  
>  	cpu_base->expires_next.tv64 = expires_next.tv64;
>  
> +	/*
> +	 * If a hang was detected in the last timer interrupt then we
> +	 * do not schedule a timer which is earlier than the expiry
> +	 * which we enforced in the hang detection. We want the system
> +	 * to make progress.

So you just blindly copied the comment from hrtimer_reprogram(). But
this is not only about scheduling an timer which is earlier.

Fixed it up, but please be more careful when you submit patches next
time.

Thanks,

	tglx

