Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3ILUQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:16:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50112 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3ILUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:16:20 -0400
Date: Thu, 12 Sep 2013 13:16:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Travis <travis@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
Message-ID: <20130912201608.GW3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130905225032.879120272@asylum.americas.sgi.com>
 <20130905225034.343366161@asylum.americas.sgi.com>
 <20130909124349.GY31370@twins.programming.kicks-ass.net>
 <522E0037.3090107@sgi.com>
 <20130910090349.GN26785@twins.programming.kicks-ass.net>
 <20130912172731.GR3966@linux.vnet.ibm.com>
 <52320F18.4040407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52320F18.4040407@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091220-6688-0000-0000-000001A0FFF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 11:59:36AM -0700, Mike Travis wrote:
> On 9/12/2013 10:27 AM, Paul E. McKenney wrote:
> > On Tue, Sep 10, 2013 at 11:03:49AM +0200, Peter Zijlstra wrote:
> >> On Mon, Sep 09, 2013 at 10:07:03AM -0700, Mike Travis wrote:
> >>> On 9/9/2013 5:43 AM, Peter Zijlstra wrote:
> >>>> On Thu, Sep 05, 2013 at 05:50:41PM -0500, Mike Travis wrote:
> >>>>> For performance reasons, the NMI handler may be disabled to lessen the
> >>>>> performance impact caused by the multiple perf tools running concurently.
> >>>>> If the system nmi command is issued when the UV NMI handler is disabled,
> >>>>> the "Dazed and Confused" messages occur for all cpus.  The NMI handler is
> >>>>> disabled by setting the nmi disabled variable to '1'.  Setting it back to
> >>>>> '0' will re-enable the NMI handler.
> >>>>
> >>>> I'm not entirely sure why this is still needed now that you've moved all
> >>>> really expensive bits into the UNKNOWN handler.
> >>>>
> >>>
> >>> Yes, it could be considered optional.  My primary use was to isolate
> >>> new bugs I found to see if my NMI changes were causing them.  But it
> >>> appears that they are not since the problems occur with or without
> >>> using the NMI entry into KDB.  So it can be safely removed.
> >>
> >> OK, as a debug option it might make sense, but removing it is (of course)
> >> fine with me ;-)
> >>
> >>> (The basic problem is that if you hang out in KDB too long the machine
> >>> locks up.  
> >>
> >> Yeah, known issue. Not much you can do about it either I suspect. The
> >> system generally isn't build for things like that.
> >>
> >>> Other problems like the rcu stall detector does not have a
> >>> means to be "touched" like the nmi_watchdog_timer so it fires off a
> >>> few to many, many messages.  
> >>
> >> That however might be easily cured if you ask Paul nicely ;-)
> > 
> > RCU's grace-period mechanism is supposed to be what touches it.  ;-)
> > 
> > But what is it that you are looking for?  If you want to silence it
> > completely, the rcu_cpu_stall_suppress boot/sysfs parameter is what
> > you want to use.
> 
> We have by default rcutree.rcu_cpu_stall_suppress=1 on the kernel
> cmdline.  I'll double check if it was set during my testing.
> 
> > 
> >>> Another, any network connections will time
> >>> out if you are in KDB more than say 20 or 30 seconds.)
> > 
> > Ah, you are looking for RCU to refrain from complaining about grace
> > periods that have been delayed by breakpoints in the kernel?  Is there
> > some way that RCU can learn that a breakpoint has happened?  If so,
> > this should not be hard.
> 
> Yes, exactly.  After a UV NMI event which might or might not call KDB,
> but definitely can consume some time with the system stopped, I have
> these notifications:
> 
> static void uv_nmi_touch_watchdogs(void)
> {
>         touch_softlockup_watchdog_sync();
>         clocksource_touch_watchdog();
>         rcu_cpu_stall_reset();

This function effectively disables RCU CPU stall warnings for the current
set of grace periods.  Or is supposed to do so, anyway.  I won't guarantee
that this is avoids false positive in the face of all possible races
between grace-period initialization, calls to rcu_cpu_stall_reset(),
and stall warnings.

So how often are you seeing RCU CPU stall warnings?

>         touch_nmi_watchdog();
> }
> 
> 
> In all the cases I checked, I had all the cpus in the NMI event so
> I don't think it was a straggler who triggered the problem.  One
> question though, the above is called by all cpus exiting the NMI
> event.  Should I limit that to only one cpu?

You should only need to invoke rcu_cpu_stall_reset() from a single CPU.
That said, I would not expect problems from concurrent invocations,
unless your compiler stores to a long with a pair of smaller stores
or something.

> Note btw, that this also happens when KGDB/KDB is entered via the
> sysrq-trigger 'g' event.
> 
> Perhaps there is some other timer that is going off?

Is uv_nmi_touch_watchdogs() invoked on the way in to the breakpoint?
On the way out?  Both?  Either way, what software environment does it
run in?  The only environment completely safe against races on the way
in would be stop_machine() -- otherwise, a grace period might start just
after uv_nmi_touch_watchdogs() returned, which would cause a normal RCU
CPU stall timeout to be in effect.

> > If not, I must fall back on the rcu_cpu_stall_suppress that I mentioned
> > earlier.
> > 
> >>> One other problem is with the perf tool.  It seems running more than
> >>> about 2 or 3 perf top instances on a medium (1k cpu threads) sized
> >>> system, they start behaving badly with a bunch of NMI stackdumps
> >>> appearing on the console.  Eventually the system become unusable.
> >>
> >> Yuck.. I haven't seen anything like that on the 'tiny' systems I have :/
> > 
> > Indeed, with that definition of "medium", large must be truly impressive!
> 
> I say medium because it's only one rack w/~4TB of memory (and quite
> popular).  Large would be 4k cpus/64TB.  Not sure yet what is "huge",
> at least in terms of an SSI system.

Well, when I tell people that someone reported a bug running on a
4K-CPU system, they look at me funny.  ;-)

							Thanx, Paul

> >>> On a large system (4k), the perf tools get an error message (sorry
> >>> don't have it handy at the moment) the basically implies that the
> >>> perf config option is not set.  Again, I wanted to remove the new
> >>> NMI handler to insure that it wasn't doing something weird, and
> >>> it wasn't.
> >>
> >> Cute.. 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > 
> 

