Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbbATOfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:35:33 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39153 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbbATOfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:35:32 -0500
Date: Tue, 20 Jan 2015 14:35:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Vince Weaver <vince@deater.net>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: perf fuzzer crash [PATCH] perf: Get group events reference
 before moving the group
Message-ID: <20150120143508.GE15924@leverpostej>
References: <20150116075746.GB2658@krava.brq.redhat.com>
 <20150116104644.GW23965@worktop.programming.kicks-ass.net>
 <20150116141104.GD21958@worktop.programming.kicks-ass.net>
 <20150119144028.GF21553@leverpostej>
 <20150119174009.GI21553@leverpostej>
 <20150120133947.GD15924@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120133947.GD15924@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 01:39:47PM +0000, Mark Rutland wrote:
> On Mon, Jan 19, 2015 at 05:40:09PM +0000, Mark Rutland wrote:
> > On Mon, Jan 19, 2015 at 02:40:28PM +0000, Mark Rutland wrote:
> > > On Fri, Jan 16, 2015 at 02:11:04PM +0000, Peter Zijlstra wrote:
> > > > On Fri, Jan 16, 2015 at 11:46:44AM +0100, Peter Zijlstra wrote:
> > > > > Its a bandaid at best :/ The problem is (again) that we changes
> > > > > event->ctx without any kind of serialization.
> > > > >
> > > > > The issue came up before:
> > > > >
> > > > >   https://lkml.org/lkml/2014/9/5/397
> > > 
> > > In the end neither the CCI or CCN perf drivers migrate events on
> > > hotplug, so ARM is currently safe from the perf_pmu_migrate_context
> > > case, but I see that you fix the move_group handling too.
> > > 
> > > I had a go at testing this by hacking migration back into the CCI PMU
> > > driver (atop of v3.19-rc5), but I'm seeing lockups after a few minutes
> > > with my original test case (https://lkml.org/lkml/2014/9/1/569 with
> > > PMU_TYPE and PMU_EVENT fixed up).
> > > 
> > > I unfortunately don't have a suitable x86 box spare to run that on.
> > > Would someone be able to give it a spin on something with an uncore PMU?
> > > 
> > > I'll go and dig a bit further. I may just be hitting another latent
> > > issue on my board.
> > 
> > I'm able to trigger the lockups even without both your patch and the
> > call to perf_pmu_migrate_context, so there is a latent issue.
> > 
> > On vanilla v3.19-rc5 and vanilla v3.18, I'm able to get my hotplug
> > script hung when run concurrently with the test case against the CCI PMU
> > driver (without migration). The v3.18 and v3.19-rc5 lockups are
> > identical:
> > 
> > INFO: task hpall.sh:1506 blocked for more than 120 seconds.
> >       Not tainted 3.19.0-rc5 #9
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > hpall.sh        D 804a6ffc     0  1506   1497 0x00000000
> > [<804a6ffc>] (__schedule) from [<80022308>] (cpu_hotplug_begin+0xa0/0xac)
> > [<80022308>] (cpu_hotplug_begin) from [<8002236c>] (_cpu_up+0x24/0x180)
> > [<8002236c>] (_cpu_up) from [<8002253c>] (cpu_up+0x74/0x98)
> > [<8002253c>] (cpu_up) from [<802bce60>] (device_online+0x64/0x90)
> > [<802bce60>] (device_online) from [<802bcef4>] (online_store+0x68/0x74)
> > [<802bcef4>] (online_store) from [<8014059c>] (kernfs_fop_write+0xbc/0x1a0)
> > [<8014059c>] (kernfs_fop_write) from [<800e71b0>] (vfs_write+0xa0/0x1ac)
> > [<800e71b0>] (vfs_write) from [<800e7808>] (SyS_write+0x44/0x9c)
> > [<800e7808>] (SyS_write) from [<8000e560>] (ret_fast_syscall+0x0/0x48)
> > 7 locks held by hpall.sh/1506:
> >  #0:  (sb_writers#6){.+.+.+}, at: [<800e729c>] vfs_write+0x18c/0x1ac
> >  #1:  (&of->mutex){+.+.+.}, at: [<8014052c>] kernfs_fop_write+0x4c/0x1a0
> >  #2:  (s_active#15){.+.+.+}, at: [<80140534>] kernfs_fop_write+0x54/0x1a0
> >  #3:  (device_hotplug_lock){+.+.+.}, at: [<802bbe44>] lock_device_hotplug_sysfs+0xc/0x4c
> >  #4:  (&dev->mutex){......}, at: [<802bce14>] device_online+0x18/0x90
> >  #5:  (cpu_add_remove_lock){+.+.+.}, at: [<80022508>] cpu_up+0x40/0x98
> >  #6:  (cpu_hotplug.lock){++++++}, at: [<80022268>] cpu_hotplug_begin+0x0/0xac
> > 
> > I guess that lockup is my fundamental issue, and with your patch the
> > perf_rwsem manages to spread a transitive dependency on one of those
> > locks all over the perf subsystem. I haven't considered that in great
> > detail, however.
> 
> I found that I couldn't trigger the issue with v3.17, and I was able to
> bisect down to commit b2c4623dcd07af4b ("rcu: More on deadlock between
> CPU hotplug and expedited grace periods").
> 
> I'm currently stressing b2c4623dcd07af4b~1 to make sure my bisect hasn't
> mislead me.

That seems to be solid, and I think I see what's going on.

The task doing hotplug (hpall.sh:1506) gets to cpu_hotplug_begin(), and
sets cpu_hotplug.active_writer to current (I assume writes to this are
protected by cpu_add_remove_lock from cpu_up()?). Then it loops, acquiring
cpu_hotplug.lock and testing the refcount, and if non-zero dropping the
lock and going into uninterruptible sleep, expecting to be woken by
put_online_cpus().

Concurrently a task holding the refcount non-zero calls
put_online_cpus(), and finds there to be contention on cpu_hotplug.lock.
Thus it increments cpu_hotplug.puts_pending and goes of on its merry
way, without trying to wake the writer.

So the writer is never woken and never gets to handle the non-zero
cpu_hotplug.puts_pending.

I'm not sure what the right fix for that is. It looks like the writer
could observe the change to puts_pending and so
cpu_hotplug.active_writer could change under our feet unless we hold
cpu_hotplug.lock. But holding that would reintroduce the deadlock
b2c4623dcd07af4b was trying to avoid.

Any ideas?

Mark.
