Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3IXSXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 14:23:46 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41616 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab3IXSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 14:23:44 -0400
Message-ID: <5241D897.1090905@gmail.com>
Date: Wed, 25 Sep 2013 02:23:19 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Rafael J . Wysocki" <rjw@sisk.pl>, lenb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, Rik van Riel <riel@redhat.com>,
        jweiner@redhat.com, prarit@redhat.com
CC: "x86@kernel.org" <x86@kernel.org>, linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        imtangchen@gmail.com, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH v5 0/6] x86, memblock: Allocate memory near kernel image before
 SRAT parsed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, here comes the v5 version. Any comments are welcome!

The v5 version is based on today's linus tree (3.12-rc2)
HEAD is:
commit 4a10c2ac2f368583138b774ca41fac4207911983
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 23 15:41:09 2013 -0700

    Linux 3.12-rc2


[Problem]

The current Linux cannot migrate pages used by the kerenl because
of the kernel direct mapping. In Linux kernel space, va = pa + PAGE_OFFSET.
When the pa is changed, we cannot simply update the pagetable and
keep the va unmodified. So the kernel pages are not migratable.

There are also some other issues will cause the kernel pages not migratable.
For example, the physical address may be cached somewhere and will be used.
It is not to update all the caches.

When doing memory hotplug in Linux, we first migrate all the pages in one
memory device somewhere else, and then remove the device. But if pages are
used by the kernel, they are not migratable. As a result, memory used by
the kernel cannot be hot-removed.

Modifying the kernel direct mapping mechanism is too difficult to do. And
it may cause the kernel performance down and unstable. So we use the following
way to do memory hotplug.


[What we are doing]

In Linux, memory in one numa node is divided into several zones. One of the
zones is ZONE_MOVABLE, which the kernel won't use.

In order to implement memory hotplug in Linux, we are going to arrange all
hotpluggable memory in ZONE_MOVABLE so that the kernel won't use these memory.
To do this, we need ACPI's help.

In ACPI, SRAT(System Resource Affinity Table) contains NUMA info. The memory
affinities in SRAT record every memory range in the system, and also, flags
specifying if the memory range is hotpluggable.
(Please refer to ACPI spec 5.0 5.2.16)

With the help of SRAT, we have to do the following two things to achieve our
goal:

1. When doing memory hot-add, allow the users arranging hotpluggable as
   ZONE_MOVABLE.
   (This has been done by the MOVABLE_NODE functionality in Linux.)

2. when the system is booting, prevent bootmem allocator from allocating
   hotpluggable memory for the kernel before the memory initialization
   finishes.

The problem 2 is the key problem we are going to solve. But before solving it,
we need some preparation. Please see below.


[Preparation]

Bootloader has to load the kernel image into memory. And this memory must be 
unhotpluggable. We cannot prevent this anyway. So in a memory hotplug system, 
we can assume any node the kernel resides in is not hotpluggable.

Before SRAT is parsed, we don't know which memory ranges are hotpluggable. But
memblock has already started to work. In the current kernel, memblock allocates 
the following memory before SRAT is parsed:

setup_arch()
 |->memblock_x86_fill()            /* memblock is ready */
 |......
 |->early_reserve_e820_mpc_new()   /* allocate memory under 1MB */
 |->reserve_real_mode()            /* allocate memory under 1MB */
 |->init_mem_mapping()             /* allocate page tables, about 2MB to map 1GB memory */
 |->dma_contiguous_reserve()       /* specified by user, should be low */
 |->setup_log_buf()                /* specified by user, several mega bytes */
 |->relocate_initrd()              /* could be large, but will be freed after boot, should reorder */
 |->acpi_initrd_override()         /* several mega bytes */
 |->reserve_crashkernel()          /* could be large, should reorder */
 |......
 |->initmem_init()                 /* Parse SRAT */

According to Tejun's advice, before SRAT is parsed, we should try our best to
allocate memory near the kernel image. Since the whole node the kernel resides 
in won't be hotpluggable, and for a modern server, a node may have at least 16GB
memory, allocating several mega bytes memory around the kernel image won't cross
to hotpluggable memory.


[About this patch-set]

So this patch-set does the following:

1. Make memblock be able to allocate memory bottom up.
   1) Keep all the memblock APIs' prototype unmodified.
   2) When the direction is bottom up, keep the start address greater than the 
      end of kernel image.

2. Improve init_mem_mapping() to support allocate page tables in bottom up direction.

3. Introduce "movablenode" boot option to enable and disable this functionality.

PS: Reordering of relocate_initrd() has not been done yet. acpi_initrd_override() 
    needs to access initrd with virtual address. So relocate_initrd() must be done 
    before acpi_initrd_override().

Change log v4 -> v5:
1. Change memblock.current_direction to a boolean memblock.bottom_up. And remove 
   the direction enum.
2. Update and add some comments to explain things clearer.
3. Misc fixes, such as removing unnecessary #ifdef

Change log v3 -> v4:
1. Use bottom-up/top-down to unify things. Thanks tj.
2. Factor out of current top-down implementation and then introduce bottom-up mode,
   not mixing them in one patch. Thanks tj.
3. Changes function naming: memblock_direction_bottom_up -> memblock_bottom_up
4. Use memblock_set_bottom_up to replace memblock_set_current_direction, which makes
   the code simpler. Thanks tj.
5. Define two implementions of function memblock_bottom_up and memblock_set_bottom_up
   in order not to use #ifdef in the boot code. Thanks tj.
6. Add comments to explain why retry top-down allocation when bottom_up allocation
   failed. Thanks tj and toshi!

Change log v2 -> v3:
1. According to Toshi's suggestion, move the direction checking logic into memblock.
   And simply the code more.

Change log v1 -> v2:
1. According to tj's suggestion, implemented a new function memblock_alloc_bottom_up() 
   to allocate memory from bottom upwards, whihc can simplify the code.

Tang Chen (6):
  memblock: Factor out of top-down allocation
  memblock: Introduce bottom-up allocation mode
  x86/mm: Factor out of top-down direct mapping setup
  x86/mem-hotplug: Support initialize page tables in bottom-up
  x86, acpi, crash, kdump: Do reserve_crashkernel() after SRAT is
    parsed.
  mem-hotplug: Introduce movablenode boot option

 Documentation/kernel-parameters.txt |   15 ++++
 arch/x86/kernel/setup.c             |   15 ++++-
 arch/x86/mm/init.c                  |  118 ++++++++++++++++++++++++++++------
 include/linux/memblock.h            |   16 +++++
 mm/memblock.c                       |  122 +++++++++++++++++++++++++++++++----
 mm/memory_hotplug.c                 |   31 +++++++++
 6 files changed, 283 insertions(+), 34 deletions(-)
