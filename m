Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3HMLwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:52:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40944 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756999Ab3HMLwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:52:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, vasilis.liaskovitis@profitbricks.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com
Subject: Re: Cannot hot remove a memory device
Date: Tue, 13 Aug 2013 14:02:47 +0200
Message-ID: <2828019.xo6sPxdo6v@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376355764.10300.383.camel@misato.fc.hp.com>
References: <51FA1E41.20304@jp.fujitsu.com> <2995970.hSi3JdcGZF@vostro.rjw.lan> <1376355764.10300.383.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 12, 2013 07:02:44 PM Toshi Kani wrote:
> On Tue, 2013-08-13 at 02:45 +0200, Rafael J. Wysocki wrote:
> > On Monday, August 12, 2013 02:40:43 PM Toshi Kani wrote:
> > > On Sun, 2013-08-11 at 23:13 +0200, Rafael J. Wysocki wrote:
> > > > On Thursday, August 08, 2013 04:50:42 PM Toshi Kani wrote:
> > > > > On Fri, 2013-08-09 at 00:12 +0200, Rafael J. Wysocki wrote:
> > > > > > On Thursday, August 08, 2013 11:15:20 AM Toshi Kani wrote:
> > > > > > > On Fri, 2013-08-02 at 18:04 -0600, Toshi Kani wrote:
> > > > > > > > On Sat, 2013-08-03 at 01:43 +0200, Rafael J. Wysocki wrote:
> > > > > > > > > On Friday, August 02, 2013 03:46:15 PM Toshi Kani wrote:
> > > > > > > > > > On Thu, 2013-08-01 at 23:43 +0200, Rafael J. Wysocki wrote:
> > > > > > >  :
> > > > > > > > > > I think it fails with -EINVAL at the place with dev_warn(dev, "ACPI
> > > > > > > > > > handle is already set\n").  When two ACPI memory objects associate with
> > > > > > > > > > a same memory block, the bind procedure of the 2nd ACPI memory object
> > > > > > > > > > sees that ACPI_HANDLE(dev) is already set to the 1st ACPI memory object.
> > > > > > > > > 
> > > > > > > > > That sound's plausible, but I wonder how we can fix that?
> > > > > > > > > 
> > > > > > > > > There's no way for a single physical device to have two different ACPI
> > > > > > > > > "companions".  It looks like the memory blocks should be 64 M each in that
> > > > > > > > > case.  Or we need to create two child devices for each memory block and
> > > > > > > > > associate each of them with an ACPI object.  That would lead to complications
> > > > > > > > > in the user space interface, though.
> > > > > > > > 
> > > > > > > > Right.  Even bigger issue is that I do not think __add_pages() and
> > > > > > > > __remove_pages() can add / delete a memory chunk that is less than
> > > > > > > > 128MB.  128MB is the granularity of them.  So, we may just have to fail
> > > > > > > > this case gracefully.
> > > > > > > 
> > > > > > > FYI: I have submitted the patch blow to close this part of the issue...
> > > > > > > 
> > > > > > > https://lkml.org/lkml/2013/8/8/396
> > > > > > 
> > > > > > That looks good to me, but we'd still need to make it possible to have
> > > > > > memory blocks smaller than 128 MB ...
> > > > > 
> > > > > Do you mean acpi_bind_one() needs to be able to handle such case?  If
> > > > > so, it should not be a problem since a memory block device won't be
> > > > > created when add_memory() fails with the change above.  So, there is no
> > > > > binding to be done.  If you mean add_memory() needs to be able to handle
> > > > > a smaller range, that's quite a tough one unless we make the section
> > > > > size smaller.
> > > > > 
> > > > > BTW, when add_memory() fails, the memory hot-add request still succeeds
> > > > > with no driver attached.  This seems logical, but the added device is
> > > > > useless when no handler is attached.  And it does not allow ejecting the
> > > > > device with no handler.  I am not too worry about this since this is a
> > > > > rare case, but it reminded me that the framework won't handle rollback.
> > > > 
> > > > I'm not sure which rollback you mean.  During removal?
> > > 
> > > I meant rollback during hot-add.  Ideally, a device should be either
> > > added in usable state (success) or failed back to the original state
> > > (rollback).  Added in un-usable state is not really a success for users,
> > > and creates an odd state to deal with.  But it is still a LOT better
> > > than crashing the system.  So, I think this outcome is reasonable on
> > > this framework because adding rollback at this point will complicate the
> > > things unnecessarily.
> > > 
> > > > There are two slight problems here in my view.  First, even if the device
> > > > cannot be ejected directly, it still will be removed when its parent is
> > > > ejected, so it may be more consistent to just allow everything to be ejected
> > > > regardless of whether or not it has a scan handler.  
> > > 
> > > Agreed.
> > > 
> > > > Second, I guess the
> > > > removal is undesirable for memory devices for which the registration of the
> > > > scan handler failed, so it would be good to fail the "offline" of such devices
> > > > regardless of how we get there.  That's why I thought it would be good to have
> > > > an "offline disabled" flag in struct acpi_device.
> > > 
> > > I see.  But when attach() failed, the memory device may not be used by
> > > the kernel.  So, I think it should be safe to remove it.
> > 
> > The failure of .attach() need not mean that the memory is not used by the
> > kernel, though, and the ACPI device object is still there and still may
> > be involved in some removal scenarios (through its parent).
> 
> As long as .attach() is failed cleanly, which I think is the case for
> the memory handler (if not, we need to fix it), the rest of the kernel
> code may not know what this device is.  That is, the ACPI memory handler
> is the only one that knows PNP0C80 is a memory device.  So, I do not
> think the memory can be used in such case...

Yes, it can, if the kernel discovers it during boot before .attach() is first
called.  So say this happens and the ACPI memory device object has a parent
with existing _EJ0.

The memory handler's .attach() fails, so the initial acpi_bus_scan() won't walk
the namespace below the memory device, but it won't return an error code
either (the root device object is always there).  The parent of the failed
node is regarded as operational in particular.

Now, acpi_scan_hot_remove() is called for the parent.  Since the memory device
object doesn't have "physical" devices associated with it,
acpi_bus_offline_companions() will ignore it and acpi_scan_hot_remove() will go
for acpi_bus_trim() and straight for _EJ0 for the parent.  Splat!

I agree that this is a corner case, but I wonder if leaving it this way is a
good idea. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
