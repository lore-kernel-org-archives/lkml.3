Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902AbaLNQxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:53:55 -0500
Received: from smtprelay0099.hostedemail.com ([216.40.44.99]:39889 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752712AbaLNQxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:53:50 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2553:2559:2562:2693:2731:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:5007:6119:6261:7576:7875:8957:9010:10004:10400:10848:10967:11026:11232:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12740:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plant33_3854455f5935
X-Filterd-Recvd-Size: 4049
Date: Sun, 14 Dec 2014 11:53:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214115332.76be1b8b@gandalf.local.home>
In-Reply-To: <20141214164803.991954802@goodmis.org>
References: <20141214164104.307127356@goodmis.org>
	<20141214164803.991954802@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 11:41:05 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> In order to move enabling of trace events to just after mm_init(), the
> tracepoint enable code can not use call_rcu_sched() because rcu isn't
> even initialized yet.  Since this can only happen before SMP is set up
> (and even before interrupts are set up), there's no reason to use
> call_rcu_sched() at this point.
> 
> Instead, create a variable called tracepoint_rcu_safe that gets enabled
> via early_initcall() and if that is not set, free the code directly
> instead of using call_rcu_sched().
> 
> This allows us to enable tracepoints early without issues.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/tracepoint.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 3490407dc7b7..9b90ef0ac731 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -33,6 +33,15 @@ extern struct tracepoint * const __stop___tracepoints_ptrs[];
>  /* Set to 1 to enable tracepoint debug output */
>  static const int tracepoint_debug;
>  
> +/*
> + * traceoint_rcu_is_safe is set to true at early_initcall().
> + * Tracepoints can be enabled before rcu is initialized.
> + * When that happens, there's no reason to free via call_rcu()
> + * because the system isn't even in SMP mode yet, and rcu isn't
> + * initialized. Just directly free the old tracepoints instead.
> + */
> +static bool tracepoint_rcu_is_safe;

Hmm, I probably should make this read_mostly.

Although, it's not a hot path. Still, it gets set once at boot up and
never touched again. Yeah, that deserves a read_mostly.

-- Steve

> +
>  #ifdef CONFIG_MODULES
>  /*
>   * Tracepoint module list mutex protects the local module list.
> @@ -76,7 +85,16 @@ static inline void release_probes(struct tracepoint_func *old)
>  	if (old) {
>  		struct tp_probes *tp_probes = container_of(old,
>  			struct tp_probes, probes[0]);
> -		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
> +		/*
> +		 * Tracepoints can be enabled before RCU is initialized
> +		 * at boot up. If that is the case, do not bother using
> +		 * call_rcu() (because that will fail), but instead just
> +		 * free directly.
> +		 */
> +		if (likely(tracepoint_rcu_is_safe))
> +			call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
> +		else
> +			rcu_free_old_probes(&tp_probes->rcu);
>  	}
>  }
>  
> @@ -518,3 +536,10 @@ void syscall_unregfunc(void)
>  	}
>  }
>  #endif
> +
> +static __init int init_tracepoint_rcu(void)
> +{
> +	tracepoint_rcu_is_safe = true;
> +	return 0;
> +}
> +early_initcall(init_tracepoint_rcu);

