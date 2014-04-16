Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161032AbaDPNEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:04:04 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:36555 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbaDPNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:04:01 -0400
Date: Wed, 16 Apr 2014 06:03:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, cl@linux.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tj@kernel.org, grygorii.strashko@ti.com
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140416130355.GW4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <20140415222951.GA742@redhat.com>
 <20140415224725.GS4496@linux.vnet.ibm.com>
 <20140416035419.GA30105@linux.vnet.ibm.com>
 <20140416052147.GK26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416052147.GK26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041613-1344-0000-0000-000000F5B019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 07:21:48AM +0200, Peter Zijlstra wrote:
> On Tue, Apr 15, 2014 at 08:54:19PM -0700, Paul E. McKenney wrote:
> > But falling back on the old ways of doing this at least looks a bit
> > nicer:
> > 
> > 	static inline bool rcu_should_resched(void)
> > 	{
> > 		int t;
> > 		int *tp = &per_cpu(rcu_cond_resched_count, raw_smp_processor_id());
> > 
> > 		t = ACCESS_ONCE(*tp) + 1;
> > 		if (t < RCU_COND_RESCHED_LIM) {
> 
> <here>
> 
> > 			ACCESS_ONCE(*tp) = t;
> > 			return false;
> > 		}
> > 		return true;
> > 	}
> > 
> > Other thoughts?
> 
> Still broken, if A starts out on CPU1, gets migrated to CPU0 at <here>,
> then B starts the same on CPU1. It is possible for both CPU0 and CPU1 to
> write a different value into your rcu_cond_resched_count.

That is actually OK.  The values written are guaranteed to be between
zero and RCU_COND_RESCHED_LIM-1.  In theory, yes, rcu_should_resched()
could end up failing due to a horribly unlucky sequence of preemptions,
but the probability is -way- lower than that of hardware failure.

However...

> You really want to disable preemption around there. The proper old way
> would've been get_cpu_var()/put_cpu_var().

If you are OK with unconditional disabling of preemption at this point,
that would avoid worrying about probabilities and would be quite a bit
simpler.

So unconditional preempt_disable()/preempt_enable() it is.

							Thanx, Paul

