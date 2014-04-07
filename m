Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbaDGTdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 15:33:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaDGTda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 15:33:30 -0400
Date: Mon, 7 Apr 2014 12:33:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rtc: hang on boot during unregistration
Message-Id: <20140407123328.1481dc51543235ce53e65254@linux-foundation.org>
In-Reply-To: <533F77F2.1050107@oracle.com>
References: <533F77F2.1050107@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2014 23:26:42 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Hi all,
> 
> I got the following spew while booting. My VM proceeded to hang and die.
> 
> [   16.620530] =============================================
> [   16.621059] [ INFO: possible recursive locking detected ]
> [   16.622024] 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376 Not tainted
> [   16.624145] ---------------------------------------------
> [   16.625261] kworker/0:1/1069 is trying to acquire lock:
> [   16.626300] ((&(&kobj->release)->work)){+.+.+.}, at: flush_work (kernel/workqueue.c:2880)
> [   16.628258]
> [   16.628258] but task is already holding lock:
> [   16.629415] ((&(&kobj->release)->work)){+.+.+.}, at: process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)

This is making my head spin a bit.  Why is lockdep babbling about
include/linux/workqueue.h:186 and similar sites which appear to have
nothing to do with locking?  Later it points a finger at
include/linux/jump_label.h:105, wtf.

> [   16.630106] other info that might help us debug this:
> [   16.630106]  Possible unsafe locking scenario:
> [   16.630106]
> [   16.630106]        CPU0
> [   16.630106]        ----
> [   16.630106]   lock((&(&kobj->release)->work));
> [   16.630106]   lock((&(&kobj->release)->work));
> [   16.630106]
> [   16.630106]  *** DEADLOCK ***
> [   16.630106]
> [   16.630106]  May be due to missing lock nesting notation
> [   16.630106]
> [   16.630106] 2 locks held by kworker/0:1/1069:
> [   16.630106] #0: ("events"){.+.+.+}, at: process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
> [   16.630106] #1: ((&(&kobj->release)->work)){+.+.+.}, at: process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
> [   16.630106]
> [   16.630106] stack backtrace:
> [   16.630106] CPU: 0 PID: 1069 Comm: kworker/0:1 Not tainted 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376
> [   16.630106] Workqueue: events kobject_delayed_cleanup
> [   16.630106]  ffffffffb59d09d0 ffff88007c6a58d8 ffffffffb24bfb2f 0000000000000000
> [   16.630106]  ffffffffb59d09d0 ffff88007c6a59d8 ffffffffaf1c4c8a ffff88007c5a3d98
> [   16.630106]  ffff88007c5a3000 ffff880000000001 ffffffffaf1c0e18 ffff88007c5a3d60
> [   16.630106] Call Trace:
> [   16.630106] dump_stack (lib/dump_stack.c:52)
> [   16.630106] __lock_acquire (kernel/locking/lockdep.c:1740 kernel/locking/lockdep.c:1783 kernel/locking/lockdep.c:2115 kernel/locking/lockdep.c:3182)
> [   16.630106] ? check_irq_usage (kernel/locking/lockdep.c:1638)
> [   16.630106] ? __lock_acquire (kernel/locking/lockdep.c:3189)
> [   16.630106] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
> [   16.630106] ? flush_work (kernel/workqueue.c:2880)
> [   16.630106] flush_work (kernel/workqueue.c:2884)
> [   16.630106] ? flush_work (kernel/workqueue.c:2880)
> [   16.630106] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [   16.630106] ? put_lock_stats.isra.12 (arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [   16.630106] ? try_to_grab_pending (kernel/workqueue.c:1260 kernel/workqueue.c:1259)
> [   16.630106] ? __cancel_work_timer (arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/workqueue.c:2913 (discriminator 2))
> [   16.630106] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [   16.630106] __cancel_work_timer (arch/x86/include/asm/bitops.h:313 kernel/workqueue.c:610 kernel/workqueue.c:644 kernel/workqueue.c:2916)
> [   16.630106] cancel_work_sync (kernel/workqueue.c:2941)
> [   16.630106] work_fixup_free (kernel/workqueue.c:479)
> [   16.630106] __debug_check_no_obj_freed (lib/debugobjects.c:277 lib/debugobjects.c:700)
> [   16.630106] debug_check_no_obj_freed (lib/debugobjects.c:726)
> [   16.630106] kfree (mm/slub.c:2679 mm/slub.c:3401)
> [   16.630106] ? rtc_device_release (drivers/rtc/class.c:35)
> [   16.630106] rtc_device_release (drivers/rtc/class.c:35)
> [   16.630106] device_release (drivers/base/core.c:246)
> [   16.630106] kobject_delayed_cleanup (lib/kobject.c:629 lib/kobject.c:638)
> [   16.630106] process_one_work (kernel/workqueue.c:2221 include/linux/jump_label.h:105 include/trace/events/workqueue.h:111 kernel/workqueue.c:2226)
> [   16.630106] ? process_one_work (include/linux/workqueue.h:186 kernel/workqueue.c:611 kernel/workqueue.c:638 kernel/workqueue.c:2214)
> [   16.630106] worker_thread (kernel/workqueue.c:2348)
> [   16.630106] ? rescuer_thread (kernel/workqueue.c:2297)
> [   16.630106] kthread (kernel/kthread.c:219)
> [   16.630106] ? kthread_create_on_node (kernel/kthread.c:185)
> [   16.630106] ret_from_fork (arch/x86/kernel/entry_64.S:555)
> [   16.630106] ? kthread_create_on_node (kernel/kthread.c:185)

I think rtc's role in this is to trigger case ODEBUG_STATE_ACTIVE in
__debug_check_no_obj_freed(), which might be due to an RTC bug.  This
then triggers problems in the workqueue core - calling flush_work() and
cancel_work_sync() within work_fixup_free() seems, umm, optimistic.

Maybe the semi-recursive code is OK and we're just missing lockdep
annotations, and the hang you saw was for other reasons.

Tejunstuff ;)
