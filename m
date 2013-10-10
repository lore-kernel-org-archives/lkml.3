Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3JJRpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:45:12 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:34677 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab3JJRpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:45:08 -0400
Date: Thu, 10 Oct 2013 10:44:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010174458.GA30290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131008102505.404025673@infradead.org>
 <20131009225006.7101379c.akpm@linux-foundation.org>
 <20131010121908.GB28601@twins.programming.kicks-ass.net>
 <20131010145738.GA5167@gmail.com>
 <20131010152612.GA13375@redhat.com>
 <20131010090044.7f12ddaf.akpm@linux-foundation.org>
 <20131010165229.GC12998@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010165229.GC12998@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101017-9332-0000-0000-000001B84241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 06:52:29PM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 10 Oct 2013 17:26:12 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> > 
> > > On 10/10, Ingo Molnar wrote:
> > > >
> > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > >
> > > > > But the thing is; our sense of NR_CPUS has shifted, where it used to be
> > > > > ok to do something like:
> > > > >
> > > > >   for_each_cpu()
> > > > >
> > > > > With preemption disabled; it gets to be less and less sane to do 
> > > > > so, simply because 'common' hardware has 256+ CPUs these days. If 
> > > > > we cannot rely on preempt disable to exclude hotplug, we must use 
> > > > > get_online_cpus(), but get_online_cpus() is global state and thus 
> > > > > cannot be used at any sort of frequency.
> > > >
> > > > So ... why not make it _really_ cheap, i.e. the read lock costing 
> > > > nothing, and tie CPU hotplug to freezing all tasks in the system?
> > > >
> > > > Actual CPU hot unplugging and repluggin is _ridiculously_ rare in a 
> > > > system, I don't understand how we tolerate _any_ overhead from this 
> > > > utter slowpath.
> > > 
> > > Well, iirc Srivatsa (cc'ed) pointed out that some systems do 
> > > cpu_down/up quite often to save the power.
> > 
> > cpu hotremove already uses stop_machine, so such an approach shouldn't 
> > actually worsen things (a lot) for them?
> 
> Also, using CPU hotremove to save power, instead of implementing proper 
> power aware scheduling, is very broken to begin with.

In many cases, agreed.  Particularly on devices where there is an easy
way to send out regular updates and bug fixes, and especially if they
are connected to AC power.

But if I was in charge of creating a battery-powered multicore embedded
device that was to ship in million-unit quantities, especially in the
not-uncommon case where more than one CPU is needed only for specific
actions, I would offline the extra CPUs except when I was sure they were
needed.  This would of course still rely on power-aware scheduling when
more than one CPU was in use.  The power-aware scheduling conserves energy
for short-term variations (in which case offlining really is useless),
but longer term "keep this CPU -off-" is provided by offlining.

Yes, the Linux kernel code quality is quite good, but bugs still happen,
and bugs can easily cause CPUs to power up unnecessarily.  This doesn't
have to happen very often to kill your battery.  If the extra CPUs are
offline, a large class of those bugs are rendered harmless.  If you are
going to have a very large number of difficult-to-update battery-powered
devices in the field, defending against such bugs is worthwhile.

							Thanx, Paul

