Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaGCFVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:21:34 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46671 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaGCFVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:21:32 -0400
Date: Wed, 2 Jul 2014 22:21:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        riel@redhat.com, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140703052124.GB4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <1404358279.5137.63.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404358279.5137.63.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070305-9332-0000-0000-00000144D9E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 05:31:19AM +0200, Mike Galbraith wrote:
> On Wed, 2014-07-02 at 10:08 -0700, Paul E. McKenney wrote: 
> > On Wed, Jul 02, 2014 at 06:04:12PM +0200, Peter Zijlstra wrote:
> > > On Wed, Jul 02, 2014 at 08:39:15AM -0700, Paul E. McKenney wrote:
> > > > On Wed, Jul 02, 2014 at 02:34:12PM +0200, Peter Zijlstra wrote:
> > > > > On Fri, Jun 27, 2014 at 07:20:38AM -0700, Paul E. McKenney wrote:
> > > > > > An 80-CPU system with a context-switch-heavy workload can require so
> > > > > > many NOCB kthread wakeups that the RCU grace-period kthreads spend several
> > > > > > tens of percent of a CPU just awakening things.  This clearly will not
> > > > > > scale well: If you add enough CPUs, the RCU grace-period kthreads would
> > > > > > get behind, increasing grace-period latency.
> > > > > > 
> > > > > > To avoid this problem, this commit divides the NOCB kthreads into leaders
> > > > > > and followers, where the grace-period kthreads awaken the leaders each of
> > > > > > whom in turn awakens its followers.  By default, the number of groups of
> > > > > > kthreads is the square root of the number of CPUs, but this default may
> > > > > > be overridden using the rcutree.rcu_nocb_leader_stride boot parameter.
> > > > > > This reduces the number of wakeups done per grace period by the RCU
> > > > > > grace-period kthread by the square root of the number of CPUs, but of
> > > > > > course by shifting those wakeups to the leaders.  In addition, because
> > > > > > the leaders do grace periods on behalf of their respective followers,
> > > > > > the number of wakeups of the followers decreases by up to a factor of two.
> > > > > > Instead of being awakened once when new callbacks arrive and again
> > > > > > at the end of the grace period, the followers are awakened only at
> > > > > > the end of the grace period.
> > > > > > 
> > > > > > For a numerical example, in a 4096-CPU system, the grace-period kthread
> > > > > > would awaken 64 leaders, each of which would awaken its 63 followers
> > > > > > at the end of the grace period.  This compares favorably with the 79
> > > > > > wakeups for the grace-period kthread on an 80-CPU system.
> > > > > 
> > > > > Urgh, how about we kill the entire nocb nonsense and try again? This is
> > > > > getting quite rediculous.
> > > > 
> > > > Sure thing, Peter.
> > > 
> > > So you don't think this has gotten a little out of hand? The NOCB stuff
> > > has lead to these masses of rcu threads and now you're adding extra
> > > cache misses to the perfectly sane and normal code paths just to deal
> > > with so many threads.
> > 
> > Indeed it appears to have gotten a bit out of hand.  But let's please
> > attack the real problem rather than the immediate irritant.
> > 
> > And in this case, the real problem is that users are getting callback
> > offloading even when there is no reason for it.
> > 
> > > And all to support a feature that nearly nobody uses. And you were
> > > talking about making nocb the default rcu...
> > 
> > As were others, not that long ago.  Today is the first hint that I got
> > that you feel otherwise.  But it does look like the softirq approach to
> > callback processing needs to stick around for awhile longer.  Nice to
> > hear that softirq is now "sane and normal" again, I guess.  ;-)
> > 
> > Please see my patch in reply to Rik's email.  The idea is to neither
> > rip callback offloading from the kernel nor to keep callback offloading
> > as the default, but instead do callback offloading only for those CPUs
> > specifically marked as NO_HZ_FULL CPUs, or when specifically requested
> > at build time or at boot time.  In other words, only do it when it is
> > needed.
> 
> Exactly!  Like dynamically, when the user isolates CPUs via the cpuset
> interface, none of it making much sense without that particular property
> of a set of CPUs, and cpuset being the manager of CPU set properties.

Glad you like it!  ;-)

> NO_HZ_FULL is a property of a set of CPUs.  isolcpus is supposed to go
> away as being a redundant interface to manage a single property of a set
> of CPUs, but it's perfectly fine for NO_HZ_FULL to add an interface to
> manage a single property of a set of CPUs.  What am I missing? 

Well, for now, it can only be specified at build time or at boot time.
In theory, it is possible to change a CPU from being callback-offloaded
to not at runtime, but there would need to be an extremely good reason
for adding that level of complexity.  Lots of "fun" races in there...

						Thanx, Paul

