Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbaLILgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:36:15 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:33107 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbaLILgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:36:13 -0500
Date: Tue, 9 Dec 2014 12:35:56 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        rafael.j.wysocki@intel.com, peterz@infradead.org, oleg@redhat.com,
        bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v2] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141209123556.02cc99c0@thinkpad-w530>
In-Reply-To: <20141209102108.GE4362@osiris>
References: <1418070082-13512-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141208212236.GU25340@linux.vnet.ibm.com>
	<20141209085930.6b831850@thinkpad-w530>
	<20141209091447.GD4362@osiris>
	<20141209111101.201e3544@thinkpad-w530>
	<20141209102108.GE4362@osiris>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120911-0005-0000-0000-00000263398A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 09, 2014 at 11:11:01AM +0100, David Hildenbrand wrote:
> > > > Therefore we have to move the condition check inside the 
> > > >   __set_current_state(TASK_UNINTERRUPTIBLE) -> schedule();
> > > > section to not miss any wake ups when the condition is satisfied.
> > > > 
> > > > So wake_up_process() will either see TASK_RUNNING and do nothing or see
> > > > TASK_UNINTERRUPTIBLE and set it to TASK_RUNNING, so schedule() will in
> > > > fact be woken up again.
> > > 
> > > Or the third alternative would be that 'active_writer' which was running
> > > on CPU2 already terminated and wake_up_process() has a non-NULL pointer to
> > > task_struct which is already dead.
> > > Or is there anything that prevents this use-after-free race?
> > 
> > Hmmm ... I think that is also a valid scenario.
> > That would mean we need soemthing like this:
> > 
> >  void put_online_cpus(void)
> >  {
> > + struct task_struct *awr;
> > +
> >         if (cpu_hotplug.active_writer == current)
> >                 return;
> >         if (!mutex_trylock(&cpu_hotplug.lock)) {
> > +         awr = ACCESS_ONCE(cpu_hotplug.active_writer);
> > +         if (unlikely(awr))
> > +                 get_task_struct(awr);
> 
> How would this solve the problem?

Although this might fix the problem you addressed, it exposes another one:

CPU1                               CPU2
----------------------------------------------------------------------------
!mutex_trylock(&cpu_hotplug.lock) |
cpu_hotplug.active_writer == 0    |
awr = 0;                          |
                                  | cpu_hotplug.active_writer = current
                                  | __set_current_state(TASK_UNINTERRUPTIBLE);
                                  | cpu_hotplug.puts_pending == 0
cpu_hotplug.puts_pending++;       | ...
                                  | schedule();
/* no wakeup as awr == 0 */

So we really need to cpu_hotplug.puts_pending++; before checking for
cpu_hotplug.active_writer. That in turn can lead to the active_writer struct vanishing.

So we can't get around a lock for cpu_hotplug.active_writer IMHO. Or we have to
revert the original patch - but that one addressed an rcu problem.

Opinions?

David

