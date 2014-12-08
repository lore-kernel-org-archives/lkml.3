Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaLHKsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:48:39 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38121 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbaLHKsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:48:38 -0500
Date: Mon, 8 Dec 2014 10:48:29 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "jingchang.lu@freescale.com" <jingchang.lu@freescale.com>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2] tick-broadcast: Register for hrtimer based broadcast
 as the fallback broadcast mode
Message-ID: <20141208104828.GA21680@leverpostej>
References: <20141208065513.3075.48721.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208065513.3075.48721.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On Mon, Dec 08, 2014 at 06:55:43AM +0000, Preeti U Murthy wrote:
> Commit 5d1638acb9f6 ('tick: Introduce hrtimer based broadcast') added a
> hrtimer based broadcast mode for those platforms in which local timers stop
> when CPUs enter deep idle states. The commit expected the platforms to
> register for this mode explicitly when they lacked a better external device
> to wake up CPUs in deep idle. Given that more platforms are beginning to use
> this mode, we can avoid the call to set it up on every platform that requires
> it, by registering for the hrtimer based broadcast mode in the core code if
> no better broadcast device is available.
> 
> This commit also helps detect cases where the platform fails to register for
> a broadcast device but invokes the help of one when entering deep idle states.
> Currently we do not handle this situation at all and call the broadcast clock
> device without checking for its existence. This patch will handle such buggy
> cases properly.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

I've just given this a go on an arm64 platform (Juno) without any
system-wide clock_event_devices registered, and everything works well
with CPUs entering and exiting idle states where the cpu-local timers
lose state. So:

Tested-by: Mark Rutland <mark.rutland@arm.com>

One minor thing I noticed when testing was that
/sys/devices/system/clockevents/broadcast/name contained "(null)",
because we never set the name field on the clock_event_device. It's
always been that way, but now might be a good time to change that to
something like "broadcast_hrtimer".

[...]

> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 2e4cb67..91754b0 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -187,11 +187,11 @@ extern int tick_receive_broadcast(void);
>  #endif
>  
>  #if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
> -extern void tick_setup_hrtimer_broadcast(void);
> +extern int __init tick_setup_hrtimer_broadcast(void);
>  extern int tick_check_broadcast_expired(void);
>  #else
>  static inline int tick_check_broadcast_expired(void) { return 0; }
> -static inline void tick_setup_hrtimer_broadcast(void) {};
> +static inline int __init tick_setup_hrtimer_broadcast(void) { return 0; }
>  #endif
>  
>  #ifdef CONFIG_GENERIC_CLOCKEVENTS
> @@ -207,7 +207,7 @@ static inline void clockevents_resume(void) {}
>  
>  static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
>  static inline int tick_check_broadcast_expired(void) { return 0; }
> -static inline void tick_setup_hrtimer_broadcast(void) {};
> +static inline int __init tick_setup_hrtimer_broadcast(void) { return 0; }

With the initcall moved to the driver we have no external users of
tick_setup_hrtimer_broadcast, so I think we can remove the prototype
entirely from clockchips.h...

>  #endif
>  
> diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
> index eb682d5..5c35995 100644
> --- a/kernel/time/tick-broadcast-hrtimer.c
> +++ b/kernel/time/tick-broadcast-hrtimer.c
> @@ -98,9 +98,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
>  	return HRTIMER_RESTART;
>  }
>  
> -void tick_setup_hrtimer_broadcast(void)
> +int __init tick_setup_hrtimer_broadcast(void)

...and make it static here.

>  {
>  	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>  	bctimer.function = bc_handler;
>  	clockevents_register_device(&ce_broadcast_hrtimer);
> +	return 0;
>  }
> +early_initcall(tick_setup_hrtimer_broadcast);

Otherwise this looks good to me, thanks for putting this together!

Mark.
