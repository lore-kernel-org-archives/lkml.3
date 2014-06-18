Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbaFRAAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:00:25 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39708 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaFRAAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:00:23 -0400
X-Originating-IP: 50.43.32.211
Date: Tue, 17 Jun 2014 17:00:14 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618000014.GA9082@thin>
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A0CAE5.9000702@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 04:10:29PM -0700, Dave Hansen wrote:
> On 06/13/2014 03:45 PM, Paul E. McKenney wrote:
> >> > Could the additional RCU quiescent states be causing us to be doing more
> >> > RCU frees that we were before, and getting less benefit from the lock
> >> > batching that RCU normally provides?
> > Quite possibly.  One way to check would be to use the debugfs files
> > rcu/*/rcugp, which give a count of grace periods since boot for each
> > RCU flavor.  Here "*" is rcu_preempt for CONFIG_PREEMPT and rcu_sched
> > for !CONFIG_PREEMPT.
> 
> With the previously-mentioned workload, rcugp's "age" averages 9 with
> the old kernel (or RCU_COND_RESCHED_LIM at a high value) and 2 with the
> current kernel which contains this regression.
> 
> I also checked the rate and sources for how I'm calling cond_resched.
> I'm calling it 5x for every open/close() pair in my test case, which
> take about 7us.  So, _cond_resched() is, on average, only being called
> every microsecond.  That doesn't seem _too_ horribly extreme.
> 
> >  3895.165846 |     8)               |  SyS_open() {
> >  3895.165846 |     8)   0.065 us    |    _cond_resched();
> >  3895.165847 |     8)   0.064 us    |    _cond_resched();
> >  3895.165849 |     8)   2.406 us    |  }
> >  3895.165849 |     8)   0.199 us    |  SyS_close();
> >  3895.165850 |     8)               |  do_notify_resume() {
> >  3895.165850 |     8)   0.063 us    |    _cond_resched();
> >  3895.165851 |     8)   0.069 us    |    _cond_resched();
> >  3895.165852 |     8)   0.060 us    |    _cond_resched();
> >  3895.165852 |     8)   2.194 us    |  }
> >  3895.165853 |     8)               |  SyS_open() {
> 
> The more I think about it, the more I think we can improve on a purely
> call-based counter.
> 
> First, it couples the number of cond_resched() directly calls with the
> benefits we see out of RCU.  We really don't *need* to see more grace
> periods if we have more cond_resched() calls.
> 
> It also ends up eating a new cacheline in a bunch of pretty hot paths.
> It would be nice to be able to keep the fast path part of this as at
> least read-only.
> 
> Could we do something (functionally) like the attached patch?  Instead
> of counting cond_resched() calls, we could just specify some future time
> by which we want have a quiescent state.  We could even push the time to
> be something _just_ before we would have declared a stall.

Looks quite promising to me, as long as the CPU in question is actively
updating jiffies.  I'd love to see some numbers from that approach.

- Josh Triplett
