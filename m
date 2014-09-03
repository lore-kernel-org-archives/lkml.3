Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbaICQjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:39:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59838 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaICQjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:39:03 -0400
Date: Wed, 3 Sep 2014 09:38:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, <""@rjwysocki.net>,
        tianyu.lan@intel.com
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
Message-ID: <20140903163852.GY5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140828194745.GA3761@linux.vnet.ibm.com>
 <20140901112059.GG27892@worktop.ger.corp.intel.com>
 <20140901160550.GL5001@linux.vnet.ibm.com>
 <20140901161735.GA5806@worktop.ger.corp.intel.com>
 <20140902163656.GC5001@linux.vnet.ibm.com>
 <20140903113112.GM4783@worktop.ger.corp.intel.com>
 <20140903150306.GU5001@linux.vnet.ibm.com>
 <20140903152850.GQ4783@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903152850.GQ4783@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090316-0928-0000-0000-0000049AE82D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 05:28:50PM +0200, Peter Zijlstra wrote:
> On Wed, Sep 03, 2014 at 08:03:06AM -0700, Paul E. McKenney wrote:
> > > > Normal RCU grace periods avoid this by synchronizing on a lock acquired by
> > > > the RCU CPU-hotplug notifiers, but this does not work for the expedited
> > > > grace periods because the outgoing CPU can be running random tasks for
> > > > quite some time after RCU's notifier executes.  So the fix is just to
> > > > drop back to a normal grace period when there is a CPU-hotplug operation
> > > > in progress.
> > > 
> > > So why are we 'normally' doing an expedited call here anyhow? 
> > 
> > Presumably because they set either the boot parameter or
> > the sysfs variable that causes synchronize_sched() to so
> > synchronize_sched_expedited().
> 
> That's not a why but a how. Why does that option exist, why are we doing
> this?

As you say below, to reduce RCU grace-period latency on small systems.
And one level of abstraction's why is another level's how.  ;-)

> I cannot actually find a sysfs variable that controls this though; only
> the rcu_pm_notifier. It seems to favour doing an expedited call when
> suspending on 'small' machines.

See rcu_expedited_store() in kernel/ksysfs.c.  Or the rcu_expedited
module_param() in kernel/rcu/update.c.

> > > But those are not within hotplug bits. Also weren't we removing them? I
> > > thought we didn't appreciate spraying IPIs like they do?
> > 
> > I hadn't heard anything about removing them, but making the
> > expedited primitives a bit less IPI-happy is on my list.
> 
> I had some recollections of removing a fair number of expedited calls,
> but its was a long while ago so what do I know ;-)

If a given use case can tolerate the latency of normal calls, then the
normal calls certainly are preferable, no two ways about it.

> Making them less IPI happy would be good indeed.

Priority of this task duly increased.  ;-)

							Thanx, Paul

