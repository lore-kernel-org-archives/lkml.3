Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab3JGF1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 01:27:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:29368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3JGF1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 01:27:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1047,1371106800"; 
   d="scan'208";a="406371241"
Date: Mon, 7 Oct 2013 13:27:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slab.c:3060
Message-ID: <20131007052738.GA30468@localhost>
References: <20131006075811.GA22562@localhost>
 <20131006084120.GB12758@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006084120.GB12758@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 09:41:21AM +0100, Russell King - ARM Linux wrote:
> On Sun, Oct 06, 2013 at 03:58:11PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit c817a67ecba7c3c2aaa104796d78f160af60920d
> > Author: Russell King <rmk+kernel@arm.linux.org.uk>
> > Date:   Thu Jun 27 15:06:14 2013 +0100
> > 
> >     kobject: delayed kobject release: help find buggy drivers
> >     
> >     Implement debugging for kobject release functions.  kobjects are
> >     reference counted, so the drop of the last reference to them is not
> >     predictable. However, the common case is for the last reference to be
> >     the kobject's removal from a subsystem, which results in the release
> >     function being immediately called.
> >     
> >     This can hide subtle bugs, which can occur when another thread holds a
> >     reference to the kobject at the same time that a kobject is removed.
> >     This results in the release method being delayed.
> >     
> >     In order to make these kinds of problems more visible, the following
> >     patch implements a delayed release; this has the effect that the
> >     release function will be out of order with respect to the removal of
> >     the kobject in the same manner that it would be if a reference was
> >     being held.
> >     
> >     This provides us with an easy way to allow driver writers to debug
> >     their drivers and fix otherwise hidden problems.
> >     
> >     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > mount: mounting proc on /proc failed: No such device
> > grep: /proc/filesystems: No such file or directory
> > [    4.188118] BUG: sleeping function called from invalid context at mm/slab.c:3060
> > [    4.190236] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
> > [    4.191696] 1 lock held by swapper/0/0:
> > Starting Bootlog daemon: 
> > [    4.192991]  #0:  (H
> 
> Sorry, I don't believe this one.  This patch adds no new allocation.
> How does device_not_available() end up being called, or
> math_state_restore() ?

Russell, I confirmed that it's a good bisect. With the patch, 2055
out of 2140 kernel boots have some kind of error messages. After
reverting the commit, it boots 10000 times w/o a single error.

However you do have good reasons to doubt: I don't see this particular
error message "BUG: sleeping function called from invalid context at
mm/slab.c" in commit c817a67ec's bad dmesgs, which contain these error
messages instead:

$ grep_crash_head -h dmesg-* | sed 's/^[^a-zA-Z]*//' | sort | uniq -c | sort -nr

   1929 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
   1921 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
   1897 Kernel panic - not syncing: Fatal exception in interrupt
     56 WARNING: CPU: 0 PID: 1 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
     28 kernel BUG at /c/wfg/mm/mm/slab.c:3011!
     27 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     19 Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
     16 INFO: lockdep is turned off.
     13 general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     13 BUG: unable to handle kernel 
      8 BUG: sleeping function called from invalid context at /c/wfg/mm/kernel/rwsem.c:20
      6 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      6 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      6 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      5 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      5 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      5 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      5 Oops: 0002 [#1] 
      4 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      4 Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      4 BUG: unable to handle kernel NULL pointer dereference
      3 Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      2 WARNING: CPU: 1 PID: 1 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      2 BUG: unable to handle kernel paging request at ffffffffffffffa8
      2 BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
      2 BUG: unable to handle kernel NULL pointer dereference at 0000000000000017
      2 BUG: scheduling while atomic: rc.local/135/0x10000002
      1 invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      1 general protection fault: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      1 general protection fault: 0000 [#1] PREEMPT 
      1 general protection fault: 0000 [#1] P/RbEinE/sMh:P /Tpr oc/sSMP DEBUG_PAGEALLOC
      1 WARNING: CPU: 1 PID: 222 at /c/wfg/mm/include/linux/kref.h:47 kobject_get+0x37/0x44()
      1 WARNING: CPU: 1 PID: 139 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 133 at /c/wfg/mm/kernel/lockdep.c:708 look_up_lock_class+0xa0/0xb7()
      1 WARNING: CPU: 1 PID: 130 at /c/wfg/mm/kernel/lockdep.c:708 look_up_lock_class+0xa0/0xb7()
      1 WARNING: CPU: 1 PID: 129 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 129 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 129 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 119 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 22 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 22 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 22 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 209 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 20 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 20 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 20 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 135 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 133 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 132 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 126 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 122 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 116 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 1 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 1 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 1 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      1 Oops: 0t0rinity: not fo02 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] PREEMStParting BootlogT  daemon: SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] PREEMPT grep: /procS/fileMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] PREEMPT bootlogd: cannot allocate pseudo tty: No such file or directory
      1 Oops: 0002 [#1] CoPnfRigEurEinMg PneTtw SMP orDk EinBteUrfGac_esP..AGEALLOC
      1 Oops: 0002 [#1] /PREEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
      1 Kernel panic - not syncing: Attempted to kill the idle task!
      1 K er ne1l .t892024] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      1 BUG: unable to handle kernel paging request at 00000000fffedf1c
      1 BUG: unable to handle kernel paging request at 0000000000010012
      1 BUG: unable to handle kernel done.paging request at ffffffffffffffa8
      1 BUG: unable to handle kernel PleaNse waitU: boLLo pointer dereference at 0000000000000008
      1 BUG: unable to handle kernel NULmount: mLou ntingp oinproc otn /proce rfa dereilefde: Nro sencuch deevice at 000000
      1 BUG: unable to handle kernel NULLKe rnpelo itesntst: Beoot OK!
      1 BUG: unable to handle kernel NULL pointer dererence at 0000000000000008
      1 BUG: unable to handle kernel NULL pointer dereferenceg reap:t / pr0oc0/c0md0l000000000008
      1 BUG: unable to handle kernel NULL pointer dereference at mo0un0t:0 n0o 0/p0ro0c/000mo0un0ts0
      1 BUG: unable to handle kernel NULL pointer dereference at 00000000000008d8
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
      1 BUG: unable to handle kernel NULL pointer dereference at           (null)
      1 BUG: unable to handle kernel /bin/sh: /proc/self/fd/9: No such file or directory
      1 BUG: unable to handle kernel /bin/sh: /proc/sNULL pointer dereference at 0000000000000008
      1 BUG: scheduling while atomic: sh/131/0x00000003
      1 BUG: scheduling while atomic: reboot/222/0x10000002
      1 BUG: scheduling while atomic: reboot/211/0x10000002
      1 BUG: scheduling while atomic: reboot/135/0x10000002
      1 BUG: scheduling while atomic: ifconfig/231/0x10000002
      1 BUG: scheduling while atomic: S99-rc.local/211/0x10000002
      1 BUG: Bad rss-counter state mm:ffff88000ca47340 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000ca0ed00 idx:1 val:2

Thanks,
Fengguang
