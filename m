Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab3KVEUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 23:20:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56168 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3KVEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 23:20:44 -0500
Date: Thu, 21 Nov 2013 20:20:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20131122042036.GL4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131120160450.072555619@infradead.org>
 <20131120162736.508462614@infradead.org>
 <20131120165406.14fa0f09@ultegra>
 <20131121082151.GU10022@twins.programming.kicks-ass.net>
 <20131121160716.GT4138@linux.vnet.ibm.com>
 <528E32EF.2050300@linux.intel.com>
 <20131121191916.GZ4138@linux.vnet.ibm.com>
 <528E62D0.3010003@linux.intel.com>
 <20131121200717.GB4138@linux.vnet.ibm.com>
 <20131121161005.34150ab2@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121161005.34150ab2@ultegra>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112204-0928-0000-0000-000003ECBADA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 04:10:05PM -0800, Jacob Pan wrote:
> On Thu, 21 Nov 2013 12:07:17 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Thu, Nov 21, 2013 at 11:45:20AM -0800, Arjan van de Ven wrote:
> > > On 11/21/2013 11:19 AM, Paul E. McKenney wrote:
> > > >On Thu, Nov 21, 2013 at 08:21:03AM -0800, Arjan van de Ven wrote:
> > > >>On 11/21/2013 8:07 AM, Paul E. McKenney wrote:
> > > >>>As long as RCU has some reliable way to identify an idle task, I
> > > >>>am good.  But I have to ask -- why can't idle injection
> > > >>>coordinate with the existing idle tasks rather than temporarily
> > > >>>making alternative idle tasks?
> > > >>
> > > >>it's not a real idle. that's the whole problem of the situation.
> > > >>to the rest of the OS, this is being BUSY (busy saving power using
> > > >>a CPU instruction, but it might as well have been an mdelay()
> > > >>operation) and it's also what end users expect; they want to be
> > > >>able to see where there performance (read: cpu time in "top") is
> > > >>going.
> > > >
> > > >My concern is keeping RCU's books straight.  Suppose that there is
> > > >a need to call for idle in the middle of a preemptible RCU
> > > >read-side critical section.  Now, if that call for idle involves a
> > > >context switch, all is well -- RCU will see the task as still
> > > >being in its RCU read-side critical section, which means that it
> > > >is OK for RCU to see the CPU as idle.
> > > >
> > > >However, if there is no context switch and RCU sees the CPU as
> > > >idle, preemptible RCU could prematurely end the grace period.  If
> > > >there is no context switch and RCU sees the CPU as non-idle for
> > > >too long, we start getting RCU CPU stall warning splats.
> > > >
> > > >Another approach would be to only inject idle when the CPU is not
> > > >doing anything that could possibly be in an RCU read-side critical
> > > >section.  But things might get a bit hot in case of an overly
> > > >long RCU read-side critical section.
> > > >
> > > >One approach that might work would be to hook into RCU's
> > > >context-switch code going in and coming out, then telling RCU that
> > > >the CPU is idle, even though top and friends see it as non-idle.
> > > >This last is in fact similar to how RCU handles userspace
> > > >execution for NO_HZ_FULL.
> > > >
> > > 
> > > so powerclamp and such are not "idle".
> > > They are "busy" from everything except the lowest level of the CPU
> > > hardware. once you start thinking of them as idle, all hell breaks
> > > lose in terms of implications (including sysadmin visibility
> > > etc).... (hence some of the explosions in this thread as well).
> > > 
> > > but it's not "idle".
> > > 
> > > it's "put the cpu in a low power state for a specified amount of
> > > time". sure it uses the same instruction to do so that the idle
> > > loop uses.
> > > 
> > > (now to make it messy, the current driver does a bunch of things
> > > similar to the idle loop which is a mess and fair to be complained
> > > about)
> > 
> > Then from an RCU viewpoint, they need to be short in duration.
> > Otherwise you risk getting CPU stall-warning explosions from RCU.  ;-)
> > 
> > 							Thanx, Paul
> > 
> currently powerclamp allow idle injection duration between 6 to 25ms.
> I guess that is short considering the stall check is in seconds?
> 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;

The 6ms to 25ms range should be just fine as far as normal RCU grace
periods are concerned.  However, it does mean that expedited grace
periods could be delayed: They normally take a few tens of microseconds,
but if they were unlucky enough to show up during an idle injection,
they would be magnified by two to three orders of magnitude, which is
not pretty.

Hence my suggestion of hooking into RCU on idle-injection start and end
so that RCU considers that time period to be idle.  Just like it does
for user-mode execution on NO_HZ_FULL kernels, so I still don't see this
approach to be a problem.  I must confess that I still don't understand
what Arjan doesn't like about it.

							Thanx, Paul

> BTW, by forcing intel_idle to use deepest c-states for idle injection
> thread the efficiency problem is gone. I am surprised that cpuidle
> would not pick the deepest c-states given powerclamp driver is asking
> for 6ms idle time and the wakeup latencies are in the usec.
> Anyway, for what i have tested so far powerclamp with this patchset can
> work as well as the code before.
> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> [Jacob Pan]
> 

