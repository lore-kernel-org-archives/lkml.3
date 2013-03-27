Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3C0RZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:25:20 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:9390 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3C0RZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:25:18 -0400
Message-ID: <1364404429.15745.74.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] ACPI: Add sysfs links from memory device to memblocks
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, vasilis.liaskovitis@profitbricks.com
Date: Wed, 27 Mar 2013 11:13:49 -0600
In-Reply-To: <7718937.tEXDldppSg@vostro.rjw.lan>
References: <1361826130-31062-1-git-send-email-toshi.kani@hp.com>
	 <3205964.WeZJN7sRdd@vostro.rjw.lan>
	 <1364338776.15745.27.camel@misato.fc.hp.com>
	 <7718937.tEXDldppSg@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-27 at 00:39 +0100, Rafael J. Wysocki wrote:
> On Tuesday, March 26, 2013 04:59:36 PM Toshi Kani wrote:
> > On Tue, 2013-03-26 at 23:39 +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, March 26, 2013 09:42:06 AM Toshi Kani wrote:
> > > > On Tue, 2013-03-26 at 14:04 +0100, Rafael J. Wysocki wrote:
> > > > > On Monday, February 25, 2013 02:02:10 PM Toshi Kani wrote:
> > > > > > In order to eject a memory device object represented as "PNP0C80:%d"
> > > > > > in sysfs, its associated memblocks (system/memory/memory%d) need to
> > > > > > be off-lined.  However, there is no user friendly way to correlate
> > > > > > between a memory device object and its memblocks in sysfs.
> > > > > > 
> > > > > > This patch creates sysfs links to memblocks under a memory device
> > > > > > object so that a user can easily checks and manipulates its memblocks
> > > > > > in sysfs.
> > > > > > 
> > > > > > For example, when PNP0C80:05 is associated with memory8 and memory9,
> > > > > > the following two links are created under PNP0C80:05.  This allows
> > > > > > a user to access memory8/9 directly from PNP0C80:05.
> > > > > > 
> > > > > >   # ll /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C80:05
> > > > > >   lrwxrwxrwx. memory8 -> ../../../system/memory/memory8
> > > > > >   lrwxrwxrwx. memory9 -> ../../../system/memory/memory9
> > > > > > 
> > > > > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > > > 
> > > > > Here I have some doubts.
> > > > > 
> > > > > This adds a very specific interface for user space that we're going to need to
> > > > > maintain going forward if the user space starts to use it.  However, it kind of
> > > > > duplicates the existing "physical_node" interface that we have for "regular"
> > > > > devices.
> > > > > 
> > > > > So, if possible, I'd like the memory subsystem to utilize the existing
> > > > > interface instead of creating an entirely new one.  Namely, why don't we create
> > > > > a struct device-based object for each memory block and associated those new
> > > > > "devices" with the PNP0C80 ACPI object through the functions in glue.c?
> > > > > Then, we could add an "offline/online" interface to those "devices" too.
> > > > 
> > > > This patch simply adds symbolic links to system/memory/memoryN, which
> > > > the memory subsystem already provides for the online/offline interface
> > > > of memory blocks.  So, it does not introduce a new interface, but guides
> > > > users (and user tools) to know which memory blocks need to be off-lined
> > > > in order to hot-delete any particular memory device PNP0C80:X.  A cpu
> > > > device LNXCPU:X also has a similar symbolic link "sysdev" that links to
> > > > system/cpu/cpuN.  I could not use the same "sysdev" for PNP0C80:X since
> > > > it typically associates with multiple memory blocks.
> > > > 
> > > > I thought about using glue.c to create symbolic links between memoryN
> > > > and PNP0C80:X.  However, it has an ordering issue.  During boot-time,
> > > > memoryN gets created before PNP0C80:X.  But during hot-add, PNP0C80:X
> > > > gets created before memoryN.
> > > 
> > > Quite frankly, this sounds like a bug to me.  Namely, what is memoryN really
> > > good for without PNP0C80:X?  If it is not good for anything in that case,
> > > it should never be created befor PNP0C80:X.
> > 
> > memoryN works without PNP0C80:X and does not depend on ACPI.  A memoryN
> > represents a memblk, each of which is merely a 128MB (in case of x86) of
> > memory chunk sliced from the entire memory ranges.
> 
> Ah.  Why is it exported this way?

This is because a memblk is the unit of the Sparse Memory design, which
allows discontinuous memory ranges (ex. NUMA) and online/offline
operations.  So, it makes sense for the memory subsystem to export this
interface, although I feel that 128MB is rather small these days.

> > This is why it is
> > hard to associate between memoryN and PNP0C80:X without these symbolic
> > links (otherwise, you will have to calculate from memory address.)
> 
> Sure.
> 
> > The memory subsystem also obtains the memory ranges from EFI or e820
> > during boot, and ACPI is not necessary to construct memoryN at boot.
> > Since EFI / e820 only provides the boot-time configuration, ACPI is used
> > to update the memory ranges during hot-add/delete.
> > 
> > > > This patch calls
> > > > acpi_setup_mem_blk_links() in a point that solves this ordering issue
> > > > since this point guarantees that both memoryN and PNP0C80X are created
> > > > for both boot-time and hot-add.
> > > 
> > > I would prefer the ordering of creation to be the same in both cases.
> > > Otherwise it really looks like we need to work around a problem that we're
> > > creating for ourselves.
> > > 
> > > How exactly are memoryN created during boot?
> > 
> > memoryN is created in memory_dev_init().  This is even before
> > do_initcalls().  I'd also prefer the same ordering, but I felt that
> > changing this ordering would be rather challenging.
> > 
> > do_basic_setup()
> >   driver_init()
> >     memory_dev_init()
> 
> What about having a "physical memory module" device that will be associated
> with those memory blocks (and will have links to them from its directory in
> sysfs) and that will be pointed to by the "physical_node" pointer from
> under PNP0C80:X?  Then, it may have a driver that will do the online/offline
> (and export the interface for that to user space through sysfs) and will
> interact with the ACPI interface provided by PNP0C80:X.

It sounds interesting idea, but I think it has several issues:

 - Maintenance: It is not clear to me who owns this physical device.
>From the memory subsystem perspective, a memblk is an object that is
managed like a device internally.  So, I do not think the memory
subsystem needs this.  If ACPI owns this, it adds complication to us and
we need to keep up with the memory changes.    
 - Rollback: As offline/online proceeds on each memblk, the driver has
to support rollback when one of memblks failed to offline.  This seems
to against the direction of this approach (no rollback in the kernel).
 - Ordering issue: Creating symbolic links among 3 types of devices
(PNP0C80, memblk, new physical device) further complicates the ordering
issue. 
 - Representation: PNP0C80:X represents the state of an ACPI PNP0C80
device.  memoryN represents the state of a memblk.  It is not clear what
this new physical device really represents when there isn't such device
visible to users.  It may be seen as duplication.

Frankly, if we are to provide a good sysfs UI for hot-delete, I'd prefer
to go with my updated patchset, which keeps user to allow doing "echo 1
> PNP0C80:X/eject", and all associated memblks will be offlined
together.  I think the user space approach will require good management
tools to take care of the UI issue, and the kernel just has to provide
the necessary info to the user space, which this patch is intended.

Thanks,
-Toshi

