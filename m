Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbaLIQYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:24:39 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:60974 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbaLIQYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:24:37 -0500
Date: Tue, 9 Dec 2014 17:24:27 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, oleg@redhat.com, bp@suse.de, jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141209172427.4bde12a7@thinkpad-w530>
In-Reply-To: <20141209141903.GB25340@linux.vnet.ibm.com>
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141209141903.GB25340@linux.vnet.ibm.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120916-0021-0000-0000-00000212DE1A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Dec 09, 2014 at 01:23:31PM +0100, David Hildenbrand wrote:
> > Commit b2c4623dcd07 ("rcu: More on deadlock between CPU hotplug and expedited
> > grace periods") introduced another problem that can easily be reproduced by
> > starting/stopping cpus in a loop.
> > 
> > E.g.:
> >   for i in `seq 5000`; do
> >       echo 1 > /sys/devices/system/cpu/cpu1/online
> >       echo 0 > /sys/devices/system/cpu/cpu1/online
> >   done
> > 
> > Will result in:
> >   INFO: task /cpu_start_stop:1 blocked for more than 120 seconds.
> >   Call Trace:
> >   ([<00000000006a028e>] __schedule+0x406/0x91c)
> >    [<0000000000130f60>] cpu_hotplug_begin+0xd0/0xd4
> >    [<0000000000130ff6>] _cpu_up+0x3e/0x1c4
> >    [<0000000000131232>] cpu_up+0xb6/0xd4
> >    [<00000000004a5720>] device_online+0x80/0xc0
> >    [<00000000004a57f0>] online_store+0x90/0xb0
> >   ...
> > 
> > And a deadlock.
> > 
> > Problem is that if the last ref in put_online_cpus() can't get the
> > cpu_hotplug.lock the puts_pending count is incremented, but a sleeping
> > active_writer might never be woken up, therefore never exiting the loop in
> > cpu_hotplug_begin().
> > 
> > This fix wakes up the active_writer proactively. The writer already goes back to
> > sleep if the ref count isn't already down to 0, so this should be fine.
> > 
> > In order to avoid many potential races, we have to:
> > - Protect current_writer by a spin lock. When holding this lock we can be sure
> >   that the writer won't vainsh or change. (use-after-free)
> > - Increment the cpu_hotplug.puts_pending count before we test for an
> >   active_writer. (otherwise a wakeup might get lost)
> > - Move setting of TASK_UNINTERRUPTIBLE in cpu_hotplug_begin() above the
> >   condition check. (otherwise a wakeup might get lost)
> > 
> > Can't reproduce it with this fix.
> 
> Would wait_event()/wake_up() work for the wakeup-writer case?
> 
> 							Thanx, Paul
> 

Thanks! Was also thinking about wait queues. Will investigate if that can help
to beautify this :)

David

