Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaJUQXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:23:39 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52871 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbaJUQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:23:38 -0400
Date: Tue, 21 Oct 2014 09:23:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
Message-ID: <20141021162330.GJ4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz>
 <20141021151043.GA11800@redhat.com>
 <alpine.LNX.2.00.1410211717210.24255@pobox.suse.cz>
 <20141021160029.GH4977@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1410211802500.24255@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1410211802500.24255@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102116-0025-0000-0000-000005837C93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:04:52PM +0200, Jiri Kosina wrote:
> On Tue, 21 Oct 2014, Paul E. McKenney wrote:
> 
> > > Looks like this indeed is something that lockdep *should* report (*), 
> > > although I would be suprised that stack unwinder would be so confused 
> > > by this -- there is no way for synchronize_sched_expedited() to be 
> > > inlined all the way to cpuidle_pause().
> > 
> > I think that if synchronize_sched_expedited() was in fact called, it
> > had already returned by the time we hit this problem.  But I must confess
> > that I am not seeing how cpuidle_uninstall_idle_handler() gets to
> > synchronize_rcu().
> 
> Umm, it directly calls it? :-)
> 
> 	void cpuidle_uninstall_idle_handler(void)
> 	{
> 		if (enabled_devices) {
> 			initialized = 0;
> 			wake_up_all_idle_cpus();
> 		}
> 
> 		/*
> 		 * Make sure external observers (such as the scheduler)
> 		 * are done looking at pointed idle states.
> 		 */
> 		synchronize_rcu();
> 	}

Ah, it would help if I did "git checkout linus/master" after updating,
wouldn't it now?

> > > (*) there are multiple places where cpu_hotplug.lock -> cpuidle_lock lock 
> > >     dependency is assumed. The patch that Dave pointed out adds 
> > >     cpuidle_lock -> cpu_hotplug.lock dependency.
> > > 
> > > Still not clear whether this is what's happening here ... anyway, adding 
> > > Paul to CC.
> > 
> > Hmmm...
> > 
> > Both cpuidle_pause() and cpuidle_pause_and_lock() acquire cpuidle_lock,
> > and are at the top of both stacks.  Which was the original confusion.  ;-)
> 
> Yup, they are, but lockdep is complaining about cpuidle_pause() acquiring 
> cpu_hotplug.lock ...

If it was attempting to acquire it via synchronize_sched_expedited(),
the attempt would fail and synchronize_sched_expedited() would fall
back to synchronize_sched()'s normal grace-period mechanism.  (Not to
synchronize_sched() itself, of course, as that would be infinite
recursion.)

So I believe that something else is going on here.

							Thanx, Paul

