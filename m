Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaIAL3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:29:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:56607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaIAL3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:29:37 -0400
Date: Mon, 1 Sep 2014 13:29:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Break more call_rcu() deadlock
 involving scheduler and perf
Message-ID: <20140901112934.GH27892@worktop.ger.corp.intel.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1409250394-25159-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409250394-25159-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 11:26:30AM -0700, Paul E. McKenney wrote:

> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index b6acb9340192..a1af86099a67 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2121,16 +2121,23 @@ static void __call_rcu_nocb_enqueue(struct rcu_data *rdp,
>  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
>  					    TPS("WakeEmpty"));
>  		} else {
> -			rdp->nocb_defer_wakeup = true;
> +			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE;
>  			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
>  					    TPS("WakeEmptyIsDeferred"));
>  		}
>  		rdp->qlen_last_fqs_check = 0;
>  	} else if (len > rdp->qlen_last_fqs_check + qhimark) {
>  		/* ... or if many callbacks queued. */
> -		wake_nocb_leader(rdp, true);
> +		if (!irqs_disabled_flags(flags)) {
> +			wake_nocb_leader(rdp, true);
> +			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> +					    TPS("WakeOvf"));
> +		} else {
> +			rdp->nocb_defer_wakeup = RCU_NOGP_WAKE_FORCE;
> +			trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu,
> +					    TPS("WakeOvfIsDeferred"));
> +		}
>  		rdp->qlen_last_fqs_check = LONG_MAX / 2;
> -		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeOvf"));
>  	} else {
>  		trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("WakeNot"));
>  	}

Is it possible for the RCU_NOCP_WAKE write to overwrite a WAKE_FORCE ?
If not, why not? (Would make a good comment thereabouts).
