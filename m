Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3BOL5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:57:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49472 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3BOL5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:57:18 -0500
Date: Fri, 15 Feb 2013 12:57:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 08/33] nohz: Assign timekeeping duty to a non-full-nohz
 CPU
Message-ID: <20130215115706.GA14398@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Alessio Igor Bogani <abogani@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Metcalf <cmetcalf@tilera.com>,
	Christoph Lameter <cl@linux.com>,
	Geoff Levand <geoff@infradead.org>,
	Gilad Ben Yossef <gilad@benyossef.com>,
	Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Li Zhong <zhong@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
 <1357610913-1080-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357610913-1080-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:08:08AM +0100, Frederic Weisbecker wrote:
> This way the full nohz CPUs can safely run with the tick
> stopped with a guarantee that somebody else is taking
> care of the jiffies and gtod progression.
> 
> NOTE: this doesn't handle CPU hotplug. Also we could use something
> more elaborated wrt. powersaving if we have more than one non full-nohz
> CPU running. But let's use this KISS solution for now.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> [fix have_nohz_full_mask offcase]
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/time/tick-broadcast.c |    3 ++-
>  kernel/time/tick-common.c    |    5 ++++-
>  kernel/time/tick-sched.c     |    9 ++++++++-
>  3 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index f113755..596c547 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -537,7 +537,8 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>  		bc->event_handler = tick_handle_oneshot_broadcast;
>  
>  		/* Take the do_timer update */
> -		tick_do_timer_cpu = cpu;
> +		if (!tick_nohz_full_cpu(cpu))
> +			tick_do_timer_cpu = cpu;
>  
>  		/*
>  		 * We must be careful here. There might be other CPUs
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index b1600a6..83f2bd9 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -163,7 +163,10 @@ static void tick_setup_device(struct tick_device *td,
>  		 * this cpu:
>  		 */
>  		if (tick_do_timer_cpu == TICK_DO_TIMER_BOOT) {
> -			tick_do_timer_cpu = cpu;
> +			if (!tick_nohz_full_cpu(cpu))
> +				tick_do_timer_cpu = cpu;
> +			else
> +				tick_do_timer_cpu = TICK_DO_TIMER_NONE;
>  			tick_next_period = ktime_get();
>  			tick_period = ktime_set(0, NSEC_PER_SEC / HZ);
>  		}
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 494a2aa..b75e302 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -112,7 +112,8 @@ static void tick_sched_do_timer(ktime_t now)
>  	 * this duty, then the jiffies update is still serialized by
>  	 * jiffies_lock.
>  	 */
> -	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE))
> +	if (unlikely(tick_do_timer_cpu == TICK_DO_TIMER_NONE)
> +	    && !tick_nohz_full_cpu(cpu))
>  		tick_do_timer_cpu = cpu;
>  #endif
>  
> @@ -163,6 +164,8 @@ static int __init tick_nohz_full_setup(char *str)
>  	return 1;
>  }
>  __setup("full_nohz=", tick_nohz_full_setup);
> +#else
> +#define have_full_nohz_mask (0)
>  #endif

Looks like this hunk should be part of the previous patch, no?


...

Oui, oui monsieur! :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
