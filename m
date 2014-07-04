Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaGDFFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:05:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46654 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGDFFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:05:49 -0400
Date: Thu, 3 Jul 2014 22:05:41 -0700
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
Message-ID: <20140704050541.GL4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <1404358279.5137.63.camel@marge.simpson.net>
 <20140703052124.GB4603@linux.vnet.ibm.com>
 <1404366520.5137.90.camel@marge.simpson.net>
 <20140703162944.GG4603@linux.vnet.ibm.com>
 <1404444236.5756.36.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404444236.5756.36.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070405-0928-0000-0000-000003292772
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 05:23:56AM +0200, Mike Galbraith wrote:
> On Thu, 2014-07-03 at 09:29 -0700, Paul E. McKenney wrote: 
> > On Thu, Jul 03, 2014 at 07:48:40AM +0200, Mike Galbraith wrote:
> > > On Wed, 2014-07-02 at 22:21 -0700, Paul E. McKenney wrote: 
> > > > On Thu, Jul 03, 2014 at 05:31:19AM +0200, Mike Galbraith wrote:
> > > 
> > > > > NO_HZ_FULL is a property of a set of CPUs.  isolcpus is supposed to go
> > > > > away as being a redundant interface to manage a single property of a set
> > > > > of CPUs, but it's perfectly fine for NO_HZ_FULL to add an interface to
> > > > > manage a single property of a set of CPUs.  What am I missing? 
> > > > 
> > > > Well, for now, it can only be specified at build time or at boot time.
> > > > In theory, it is possible to change a CPU from being callback-offloaded
> > > > to not at runtime, but there would need to be an extremely good reason
> > > > for adding that level of complexity.  Lots of "fun" races in there...
> > > 
> > > Yeah, understood.
> > > 
> > > (still it's a NO_HZ_FULL wart though IMHO, would be prettier and more
> > > usable if it eventually became unified with cpuset and learned how to
> > > tap-dance properly;)
> > 
> > Agreed, it would in some sense be nice.  What specifically do you need
> > it for?
> 
> I personally have zero use for the thing (git/vi aren't particularly
> perturbation sensitive;). I'm just doing occasional drive-by testing
> from a distro perspective, how well does it work, what does it cost etc.
> 
> >   Are you really running workloads that generate large numbers of
> > callbacks spread across most of the CPUs?  It was this sort of workload
> > that caused Rik's system to show scary CPU-time accumulation, due to
> > the high overhead of frequent one-to-many wakeups.
> > 
> > If your systems aren't running that kind of high-callback-rate workload,
> > just set CONFIG_RCU_NOCB_CPU_ALL=y and don't worry about it.
> > 
> > If your systems -are- running that kind of high-callback-rate workload,
> > but your system has fewer than 200 CPUs, ensure that you have enough
> > housekeeping CPUs to allow the grace-period kthread sufficient CPU time,
> > set CONFIG_RCU_NOCB_CPU_ALL=y and don't worry about it.
> > 
> > If your systems -are- running that kind of high-callback-rate workload,
> > and your system has more than 200 CPUs, apply the following patch,
> > set CONFIG_RCU_NOCB_CPU_ALL=y and once again don't worry about it.  ;-)
> 
> Turn it on and don't worry about it is exactly what distros want the
> obscure feature with very few users to be.  Last time I did a drive-by,
> my boxen said I should continue to worry about it ;-)

Yep, which is the reason for the patch on the last email.

Then again, exactly which feature and which reason for worry?

							Thanx, Paul

