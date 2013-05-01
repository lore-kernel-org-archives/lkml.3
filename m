Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033Ab3EAO0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:26:20 -0400
Received: from ja.ssi.bg ([178.16.129.10]:36724 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755627Ab3EAO0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:26:14 -0400
Date: Wed, 1 May 2013 17:22:05 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Peter Zijlstra <peterz@infradead.org>
cc: Simon Horman <horms@verge.net.au>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
In-Reply-To: <20130501091012.GB28253@dyad.programming.kicks-ass.net>
Message-ID: <alpine.LFD.2.00.1305011344320.1603@ja.ssi.bg>
References: <1367290378-29224-1-git-send-email-horms@verge.net.au> <1367290378-29224-2-git-send-email-horms@verge.net.au> <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg> <20130430072944.GA13959@verge.net.au> <alpine.LFD.2.00.1304301051260.1700@ja.ssi.bg>
 <20130501091012.GB28253@dyad.programming.kicks-ass.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Wed, 1 May 2013, Peter Zijlstra wrote:

> On Tue, Apr 30, 2013 at 10:52:38AM +0300, Julian Anastasov wrote:
> > 
> > 	Hello,
> > 
> > On Tue, 30 Apr 2013, Simon Horman wrote:
> > 
> > > Thanks, to clarify, just this:
> > > 
> > > static void inline cond_resched_rcu_lock(void)
> > > {
> > > 	rcu_read_unlock();
> > > #ifndef CONFIG_PREEMPT_RCU
> > > 	cond_resched();
> > > #endif
> > > 	rcu_read_lock();
> > > }
> > 
> > 	Yes, thanks!
> 
> OK, now I'm confused.. PREEMPT_RCU would preempt in any case, so why bother
> dropping rcu_read_lock() at all?
> 
> That is; the thing that makes sense to me is:
> 
> static void inline cond_resched_rcu_lock(void)
> {
> #ifdef CONFIG_PREEMPT_RCU

	You mean '#ifndef' here, right? But in the non-preempt
case is using the need_resched() needed? rcu_read_unlock
and rcu_read_lock do not generate code.

> 	if (need_resched()) {
> 		rcu_read_unlock();
> 		cond_resched();
> 		rcu_read_lock();
> 	}
> #endif /* CONFIG_PREEMPT_RCU */
> }
> 
> That would have an rcu_read_lock() break and voluntary preemption point for
> non-preemptible RCU and not bother with the stuff for preemptible RCU.

	I see. So, can we choose one of both variants:

1. Your variant but with ifndef:

static void inline cond_resched_rcu_lock(void)
{
#ifndef CONFIG_PREEMPT_RCU
	if (need_resched()) {
		rcu_read_unlock();
		cond_resched();
		rcu_read_lock();
	}
#endif
}

2. Same without need_resched because cond_resched already
performs the same checks:

static void inline cond_resched_rcu_lock(void)
{
#ifndef CONFIG_PREEMPT_RCU
	rcu_read_unlock();
	cond_resched();
	rcu_read_lock();
#endif
}

Regards

--
Julian Anastasov <ja@ssi.bg>
