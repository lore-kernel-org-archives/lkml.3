Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaLIH7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 02:59:39 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:43389 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaLIH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:59:38 -0500
Date: Tue, 9 Dec 2014 08:59:30 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v2] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141209085930.6b831850@thinkpad-w530>
In-Reply-To: <20141208212236.GU25340@linux.vnet.ibm.com>
References: <1418070082-13512-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141208212236.GU25340@linux.vnet.ibm.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120907-0021-0000-0000-0000021096AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The compiler is within its rights to optimize the active_writer local
> variable out of existence, thus re-introducing the possible race with
> the writer that can pass a NULL pointer to wake_up_process().  So you
> really need the ACCESS_ONCE() on the read from cpu_hotplug.active_writer.
> Please see http://lwn.net/Articles/508991/ for more information why
> this is absolutely required.

You're absolutely right, saw your reply on the other patch just after I sent
this version ...

So if you agree with the change below, I'll send an updated version!

> 
> > +		if (unlikely(active_writer))
> > +			wake_up_process(active_writer);
> >  		cpuhp_lock_release();
> >  		return;
> >  	}
> > @@ -161,15 +167,17 @@ void cpu_hotplug_begin(void)
> >  	cpuhp_lock_acquire();
> >  	for (;;) {
> >  		mutex_lock(&cpu_hotplug.lock);
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> 
> You lost me on this one.  How does this help?
> 
> 							Thanx, Paul

Imagine e.g. the following (simplified) scenario:

CPU1                               CPU2
----------------------------------------------------------------------------
!mutex_trylock(&cpu_hotplug.lock) |
                                  | cpu_hotplug.puts_pending == 0
cpu_hotplug.puts_pending++;       |
                                  | cpu_hotplug.refcount != 0
wake_up_process(active_writer)
                                  | __set_current_state(TASK_UNINTERRUPTIBLE);
                                  | schedule();
                                  | /* will never be woken up */

Therefore we have to move the condition check inside the 
  __set_current_state(TASK_UNINTERRUPTIBLE) -> schedule();
section to not miss any wake ups when the condition is satisfied.

So wake_up_process() will either see TASK_RUNNING and do nothing or see
TASK_UNINTERRUPTIBLE and set it to TASK_RUNNING, so schedule() will in
fact be woken up again.


Thanks a lot!

David

