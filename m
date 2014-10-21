Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaJUQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 12:04:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668AbaJUQEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 12:04:55 -0400
Date: Tue, 21 Oct 2014 18:04:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
In-Reply-To: <20141021160029.GH4977@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1410211802500.24255@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz> <20141021151043.GA11800@redhat.com> <alpine.LNX.2.00.1410211717210.24255@pobox.suse.cz> <20141021160029.GH4977@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Paul E. McKenney wrote:

> > Looks like this indeed is something that lockdep *should* report (*), 
> > although I would be suprised that stack unwinder would be so confused 
> > by this -- there is no way for synchronize_sched_expedited() to be 
> > inlined all the way to cpuidle_pause().
> 
> I think that if synchronize_sched_expedited() was in fact called, it
> had already returned by the time we hit this problem.  But I must confess
> that I am not seeing how cpuidle_uninstall_idle_handler() gets to
> synchronize_rcu().

Umm, it directly calls it? :-)

	void cpuidle_uninstall_idle_handler(void)
	{
		if (enabled_devices) {
			initialized = 0;
			wake_up_all_idle_cpus();
		}

		/*
		 * Make sure external observers (such as the scheduler)
		 * are done looking at pointed idle states.
		 */
		synchronize_rcu();
	}


> > (*) there are multiple places where cpu_hotplug.lock -> cpuidle_lock lock 
> >     dependency is assumed. The patch that Dave pointed out adds 
> >     cpuidle_lock -> cpu_hotplug.lock dependency.
> > 
> > Still not clear whether this is what's happening here ... anyway, adding 
> > Paul to CC.
> 
> Hmmm...
> 
> Both cpuidle_pause() and cpuidle_pause_and_lock() acquire cpuidle_lock,
> and are at the top of both stacks.  Which was the original confusion.  ;-)

Yup, they are, but lockdep is complaining about cpuidle_pause() acquiring 
cpu_hotplug.lock ...

Thanks,

-- 
Jiri Kosina
SUSE Labs
