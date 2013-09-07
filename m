Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942Ab3IGFMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 01:12:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54804 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3IGFMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 01:12:48 -0400
Message-ID: <522AB5AD.6070206@vlnb.net>
Date: Fri, 06 Sep 2013 22:12:13 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.28) Gecko/20120313 Mnenhy/0.8.5 Thunderbird/3.1.20
MIME-Version: 1.0
To: rob.gittins@linux.intel.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@veger.org,
        linux-pmfs@lists.infradead.org
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
In-Reply-To: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:fjfA8Womcj8FaWqUNEPB5HHLZ5A0I/mUQdTFVwwTxed
 KHDWFTk956OchS58QI5kduhrosxl/SSIGHapocLaiFcUroFp0t
 Uhyo1Bq5UVdNrLyvR5IKMwFIzPEX6EvHVtRmxnrcdlLjFSvP/+
 Ax3a43B/iVzY9MFFq1sJRnKNRiRIsxYlcsjx4cODPzYe/RHlAT
 ZR9KyI1uT+1cfl3W6jlAtLrdMZnlqtoCxR1/TmmHMJsm/x1B42
 A3VzlhvJENv20132qMQLRwI7WmBQdVfa2M0B/XG9QjiPrHtP1k
 bZ3igIwi6jdHL19Tol6JMWZGofPaymPnnEIVfNoxBIvL+N+Ng=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rob Gittins, on 09/04/2013 02:54 PM wrote:
> Non-volatile DIMMs have started to become available.  A NVDIMMs is a
> DIMM that does not lose data across power interruptions.  Some of the
> NVDIMMs act like memory, while others are more like a block device
> on the memory bus. Application uses vary from being used to cache
> critical data, to being a boot device.
> 
> There are two access classes of NVDIMMs,  block mode and
> “load/store” mode DIMMs which are referred to as Direct Memory
> Mappable.
> 
> The block mode is where the DIMM provides IO ports for read or write
> of data.  These DIMMs reside on the memory bus but do not appear in the
> application address space.  Block mode DIMMs do not require any changes
> to the current infrastructure, since they provide IO type of interface.
> 
> Direct Memory Mappable DIMMs (DMMD) appear in the system address space
> and are accessed via load and store instructions.  These NVDIMMs
> are part of the system physical address space (SPA) as memory with
> the attribute that data survives a power interruption.  As such this
> memory is managed by the kernel which can  assign virtual addresses and
> mapped into application’s address space as well as being accessible
> by the kernel.  The area mapped into the system address space is
> being referred to as persistent memory (PMEM).
> 
> PMEM introduces the need for new operations in the
> block_device_operations to support the specific characteristics of
> the media.
> 
> First data may not propagate all the way through the memory pipeline
> when store instructions are executed.  Data may stay in the CPU cache
> or in other buffers in the processor and memory complex.  In order to
> ensure the durability of data there needs to be a driver entry point
> to force a byte range out to media.  The methods of doing this are
> specific to the PMEM technology and need to be handled by the driver
> that is supporting the DMMDs.  To provide a way to ensure that data is
> durable adding a commit function to the block_device_operations vector.
> 
>    void (*commitpmem)(struct block_device *bdev, void *addr);

Why to glue to the block concept for apparently not block class of devices? By pushing
NVDIMMs into the block model you both limiting them to block devices capabilities as
well as have to expand block devices by alien to them properties.

NVDIMMs are, apparently, a new class of devices, so better to have a new class of
kernel devices for them. If you then need to put file systems on top of them, just
write one-fit-all blk_nvmem driver, which can create a block device for all types of
NVDIMM devices and drivers.

This way you will clearly and gracefully get the best from NVDIMM devices as well as
won't soil block devices.

Vlad
