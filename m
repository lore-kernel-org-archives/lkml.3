Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaF3QKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:10:51 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:30617 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755511AbaF3QKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:10:49 -0400
Date: Mon, 30 Jun 2014 12:10:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, stable-rt@vger.kernel.org
Subject: Re: [PATCH rt] Fix latency histogram after "hrtimer: Set expiry
 time before switch_hrtimer_base()"
Message-ID: <20140630121038.61392ab8@gandalf.local.home>
In-Reply-To: <1403994888.23472.116.camel@deadeye.wl.decadent.org.uk>
References: <1403994888.23472.116.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 23:34:48 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

> In an rt-kernel with CONFIG_MISSED_TIMER_OFFSETS_HIST enabled,
> __hrtimer_start_range_ns() now crashes, as new_base is not assigned
> before it is used.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Tested-by: Carsten Emde <C.Emde@osadl.org>
> Cc: stable-rt@vger.kernel.org

Thanks, I'm applying it now. Will need to go through the various tests
before I push it out.

-- Steve

> ---
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1106,6 +1106,11 @@ int __hrtimer_start_range_ns(struct hrti
>  #endif
>  	}
>  
> +	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
> +
> +	/* Switch the timer base, if necessary: */
> +	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
> +
>  #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
>  	{
>  		ktime_t now = new_base->get_time();
> @@ -1117,11 +1122,6 @@ int __hrtimer_start_range_ns(struct hrti
>  	}
>  #endif
>  
> -	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
> -
> -	/* Switch the timer base, if necessary: */
> -	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
> -
>  	timer_stats_hrtimer_set_start_info(timer);
>  
>  	leftmost = enqueue_hrtimer(timer, new_base);
> 

