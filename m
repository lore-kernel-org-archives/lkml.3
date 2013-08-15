Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432Ab3HOPwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:52:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45927 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3HOPwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:52:14 -0400
Message-ID: <520CF92A.90909@wwwdotorg.org>
Date: Thu, 15 Aug 2013 09:52:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Caizhiyong <caizhiyong@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>
Subject: Re: [PATCH] block: support embedded device command line partition
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 03:57 AM, Caizhiyong wrote:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> 
> Read block device partition table from command line.
> The partition used for fixed block device (eMMC) embedded device.
> It is no MBR, save storage space. Bootloader can be easily accessed by
> absolute address of data on the block device.
> Users can easily change the partition.
> 
> This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
> About the partition verbose reference "Documentation/block/cmdline-partition.txt"

Interesting. NVIDIA Tegra devices running our downstream kernels have a
"tegrapt" (for "Tegra Partition Table") command-line option for
basically the same purpose. While I'd personally prefer we move our eMMC
layout towards standardized GPT, the feature implemented by this patch
may well provide an easy migration/co-existence path instead, so could
be quite useful.

> diff --git a/Documentation/block/cmdline-partition.txt b/Documentation/block/cmdline-partition.txt

> +Read block device partition table from command line.
> +The partition used for fixed block device (eMMC) embedded device.
> +It is no MBR, save storage space. Bootloader can be easily accessed
> +by absolute address of data on the block device.
> +Users can easily change the partition.
> +
> +The format for the command line is just like mtdparts:
> +
> +blkdevparts=<blkdev-def>[;<blkdev-def>]
> +  <blkdev-def> := <blkdev-id>:<partdef>[,<partdef>]
> +    <partdef> := <size>[@<offset>](part-name)
> +
> +<blkdev-id>
> +    block device disk name, embedded device used fixed block device,
> +    it's disk name also fixed. such as: mmcblk0, mmcblk1, mmcblk0boot0.

The device-name isn't always fixed.

For example, what if there are multiple SDHCI controllers, one hosting a
fixed eMMC device and the other an SD card? It's quite typical for the
eMMC's device name (which is likely what should be affected by this
feature) to be mmcblk0 when no SD card is present, yet be mmcblk1 when
an SD card is present. Is there a more precise/stable way to define
which device the command-line option applies to?

For the root= command-line option, we use UUID= or PARTUUID= to work
around this issue, but that won't work for naming the whole device.

What about using the MMIO address of the controller hosting the device,
or something like that?

> +<size>
> +    partition size, in bytes, such as: 512, 1m, 1G.

s/m/M/?

I assume M/G are MiB/GiB?

Does it make sense to allow specifying the sizes in units of
sectors/blocks? If so, which specific block/sector size in the case of
things like NAND flash which IIRC have multiple types/levels of sectors;
perhaps this is a bad idea. I guess we could easily add this feature
later by introducing a new suffix, so no need to solve the issue now.

> +
> +<offset>
> +    partition start address, in bytes.
> +
> +(part-name)
> +    partition name, kernel send uevent with "PARTNAME". application can create
> +    a link to block device partition with the name "PARTNAME".
> +    user space application can access partition by partition name.

Do partitions usually have a PARTNAME attribute when probed through
normal mechanisms like MBR? If so, I guess this is fine.

Perhaps we can just use , as the delimiter for all fields, rather than
special-casing part-name to use (), so:

size,offset,partname,size,offset,partname,...

The partname field could easily be empty if not needed.

> +Example:
> +    eMMC disk name is "mmcblk0" and "mmcblk0boot0"
> +
> +  bootargs:
> +    'blkdevparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'
> +
> +  dmesg:
> +    mmcblk0: p1(data0) p2(data1) p3()
> +    mmcblk0boot0: p1(boot) p2(kernel)

