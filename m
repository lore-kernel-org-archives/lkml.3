Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3IEQeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:34:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:35086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3IEQeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:34:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,848,1371106800"; 
   d="scan'208";a="391585057"
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
From: Rob Gittins <rob.gittins@linux.intel.com>
Reply-To: rob.gittins@linux.intel.com
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@veger.org,
        linux-pmfs@lists.infradead.org
In-Reply-To: <x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
	 <x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Opensource Technology Center
Date: Thu, 05 Sep 2013 10:33:41 -0600
Message-ID: <1378398821.3768.116.camel@Virt-Centos-6.lm.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Thanks for taking the time to look at this.

On Thu, 2013-09-05 at 08:12 -0400, Jeff Moyer wrote:
> Rob Gittins <rob.gittins@linux.intel.com> writes:
> 
> > Direct Memory Mappable DIMMs (DMMD) appear in the system address space
> > and are accessed via load and store instructions.  These NVDIMMs
> > are part of the system physical address space (SPA) as memory with
> > the attribute that data survives a power interruption.  As such this
> > memory is managed by the kernel which can  assign virtual addresses and
> > mapped into application’s address space as well as being accessible
> > by the kernel.  The area mapped into the system address space is
> > being referred to as persistent memory (PMEM).
> >
> > PMEM introduces the need for new operations in the
> > block_device_operations to support the specific characteristics of
> > the media.
> >
> > First data may not propagate all the way through the memory pipeline
> > when store instructions are executed.  Data may stay in the CPU cache
> > or in other buffers in the processor and memory complex.  In order to
> > ensure the durability of data there needs to be a driver entry point
> > to force a byte range out to media.  The methods of doing this are
> > specific to the PMEM technology and need to be handled by the driver
> > that is supporting the DMMDs.  To provide a way to ensure that data is
> > durable adding a commit function to the block_device_operations vector.
> 
> If the memory is available to be mapped into the address space of the
> kernel or a user process, then I don't see why we should have a block
> device at all.  I think it would make more sense to have a different
> driver class for these persistent memory devices.

The reason to include block device is to allow existing file systems
to be used with NV-DIMMs.  Assuming that NV-DIMMs are approximately 
the same speed of DRAM it would mean a block IO would happen in 
approximately 1uS.  This would make for a really fast existing
filesystem.

>  
> >    void (*commitpmem)(struct block_device *bdev, void *addr);
> 
> Seems like this would benefit from a length argument as well, no?

Yes.  Great point.  I will add that in.

> 
> > Another area requiring extension is the need to be able to clear PMEM
> > errors.  When data is fetched from errored PMEM it is marked with the
> > poison attribute.  If the CPU attempts to access the data it causes a
> > machine check.  How errors are cleared is hardware dependent and needs
> > to be handled by the specific device driver.  The following function
> > in the block_device_operations vector would clear the correct range
> > of PMEM and put new data there.  If the argument data is null or the
> > size is zero the driver is free to put any data in PMEM it wishes.
> >
> > 	void (*clearerrorpmem)(struct block_device *bdev, void *addr,
> > 			size_t len, void *data);

> What is the size of data?

clearerrorpmem as part of the process of clearing an error 
can effectively write a buffer of data as part of the
clear process.  If the len is zero or the data pointer is null then
only a error clear happens.    


> > Different applications, filesystem and drivers may wish to share
> > ranges of PMEM.  This is analogous to partitioning a disk that is
> > using multiple and different filesystems.   Since PMEM is addressed
> > on a byte basis rather than a block basis the existing partitioning
> > model does not fit well.  As a result there needs to be a way to
> > describe PMEM ranges.
> >
> > 	struct pmem_layout *(*getpmem)(struct block_device *bdev);
> 
> If existing partitioning doesn't work well, then it sounds like a block
> device isn't the right fit (again).  Ignoring that detail, what about
> requesting and releasing ranges of persistent memory, as in your
> "partitioning" example?  Would that not also be a function of the
> driver?

The existing partitioning mechanism was intended for small drives
and works best for a single fs/device.  We are approaching NV-DIMMs
as if they were more like LUNs in storage arrays.  Each range is 
treated as a device.  A range of an NV-DIMM could be partitioned if
someone wanted to do such a thing.

Thanks,
Rob


> 
> Cheers,
> Jeff
> 
> >
> >
> > Proposed patch.
> >
> > ---
> > Documentation/filesystems/Locking |    6 ++++
> > fs/block_dev.c                    |   42
> > +++++++++++++++++++++++++++++++++
> > include/linux/blkdev.h            |    4 +++
> > include/linux/pmem.h              |   47
> > +++++++++++++++++++++++++++++++++++++
> > 4 files changed, 99 insertions(+), 0 deletions(-)
> > create mode 100644 include/linux/pmem.h
> >
> > diff --git a/Documentation/filesystems/Locking
> > b/Documentation/filesystems/Locking
> > index 0706d32..78910f4 100644
> > --- a/Documentation/filesystems/Locking
> > +++ b/Documentation/filesystems/Locking
> > @@ -386,6 +386,9 @@ prototypes:
> > 	int (*revalidate_disk) (struct gendisk *);
> > 	int (*getgeo)(struct block_device *, struct hd_geometry *);
> > 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
> > +	struct pmem_layout *(*getpmem)(struct block_device *);
> > +	void (*commitpmem)(struct block_device *, void *);
> > +	void (*clearerrorpmem)(struct block_device *, void *, size_t, void *);
> > locking rules:
> > 			bd_mutex
> > @@ -399,6 +402,9 @@ unlock_native_capacity:	no
> > revalidate_disk:	no
> > getgeo:			no
> > swap_slot_free_notify:	no	(see below)
> > +getpmem:		no
> > +commitpmem:		no
> > +clearerrorpmem:	no
> > media_changed, unlock_native_capacity and revalidate_disk are called
> > only
> > from
> > check_disk_change().
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index aae187a..a57863c 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -27,6 +27,7 @@
> > #include <linux/namei.h>
> > #include <linux/log2.h>
> > #include <linux/cleancache.h>
> > +#include <linux/pmem.h>
> > #include <asm/uaccess.h>
> > #include "internal.h"
> > @@ -1716,3 +1717,44 @@ void iterate_bdevs(void (*func)(struct
> > block_device
> > *, void *), void *arg)
> > 	spin_unlock(&inode_sb_list_lock);
> > 	iput(old_inode);
> > }
> > +
> > +/**
> > + * get_pmemgeo() - Return persistent memory geometry information
> > + * @bdev:  device to interrogate
> > + *
> > + * Provides the memory layout for a persistent memory volume which
> > + * is made up of CPU-addressable persistent memory.  If the
> > interrogated
> > + * device does not support CPU-addressable persistent memory then
> > -ENOTTY
> > + * is returned.
> > + *
> > + * Return: a pointer to a pmem_layout structure or ERR_PTR
> > + */
> > +struct pmem_layout *get_pmemgeo(struct block_device *bdev)
> > +{
> > +	struct gendisk *bd_disk = bdev->bd_disk;
> > +
> > +	if (!bd_disk || !bd_disk->fops->getpmem)
> > +		return ERR_PTR(-ENOTTY);
> > +	return bd_disk->fops->getpmem(bdev);
> > +}
> > +EXPORT_SYMBOL(get_pmemgeo);
> > +
> > +void commit_pmem(struct block_device *bdev, void *addr)
> > +{
> > +	struct gendisk *bd_disk = bdev->bd_disk;
> > +
> > +	if (bd_disk && bd_disk->fops->commitpmem)
> > +		bd_disk->fops->commitpmem(bdev, addr);
> > +}
> > +EXPORT_SYMBOL(commit_pmem);
> > +
> > +void clear_pmem_error(struct block_device *bdev, void *addr, size_t
> > len,
> > +				void *data)
> > +{
> > +	struct gendisk *bd_disk = bdev->bd_disk;
> > +
> > +	if (bd_disk && bd_disk->fops->clearerrorpmem)
> > +		bd_disk->fops->clearerrorpmem(bdev, addr, len, data);
> > +}
> > +EXPORT_SYMBOL(clear_pmem_error);
> > +
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 78feda9..ba2c1f5 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -1498,6 +1498,10 @@ struct block_device_operations {
> > 	int (*getgeo)(struct block_device *, struct hd_geometry *);
> > 	/* this callback is with swap_lock and sometimes page table lock held
> > */
> > 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
> > +	/* persistent memory operations */
> > +	struct pmem_layout * (*getpmem)(struct block_device *);
> > +	void (*commitpmem)(struct block_device *, void *);
> > +	void (*clearerrorpmem)(struct block_device *, void *, size_t, void *);
> > 	struct module *owner;
> > };
> > diff --git a/include/linux/pmem.h b/include/linux/pmem.h
> > new file mode 100644
> > index 0000000..f907307
> > --- /dev/null
> > +++ b/include/linux/pmem.h
> > @@ -0,0 +1,47 @@
> > +/*
> > + * Definitions for the Persistent Memory interface
> > + * Copyright (c) 2013, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but
> > WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
> > or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> > License
> > for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > along with
> > + * this program; if not, write to the Free Software Foundation, Inc.,
> > + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> > + */
> > +
> > +#ifndef _LINUX_PMEM_H
> > +#define _LINUX_PMEM_H
> > +
> > +#include <linux/types.h>
> > +
> > +struct persistent_memory_extent {
> > +	phys_addr_t pme_spa;
> > +	u64         pme_len;
> > +	int         pme_numa_node;
> > +};
> > +
> > +struct pmem_layout {
> > +	u64         pml_flags;
> > +	u64         pml_total_size;
> > +	u32         pml_extent_count;
> > +	u32			pml_interleave;	/* interleave bytes */
> > +	struct persistent_memory_extent pml_extents[];
> > +};
> > +
> > +/*
> > + * Flags values
> > + */
> > +#define PMEM_ENABLED 0x0000000000000001 /* can be used for Persistent
> > Mem
> > */
> > +#define PMEM_ERRORED 0x0000000000000002 /* in an error state */
> > +#define PMEM_COMMIT  0x0000000000000004 /* commit function available */
> > +#define PMEM_CLEAR_ERROR  0x0000000000000008 /* clear error function
> > provided */
> > +
> > +#endif
> > +
> > --
> > 1.7.1
> >
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


