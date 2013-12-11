Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3LKJWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:22:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:56157 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3LKJV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:21:56 -0500
Date: Wed, 11 Dec 2013 10:21:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <gregkh@linuxfoundation.org>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de
Subject: Re: [PATCH v2] debugobject: add support for kref
In-Reply-To: <20131211064538.GA20293@kroah.com>
Message-ID: <alpine.DEB.2.02.1312111021090.28330@ionos.tec.linutronix.de>
References: <1382609345-29370-1-git-send-email-bigeasy@linutronix.de> <alpine.DEB.2.02.1310241615280.14242@ionos.tec.linutronix.de> <20131103193308.GA20998@linutronix.de> <20131211064538.GA20293@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1702520893-1386753711=:28330"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1702520893-1386753711=:28330
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 10 Dec 2013, Greg KH wrote:
> On Sun, Nov 03, 2013 at 08:33:08PM +0100, Sebastian Andrzej Siewior wrote:
> > I run a couple times into the case where "put" was called on an already
> > cleanup object. The results was either nothing because "0" went back to
> > 0xff…ff and release was not called a second time or some thing like this
> > with SLAB once that memory region was used again:
> > 
> > |edma-dma-engine edma-dma-engine.0: freeing channel for 57
> > |Slab corruption (Not tainted): kmalloc-256 start=edc4c8c0, len=256
> > |070: 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkjkkkkkkkkkkk
> > |Single bit error detected. Probably bad RAM.
> > |Run a memory test tool.
> > |Prev obj: start=edc4c7c0, len=256
> > |000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > |010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > |Next obj: start=edc4c9c0, len=256
> > |000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > |010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > 
> > which got me a little confused about the bit flip at first.
> > The reason for this was resource counting that went wrong followed by a "put"
> > called from two places.
> > After the second time running into the same problem using the same driver,
> > I was looking for something to help me to find atleast one caller (and the
> > kind of object) a little quicker. Here is a debugobject extension to kref which
> > seems to do the job.
> > At kref_init() the debugobject is initialized and activated.
> > At kref_get() / kref_sub() time it is checked if the kref is active. If
> > it is, the request is completed otherwise the "usual" debugobject is
> > printed. Here an example of kref_put() on an already gone object:
> > 
> > |edma-dma-engine edma-dma-engine.0: freeing channel for 57
> > |------------[ cut here ]------------
> > |WARNING: CPU: 0 PID: 2053 at lib/debugobjects.c:260 debug_print_object+0x94/0xc4()
> > |ODEBUG: active_state not available (active state 0) object type: kref hint:   (null)
> > |Modules linked in: ti_am335x_adc(-)
> > |[<c0014d38>] (unwind_backtrace+0x0/0xf4) from [<c001249c>] (show_stack+0x14/0x1c)
> > |[<c001249c>] (show_stack+0x14/0x1c) from [<c0037264>] (warn_slowpath_common+0x64/0x84)
> > |[<c0037264>] (warn_slowpath_common+0x64/0x84) from [<c0037318>] (warn_slowpath_fmt+0x30/0x40)
> > |[<c0037318>] (warn_slowpath_fmt+0x30/0x40) from [<c022e8d0>] (debug_print_object+0x94/0xc4)
> > |[<c022e8d0>] (debug_print_object+0x94/0xc4) from [<c022e9e4>] (debug_object_active_state+0xe4/0x148)
> > |[<c022e9e4>] (debug_object_active_state+0xe4/0x148) from [<bf0a3474>] (iio_buffer_put+0x24/0x70 [industrialio])
> > |[<bf0a3474>] (iio_buffer_put+0x24/0x70 [industrialio]) from [<bf0a0340>] (iio_dev_release+0x44/0x64 [industrialio])
> > |[<bf0a0340>] (iio_dev_release+0x44/0x64 [industrialio]) from [<c0290308>] (device_release+0x2c/0x94)
> > |[<c0290308>] (device_release+0x2c/0x94) from [<c021f040>] (kobject_release+0x44/0x78)
> > |[<c021f040>] (kobject_release+0x44/0x78) from [<c029600c>] (release_nodes+0x1a0/0x248)
> > |[<c029600c>] (release_nodes+0x1a0/0x248) from [<c029355c>] (__device_release_driver+0x98/0xf0)
> > |[<c029355c>] (__device_release_driver+0x98/0xf0) from [<c0293668>] (driver_detach+0xb4/0xb8)
> > |[<c0293668>] (driver_detach+0xb4/0xb8) from [<c0292538>] (bus_remove_driver+0x98/0xec)
> > |[<c0292538>] (bus_remove_driver+0x98/0xec) from [<c008fe2c>] (SyS_delete_module+0x1e0/0x24c)
> > |[<c008fe2c>] (SyS_delete_module+0x1e0/0x24c) from [<c000e680>] (ret_fast_syscall+0x0/0x48)
> > |---[ end trace bc5e9551626b178a ]---
> > 
> > This should help to notice that there is a second "put" and the
> > call chain should point to the object. The "hint" callback is empty because
> > in the "double free" case we don't have any information and the release
> > function is passed as an argument to kref_put(). I think the information
> > is quite good and it is not worth extending debugobject to somehow add
> > this information.
> > The "get/put unless" macros aren't traced completely because it is hard
> > to get it correct without a false positive and without touching each
> > user. The object might be added to a list which is browsed by someone.
> > That someone holds the same lock that is required for in the cleanup path
> > and so the cleanup is blocked. That means that the kref object is
> > gone from debugobject point of view but the release function has not yet
> > complete so it is valid to check the current counter.
> > 
> > v1…v2:
> > - not an RFC anymore
> > - addressed tglx review:
> >   - use debug_obj_descr with state active
> >   - use debug_object_active_state() to check for active object instead the
> >     other hack I had.
> >   - added debug_object_free() in a way that does not interfere with the
> >     NSA sniffer API so it does not get removed from the patch by accident.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> I need an ack from Thomas or some other debugobjects-knowledgable
> developer before I can take this...

Reviwed-by: Thomas Gleixner <tglx@linutronix.de>

--8323329-1702520893-1386753711=:28330--
