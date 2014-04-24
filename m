Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaDXTy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:54:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42716 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751399AbaDXTy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:54:57 -0400
Date: Thu, 24 Apr 2014 15:54:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sasha Levin <sasha.levin@oracle.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: usb: mon: freeing active timer
In-Reply-To: <5359677F.6000005@oracle.com>
Message-ID: <Pine.LNX.4.44L0.1404241551260.880-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Sasha Levin wrote:

> On 04/24/2014 03:24 PM, Greg KH wrote:
> > On Thu, Apr 24, 2014 at 01:40:14PM -0400, Sasha Levin wrote:
> >> > Hi all,
> >> > 
> >> > While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> > kernel I've stumbled on the following:
> >> > 
> >> > [ 1361.390880] WARNING: CPU: 10 PID: 24274 at lib/debugobjects.c:260 debug_print_object+0x8c/0xb0()
> >> > [ 1361.391203] ODEBUG: free active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x20
> >> > [ 1361.391203] Modules linked in:
> >> > [ 1361.391203] CPU: 10 PID: 24274 Comm: trinity-c83 Not tainted 3.15.0-rc2-next-20140423-sasha-00018-gc4ff6c4 #408
> >> > [ 1361.391203]  0000000000000009 ffff8801de341c78 ffffffffb85271f2 0000000000000001
> >> > [ 1361.391203]  ffff8801de341cc8 ffff8801de341cb8 ffffffffb515afcc ffff8801eb3ebd98
> >> > [ 1361.391203]  ffff8801eb751870 ffffffffb9e76200 ffffffffb98dc502 ffffffffbc702550
> >> > [ 1361.391203] Call Trace:
> >> > [ 1361.391203] dump_stack (lib/dump_stack.c:52)
> >> > [ 1361.391203] warn_slowpath_common (kernel/panic.c:430)
> >> > [ 1361.391203] warn_slowpath_fmt (kernel/panic.c:445)
> >> > [ 1361.391203] debug_print_object (lib/debugobjects.c:262)
> >> > [ 1361.391203] ? __queue_work (kernel/workqueue.c:1452)
> >> > [ 1361.391203] __debug_check_no_obj_freed (lib/debugobjects.c:697)
> >> > [ 1361.391203] debug_check_no_obj_freed (lib/debugobjects.c:726)
> >> > [ 1361.391203] kmem_cache_free (mm/slub.c:2689 mm/slub.c:2717)
> >> > [ 1361.391203] ? kmem_cache_destroy (mm/slab_common.c:363)
> >> > [ 1361.391203] kmem_cache_destroy (mm/slab_common.c:363)
> >> > [ 1361.391203] mon_text_release (drivers/usb/mon/mon_text.c:643)
> >> > [ 1361.391203] __fput (fs/file_table.c:217)
> >> > [ 1361.391203] ____fput (fs/file_table.c:253)
> >> > [ 1361.391203] task_work_run (kernel/task_work.c:125 (discriminator 1))
> >> > [ 1361.391203] do_notify_resume (include/linux/tracehook.h:196 arch/x86/kernel/signal.c:751)
> >> > [ 1361.391203] int_signal (arch/x86/kernel/entry_64.S:807)
> > So you were running usbmon at the time?  Were you actually monitoring a
> > specific USB device/bus, or something else?
> 
> This was inside a vm with no actual physical USB devices:
> 
> # lsusb -t
> lsusb: cannot open "/var/lib/usbutils/usb.ids", No such file or directory
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ozwpan/8p, 12M
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=dummy_hcd/1p, 480M
>     |__ Port 1: Dev 2, If 0, Class=comm., Driver=cdc_eem, 480M
> 
> Since it happened while I was fuzzing, I'm not sure what exactly was getting
> monitored at that point.

This is odd because the warning message indicates the something 
containing an active timer (a delayed_work structure?) was deallocated.  
But usbmon doesn't use either timers or work queues, and as far as I 
can see, neither does anything involved in kmem_cache management.

Alan Stern

