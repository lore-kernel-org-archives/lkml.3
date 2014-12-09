Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaLIJO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:14:59 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38952 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbaLIJOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:14:54 -0500
Date: Tue, 9 Dec 2014 10:14:47 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org, oleg@redhat.com,
        bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v2] CPU hotplug: active_writer not woken up in some cases
 - deadlock
Message-ID: <20141209091447.GD4362@osiris>
References: <1418070082-13512-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141208212236.GU25340@linux.vnet.ibm.com>
 <20141209085930.6b831850@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209085930.6b831850@thinkpad-w530>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120909-0017-0000-0000-000002232F66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 08:59:30AM +0100, David Hildenbrand wrote:
> > The compiler is within its rights to optimize the active_writer local
> > variable out of existence, thus re-introducing the possible race with
> > the writer that can pass a NULL pointer to wake_up_process().  So you
> > really need the ACCESS_ONCE() on the read from cpu_hotplug.active_writer.
> > Please see http://lwn.net/Articles/508991/ for more information why
> > this is absolutely required.
> 
> You're absolutely right, saw your reply on the other patch just after I sent
> this version ...
> 
> So if you agree with the change below, I'll send an updated version!
> 
> > 
> > > +		if (unlikely(active_writer))
> > > +			wake_up_process(active_writer);
> > >  		cpuhp_lock_release();
> > >  		return;
> > >  	}
> > > @@ -161,15 +167,17 @@ void cpu_hotplug_begin(void)
> > >  	cpuhp_lock_acquire();
> > >  	for (;;) {
> > >  		mutex_lock(&cpu_hotplug.lock);
> > > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> > 
> > You lost me on this one.  How does this help?
> > 
> > 							Thanx, Paul
> 
> Imagine e.g. the following (simplified) scenario:
> 
> CPU1                               CPU2
> ----------------------------------------------------------------------------
> !mutex_trylock(&cpu_hotplug.lock) |
>                                   | cpu_hotplug.puts_pending == 0
> cpu_hotplug.puts_pending++;       |
>                                   | cpu_hotplug.refcount != 0
> wake_up_process(active_writer)
>                                   | __set_current_state(TASK_UNINTERRUPTIBLE);
>                                   | schedule();
>                                   | /* will never be woken up */
> 
> Therefore we have to move the condition check inside the 
>   __set_current_state(TASK_UNINTERRUPTIBLE) -> schedule();
> section to not miss any wake ups when the condition is satisfied.
> 
> So wake_up_process() will either see TASK_RUNNING and do nothing or see
> TASK_UNINTERRUPTIBLE and set it to TASK_RUNNING, so schedule() will in
> fact be woken up again.

Or the third alternative would be that 'active_writer' which was running
on CPU2 already terminated and wake_up_process() has a non-NULL pointer to
task_struct which is already dead.
Or is there anything that prevents this use-after-free race?

