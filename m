Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaBIHbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 02:31:09 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37798 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBIHbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 02:31:07 -0500
Date: Sat, 8 Feb 2014 23:31:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: tglx@linutronix.de, fengguang.wu@intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time/cpuidle:Fixup fallout from hrtimer broadcast mode
 inclusion
In-Reply-To: <20140207172924.8248.55002.stgit@preeti>
Message-ID: <alpine.DEB.2.02.1402082329410.8686@chino.kir.corp.google.com>
References: <20140207172924.8248.55002.stgit@preeti>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1904609958-1391931065=:8686"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1904609958-1391931065=:8686
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 7 Feb 2014, Preeti U Murthy wrote:

> The broadcast timer registration has to be done only when
> GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options are enabled.
> Also fix max_delta_ticks value for the pseudo clock device.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
> 
>  kernel/time/tick-broadcast-hrtimer.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
> index 5591aaa..bc383ac 100644
> --- a/kernel/time/tick-broadcast-hrtimer.c
> +++ b/kernel/time/tick-broadcast-hrtimer.c
> @@ -81,7 +81,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
>  	.min_delta_ns		= 1,
>  	.max_delta_ns		= KTIME_MAX,
>  	.min_delta_ticks	= 1,
> -	.max_delta_ticks	= KTIME_MAX,
> +	.max_delta_ticks	= ULONG_MAX,
>  	.mult			= 1,
>  	.shift			= 0,
>  	.cpumask		= cpu_all_mask,
> @@ -102,9 +102,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
>  	return HRTIMER_RESTART;
>  }
>  
> +#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
>  void tick_setup_hrtimer_broadcast(void)
>  {
>  	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>  	bctimer.function = bc_handler;
>  	clockevents_register_device(&ce_broadcast_hrtimer);
>  }
> +#endif

I see a build error in timers/core today:

kernel/time/tick-broadcast-hrtimer.c:101:6: error: redefinition of 'tick_setup_hrtimer_broadcast'
include/linux/clockchips.h:194:20: note: previous definition of 'tick_setup_hrtimer_broadcast' was here

and I assume this is the intended fix for that, although it isn't 
mentioned in the changelog.

After it's applied, this is left over:

kernel/time/tick-broadcast-hrtimer.c:91:29: warning: ‘bc_handler’ defined but not used [-Wunused-function]
--531381512-1904609958-1391931065=:8686--
