Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab3JATFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:05:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59233 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3JATFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:05:23 -0400
Date: Tue, 1 Oct 2013 12:05:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, tony.luck@intel.com,
        bp@alien8.de
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131001190515.GI5790@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130925175055.GA25914@redhat.com>
 <20130928144720.GL15690@laptop.programming.kicks-ass.net>
 <20130928163104.GA23352@redhat.com>
 <7632387.20FXkuCITr@vostro.rjw.lan>
 <524B0233.8070203@linux.vnet.ibm.com>
 <20131001173615.GW3657@laptop.programming.kicks-ass.net>
 <20131001174508.GA17411@redhat.com>
 <20131001175640.GQ15690@laptop.programming.kicks-ass.net>
 <20131001180750.GA18261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131001180750.GA18261@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100119-6688-0000-0000-00000226938D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 08:07:50PM +0200, Oleg Nesterov wrote:
> On 10/01, Peter Zijlstra wrote:
> >
> > On Tue, Oct 01, 2013 at 07:45:08PM +0200, Oleg Nesterov wrote:
> > >
> > > I tend to agree with Srivatsa... Without a strong reason it would be better
> > > to preserve the current logic: "some time after" should not be after the
> > > next CPU_DOWN/UP*. But I won't argue too much.
> >
> > Nah, I think breaking it is the right thing :-)
> 
> I don't really agree but I won't argue ;)

The authors of arch/x86/kernel/cpu/mcheck/mce.c would seem to be the
guys who would need to complain, given that they seem to have the only
use in 3.11.

							Thanx, Paul

> > > But note that you do not strictly need this change. Just kill cpuhp_waitcount,
> > > then we can change cpu_hotplug_begin/end to use xxx_enter/exit we discuss in
> > > another thread, this should likely "join" all synchronize_sched's.
> >
> > That would still be 4k * sync_sched() == terribly long.
> 
> No? the next xxx_enter() avoids sync_sched() if rcu callback is still
> pending. Unless __cpufreq_remove_dev_finish() is "too slow" of course.
> 
> > > Or split cpu_hotplug_begin() into 2 helpers which handle FAST -> SLOW and
> > > SLOW -> BLOCK transitions, then move the first "FAST -> SLOW" handler outside
> > > of for_each_online_cpu().
> >
> > Right, that's more messy but would work if we cannot teach cpufreq (and
> > possibly others) to not rely on state you shouldn't rely on anyway.
> 
> Yes,
> 
> > I tihnk the only guarnatee POST_DEAD should have is that it should be
> > called before UP_PREPARE of the same cpu ;-) Nothing more, nothing less.
> 
> See above... This makes POST_DEAD really "special" compared to other
> CPU_* events.
> 
> And again. Something like a global lock taken by CPU_DOWN_PREPARE and
> released by POST_DEAD or DOWN_FAILED does not look "too wrong" to me.
> 
> But I leave this to you and Srivatsa.
> 
> Oleg.
> 

