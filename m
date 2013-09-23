Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab3IWWve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:51:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:32561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab3IWWvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:51:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,966,1371106800"; 
   d="scan'208";a="399975158"
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
From: Rob Gittins <rob.gittins@linux.intel.com>
Reply-To: rob.gittins@linux.intel.com
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@veger.org,
        linux-pmfs@lists.infradead.org
In-Reply-To: <522AB5AD.6070206@vlnb.net>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
	 <522AB5AD.6070206@vlnb.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Opensource Technology Center
Date: Mon, 23 Sep 2013 16:51:28 -0600
Message-ID: <1379976688.5886.12.camel@Virt-Centos-6.lm.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-06 at 22:12 -0700, Vladislav Bolkhovitin wrote:
> Rob Gittins, on 09/04/2013 02:54 PM wrote:
> > Non-volatile DIMMs have started to become available.  A NVDIMMs is a
> > DIMM that does not lose data across power interruptions.  Some of the
> > NVDIMMs act like memory, while others are more like a block device
> > on the memory bus. Application uses vary from being used to cache
> > critical data, to being a boot device.
> > 
> > There are two access classes of NVDIMMs,  block mode and
> > “load/store” mode DIMMs which are referred to as Direct Memory
> > Mappable.
> > 
> > The block mode is where the DIMM provides IO ports for read or write
> > of data.  These DIMMs reside on the memory bus but do not appear in the
> > application address space.  Block mode DIMMs do not require any changes
> > to the current infrastructure, since they provide IO type of interface.
> > 
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
> > 
> >    void (*commitpmem)(struct block_device *bdev, void *addr);
> 
> Why to glue to the block concept for apparently not block class of devices? By pushing
> NVDIMMs into the block model you both limiting them to block devices capabilities as
> well as have to expand block devices by alien to them properties
Hi Vlad,

We chose to extent the block operations for a couple of reasons.  The
majority of NVDIMM usage is by emulating block mode.  We figure that
over time usages will appear that use them directly and then we can
design interfaces to enable direct use.  

Since a range of NVDIMM needs a name, security and other attributes mmap
is a really good model to build on.  This quickly takes us into the
realm of a file systems, which are easiest to build on the existing
block infrastructure.  

Another reason to extend block is that all of the existing
administrative interfaces and tools such as mkfs still work and we have
not added some new management tools and requirements that may inhibit
the adoption of the technology.  Basically if it works today for block
the same cli commands will work for NVDIMMs.

The extensions are so minimal that they don't negatively impact the
existing interfaces.

Thanks,
Rob



> .
> 
> NVDIMMs are, apparently, a new class of devices, so better to have a new class of
> kernel devices for them. If you then need to put file systems on top of them, just
> write one-fit-all blk_nvmem driver, which can create a block device for all types of
> NVDIMM devices and drivers.
> 
> This way you will clearly and gracefully get the best from NVDIMM devices as well as
> won't soil block devices.
> 
> Vlad


