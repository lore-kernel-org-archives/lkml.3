Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3JHJN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:13:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58916 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3JHJN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:13:57 -0400
Date: Tue, 8 Oct 2013 11:13:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131008091339.GN3081@twins.programming.kicks-ass.net>
References: <20131004184614.GA17536@redhat.com>
 <20131004184629.GA17550@redhat.com>
 <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
 <20131004153012.19245adb@gandalf.local.home>
 <CA+55aFwda1pErt32162S_1gq=Kkge7Gj3n2sm_rOopAtz2bVUQ@mail.gmail.com>
 <20131005171746.GA17664@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131005171746.GA17664@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 07:17:46PM +0200, Oleg Nesterov wrote:
> To me the annoying part is that this patch exports rcu_sync_ops*.
> We can add "enum rcu_sync_type rcu_sync_struct->gp_type" instead,
> see the patch below. But then the next "add the CONFIG_PROVE_RCU
> checks" needs to uninline rcu_sync_is_idle() for CONFIG_PROVE_RCU.
> 
> Or do you still think we should do something else?

> @@ -44,7 +45,7 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
>  	BUG_ON(need_wait && need_sync);
>  
>  	if (need_sync) {
> -		rss->sync();
> +		gp_ops[rss->gp_type].sync();
>  		rss->gp_state = GP_PASSED;
>  		wake_up_all(&rss->gp_wait);
>  	} else if (need_wait) {
> @@ -81,7 +82,7 @@ static void rcu_sync_func(struct rcu_head *rcu)
>  		 * to catch a later GP.
>  		 */
>  		rss->cb_state = CB_PENDING;
> -		rss->call(&rss->cb_head, rcu_sync_func);
> +		gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
>  	} else {
>  		/*
>  		 * We're at least a GP after rcu_sync_exit(); eveybody will now
> @@ -99,7 +100,7 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
>  	if (!--rss->gp_count) {
>  		if (rss->cb_state == CB_IDLE) {
>  			rss->cb_state = CB_PENDING;
> -			rss->call(&rss->cb_head, rcu_sync_func);
> +			gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
>  		} else if (rss->cb_state == CB_PENDING) {
>  			rss->cb_state = CB_REPLAY;
>  		}
> 

I think Linus meant to have rcu_sync_{enter,exit} as inlines with a
const enum argument for the gp_type.

That said; yes that will generate better code, but also more code, and
like Steven already argued performance isn't really an issue here since
we're going to potentially sleep for a rather long time.


