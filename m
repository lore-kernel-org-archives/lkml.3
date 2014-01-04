Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaADUf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:35:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbaADUf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:35:58 -0500
Date: Sat, 4 Jan 2014 15:35:39 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
In-Reply-To: <20140104181620.GA2087@kroah.com>
Message-ID: <alpine.LRH.2.02.1401041456070.21108@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com> <20140104181620.GA2087@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Jan 2014, Greg Kroah-Hartman wrote:

> On Sat, Jan 04, 2014 at 01:06:01PM -0500, Mikulas Patocka wrote:
> > Hi
> > 
> > I noticed that Jeff Mahoney added a new structure kobj_completion, defined 
> > in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch 
> > eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kernel, 
> > this interface is still unused.
> 
> There are pending btrfs patches to use this interface.
> 
> > However, converting the drivers to use kobj_completion is not trivial 
> > (note that all users of the original kobject interface are buggy - so all 
> > of them need to be converted).
> 
> Wait, what?  How are "all users" buggy?  Please explain this in detail.

1) some code takes a reference to a kobject
2) the user unloads the device
3) the device driver unload routine calls kobject_put (but there is still 
   reference, so the kobject is not destroyed)
4) the device is unregistered, it drops the module reference count to zero
5) the user unloads the module
6) the piece of code that grabbed the kobject reference at step 1) drops 
   it
7) the kobject code calls ->release method, it points into the unloaded 
   module


You could try to fix it by incrementing the module reference count between 
steps 2) and 3) and decrementing it in the kobject release routine, but it 
doesn't work - you'd have to run "module_put(THIS_MODULE);" from the 
kobject release routine - it is still buggy, because the module may be 
unloaded just after "module_put(THIS_MODULE);" and before the release 
routine returns.


Another problem with incrementing the module reference count happens if 
the above sequence is executing as a consequence of module unloading - 
suppose that steps 2)-4) are being executed from the module unload routine 
itself (for example, network drivers have this property that the module 
may be removed while the device is in use and the module unload routine 
shuts the device down). In this case, there is no way to delay unloading 
of the module from the unload routine itself.


> > I came up with a simpler patch to achieve the same purpose - this patch 
> > makes fixing the drivers easy - the driver is fixed just by replacing 
> > "kobject_put" with "kobject_put_wait" in the unload routine.
> 
> No, that's not ok at all.

What exactly do you think is wrong with this patch?

> > I'd like to ask if you could revert 
> > eee031649707db3c9920d9498f8d03819b74fc23 (no code uses it) and replace it 
> > with this patch.
> > 
> > See http://www.redhat.com/archives/dm-devel/2013-October/msg00141.html for 
> > the bug that this patch fixes.
> > 
> > Mikulas
> > 
> > 
> > 
> > From: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > This patch introduces a new function kobject_put_wait. It decrements the
> > kobject reference count, waits until the count reaches zero. When this
> > function returns, it is guaranteed that the kobject was freed.
> > 
> > A rationale for this function:
> > 
> > The kobject is keeps a reference count. The driver unload routine
> > decrements the reference count, however, references to the kobject may
> > still be held by other kernel subsystems. The driver must not free the
> > memory that contains the kobject. Instead, the driver provides a "release"
> > method. The "release" method is called by the kernel when the last kobject
> > refernce is dropped. The "release" method should free the memory that
> > contains the kobject.
> > 
> > However, this pattern is buggy with respect to modules. The release method
> > is placed in the driver's module. When the driver exits, the module
> > reference count is zero, thus the module may be freed. However, there may
> > still be references to the kobject. If the module is unloaded and then the
> > release method is called, a crash happens.
> 
> Yes, module unloading while a kobject is still "active" is not a good
> thing, what modules do you have that cause this problem?

All modules - Do you have some code in the generic module unload routine 
that prevents unloading the module while someone holds a reference to a 
kobject created by the module? If not, then all modules have this bug.

> Why not just
> grab the module reference in your kobject if you need this type of
> protection?

See above - you'd have to drop the reference count from the module itself. 
And it doesn't work if you are destroying the kobject from the module 
unload routine itself.

> It's not the kobject's code fault that this issue is there,
> or that we now have a "delayed release" function to expose this type of
> thing, it's the user of the kobject.

So, show me any single driver that do this correctly. I haven't looked at 
the whole kernel, but all drivers I have looked on so far are buggy.


Just a grep '\.release' drivers/*/*.c shows this:

These are buggy because they don't manage module references in the kobject 
release routine: pkt_kobj_release, cpufreq_sysfs_release, 
cpuidle_sysfs_release, ktype_state_cpuidle, cpuidle_driver_sysfs_release, 
dmi_entry_free, dmi_sysfs_entry_release, release_firmware_map_entry, 
rdev_free, md_free, pps_cdev_release, iscsi_boot_kobj_release, 
map_release, portio_release

These are decrementing the own module count from the release method, so 
they are less buggy than the above, but still buggy: 
edac_device_ctrl_instance_release, edac_device_ctrl_master_release, 
edac_device_ctrl_instance_release

> Please fix the broken users of the kobject first.
> 
> thanks,
> 
> greg k-h

Mikulas
