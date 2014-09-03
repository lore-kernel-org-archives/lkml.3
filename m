Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaICPM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:12:27 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54541 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757AbaICPMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:12:17 -0400
Date: Wed, 3 Sep 2014 08:03:06 -0700
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
Message-ID: <20140903150306.GU5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140828194745.GA3761@linux.vnet.ibm.com>
 <20140901112059.GG27892@worktop.ger.corp.intel.com>
 <20140901160550.GL5001@linux.vnet.ibm.com>
 <20140901161735.GA5806@worktop.ger.corp.intel.com>
 <20140902163656.GC5001@linux.vnet.ibm.com>
 <20140903113112.GM4783@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903113112.GM4783@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090315-7164-0000-0000-00000452BE98
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 01:31:12PM +0200, Peter Zijlstra wrote:
> On Tue, Sep 02, 2014 at 09:36:56AM -0700, Paul E. McKenney wrote:
> > On Mon, Sep 01, 2014 at 06:17:35PM +0200, Peter Zijlstra wrote:
> > > On Mon, Sep 01, 2014 at 09:05:50AM -0700, Paul E. McKenney wrote:
> > > > > URGH.. I really hate that. The hotplug interface is already too
> > > > > horrible, we should not add such hacks to it.
> > > > 
> > > > We do have try_ interfaces to a number of other subsystems, so I don't
> > > > believe that it qualifies as such a hack.
> > > 
> > > We do indeed, but I'm not sure about adding this to the hotplug stuff.
> > 
> > Looks pretty straightforward to me.
> > 
> > > Also; not really understanding the problem doesn't help. 
> > 
> > The current implementation of synchronize_sched_expedited()
> > calls get_online_cpus().  Some of the ACPI code needs to hold the
> > acpi_ioremap_lock mutex across synchronize_sched_expedited(), and
> > also needs to acquire this same mutex from a CPU hotplug notifier.
> > This results in deadlock between the cpu_hotplug.lock mutex and the
> > acpi_ioremap_lock mutex.
> 
> 
>   acpi_ioremap_lock			cpu_hotplug_begin()
>     synchronize_sched()			  acpi_ioremap_lock
>       get_online_cpus()
> 
> So yes, AB-BA.
> 
> > Normal RCU grace periods avoid this by synchronizing on a lock acquired by
> > the RCU CPU-hotplug notifiers, but this does not work for the expedited
> > grace periods because the outgoing CPU can be running random tasks for
> > quite some time after RCU's notifier executes.  So the fix is just to
> > drop back to a normal grace period when there is a CPU-hotplug operation
> > in progress.
> 
> So why are we 'normally' doing an expedited call here anyhow? 

Presumably because they set either the boot parameter or
the sysfs variable that causes synchronize_sched() to so
synchronize_sched_expedited().

> > > > > How about ripping that rcu_expedited stuff out instead? That's all
> > > > > conditional anyhow, so might as well not do it.
> > > > 
> > > > In what way is the expedited stuff conditional?
> > > 
> > > synchronize_sched() conditionally calls synchronize_sched_expedited()
> > > and its condition: rcu_expedited, gets set/cleared on pm notifiers and
> > > nr_cpu_ids.
> > 
> > There are also direct calls to both synchronize_sched_expedited() and
> > synchronize_rcu_expedited().
> 
> But those are not within hotplug bits. Also weren't we removing them? I
> thought we didn't appreciate spraying IPIs like they do?

I hadn't heard anything about removing them, but making the
expedited primitives a bit less IPI-happy is on my list.

							Thanx, Paul

