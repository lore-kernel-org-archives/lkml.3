Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbaDHMzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:55:37 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:49629 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaDHMzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:55:35 -0400
Date: Tue, 8 Apr 2014 08:55:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>, Greg KH <greg@kroah.com>,
        rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rtc: hang on boot during unregistration
Message-ID: <20140408125531.GB21329@htj.dyndns.org>
References: <533F77F2.1050107@oracle.com>
 <20140407123328.1481dc51543235ce53e65254@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140407123328.1481dc51543235ce53e65254@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 07, 2014 at 12:33:28PM -0700, Andrew Morton wrote:
> > [   16.625261] kworker/0:1/1069 is trying to acquire lock:
> > [   16.626300] ((&(&kobj->release)->work)){+.+.+.}, at: flush_work (kernel/workqueue.c:2880)
> > [   16.628258]
> > [   16.628258] but task is already holding lock:
> > [   16.629415] ((&(&kobj->release)->work)){+.+.+.}, at: process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
> 
> This is making my head spin a bit.  Why is lockdep babbling about
> include/linux/workqueue.h:186 and similar sites which appear to have
> nothing to do with locking?  Later it points a finger at
> include/linux/jump_label.h:105, wtf.

flush_work() and flush_workqueue() make use of lockdep anntations so
that dependency problems involving them can be detected through
lockdep.

> > [   16.630106] other info that might help us debug this:
> > [   16.630106]  Possible unsafe locking scenario:
> > [   16.630106]
> > [   16.630106]        CPU0
> > [   16.630106]        ----
> > [   16.630106]   lock((&(&kobj->release)->work));
> > [   16.630106]   lock((&(&kobj->release)->work));

Looks like a work item is trying to flush itself.

> > [   16.630106] Call Trace:
> > [   16.630106] dump_stack (lib/dump_stack.c:52)
> > [   16.630106] __lock_acquire (kernel/locking/lockdep.c:1740 kernel/locking/lockdep.c:1783 kernel/locking/lockdep.c:2115 kernel/locking/lockdep.c:3182)
> > [   16.630106] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> > [   16.630106] flush_work (kernel/workqueue.c:2884)
> > [   16.630106] __cancel_work_timer (arch/x86/include/asm/bitops.h:313 kernel/workqueue.c:610 kernel/workqueue.c:644 kernel/workqueue.c:2916)
> > [   16.630106] cancel_work_sync (kernel/workqueue.c:2941)
> > [   16.630106] work_fixup_free (kernel/workqueue.c:479)

Hah, this is debugobj fixup code trying to perform cancel_work_sync()
to make the object unused because it's being freed while active;
however, because free() is being called from the work item itself,
it's falling into deadlock and triggering the lockdep anntation.

> > [   16.630106] __debug_check_no_obj_freed (lib/debugobjects.c:277 lib/debugobjects.c:700)
> > [   16.630106] debug_check_no_obj_freed (lib/debugobjects.c:726)
> > [   16.630106] kfree (mm/slub.c:2679 mm/slub.c:3401)
> > [   16.630106] rtc_device_release (drivers/rtc/class.c:35)

IOW, rtc_device_release() is freeing the memory area this work item is
embedded in while the work item is queued on a workqueue.

> > [   16.630106] device_release (drivers/base/core.c:246)
> > [   16.630106] kobject_delayed_cleanup (lib/kobject.c:629 lib/kobject.c:638)
> > [   16.630106] process_one_work (kernel/workqueue.c:2221 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2226)
> > [   16.630106] worker_thread (kernel/workqueue.c:2348)
> > [   16.630106] kthread (kernel/kthread.c:219)
> > [   16.630106] ret_from_fork (arch/x86/kernel/entry_64.S:555)
> 
> I think rtc's role in this is to trigger case ODEBUG_STATE_ACTIVE in
> __debug_check_no_obj_freed(), which might be due to an RTC bug.  This
> then triggers problems in the workqueue core - calling flush_work() and
> cancel_work_sync() within work_fixup_free() seems, umm, optimistic.

It's debugobj fixup code which is opportunistically trying to take the
work item off workqueue to avoid use-after-free.  As free() is being
called from work item itself, it falls into A-A deadlock.

> Maybe the semi-recursive code is OK and we're just missing lockdep
> annotations, and the hang you saw was for other reasons.

I've been always a bit suspicious about the fixup parts of debugobj.
I suppose they aren't too harmful as these types of chained failures
always follow proper error messages from debugobj itself.  Anyways,
the lockdep annotation is only because debugobj fixup isn't too smart.
I'm not quite sure we wanna try harder tho.

Thanks.

-- 
tejun
