Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaJUQAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:00:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48765 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbaJUQAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:00:40 -0400
Date: Tue, 21 Oct 2014 09:00:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141021160029.GH4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <20141021151043.GA11800@redhat.com>
 <alpine.LNX.2.00.1410211717210.24255@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410211717210.24255@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102116-0017-0000-0000-000005BB66B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:21:21PM +0200, Jiri Kosina wrote:
> On Tue, 21 Oct 2014, Dave Jones wrote:
> 
> >  > I am seeing the lockdep report below when resuming from suspend-to-disk 
> >  > with current Linus' tree (c2661b80609).
> >  > 
> >  > The reason for CCing Ingo and Peter is that I can't make any sense of one 
> >  > of the stacktraces lockdep is providing.
> >  > 
> >  > Please have a look at the very first stacktrace in the dump, where lockdep 
> >  > is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems 
> >  > to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not 
> >  > the case at all.
> > 
> > Could inlining be confusing the trace here ?
> > 
> > You can get from cpuidle_pause to cpuidle_uninstall_idle_handler -> synchronize_rcu
> >  -> synchronize_sched -> synchronize_sched_expedited which
> > does a try_get_online_cpus which will take the cpu_hotplug.lock
> 
> Looks like this indeed is something that lockdep *should* report (*), 
> although I would be suprised that stack unwinder would be so confused by 
> this -- there is no way for synchronize_sched_expedited() to be inlined 
> all the way to cpuidle_pause().

I think that if synchronize_sched_expedited() was in fact called, it
had already returned by the time we hit this problem.  But I must confess
that I am not seeing how cpuidle_uninstall_idle_handler() gets to
synchronize_rcu().

> (*) there are multiple places where cpu_hotplug.lock -> cpuidle_lock lock 
>     dependency is assumed. The patch that Dave pointed out adds 
>     cpuidle_lock -> cpu_hotplug.lock dependency.
> 
> Still not clear whether this is what's happening here ... anyway, adding 
> Paul to CC.

Hmmm...

Both cpuidle_pause() and cpuidle_pause_and_lock() acquire cpuidle_lock,
and are at the top of both stacks.  Which was the original confusion.  ;-)

							Thanx, Paul

