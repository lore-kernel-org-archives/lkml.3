Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3JLG3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:29:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59264 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab3JLG3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:29:37 -0400
X-IronPort-AV: E=Sophos;i="4.93,480,1378828800"; 
   d="scan'208";a="8731185"
Message-ID: <5258E560.5050506@cn.fujitsu.com>
Date: Sat, 12 Oct 2013 14:00:00 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Chen Tang <imtangchen@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH part2 v2 0/8] Arrange hotpluggable memory as ZONE_MOVABLE
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/12 13:59:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/12 13:59:32,
	Serialize complete at 2013/10/12 13:59:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys, this is the part2 of our memory hotplug work. This part
is based on the part1:
    "x86, memblock: Allocate memory near kernel image before SRAT parsed"
which is base on 3.12-rc4.

You could refer part1 from: https://lkml.org/lkml/2013/10/10/644

Any comments are welcome! Thanks!

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


[How we do this]

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
   (This is what we are going to do. See below.)


[About this patch-set]

In previous part's patches, we have made the kernel allocate memory near
kernel image before SRAT parsed to avoid allocating hotpluggable memory
for kernel. So this patch-set does the following things:

1. Improve memblock to support flags, which are used to indicate different 
   memory type.

2. Mark all hotpluggable memory in memblock.memory[].

3. Make the default memblock allocator skip hotpluggable memory.

4. Improve "movable_node" boot option to have higher priority of movablecore
   and kernelcore boot option.

Change log v1 -> v2:
1. Rebase this part on the v7 version of part1
2. Fix bug: If movable_node boot option not specified, memblock still
   checks hotpluggable memory when allocating memory. 

Tang Chen (7):
  memblock, numa: Introduce flag into memblock
  memblock, mem_hotplug: Introduce MEMBLOCK_HOTPLUG flag to mark
    hotpluggable regions
  memblock: Make memblock_set_node() support different memblock_type
  acpi, numa, mem_hotplug: Mark hotpluggable memory in memblock
  acpi, numa, mem_hotplug: Mark all nodes the kernel resides
    un-hotpluggable
  memblock, mem_hotplug: Make memblock skip hotpluggable regions if
    needed
  x86, numa, acpi, memory-hotplug: Make movable_node have higher
    priority

Yasuaki Ishimatsu (1):
  x86: get pg_data_t's memory from other node

 arch/metag/mm/init.c      |    3 +-
 arch/metag/mm/numa.c      |    3 +-
 arch/microblaze/mm/init.c |    3 +-
 arch/powerpc/mm/mem.c     |    2 +-
 arch/powerpc/mm/numa.c    |    8 ++-
 arch/sh/kernel/setup.c    |    4 +-
 arch/sparc/mm/init_64.c   |    5 +-
 arch/x86/mm/init_32.c     |    2 +-
 arch/x86/mm/init_64.c     |    2 +-
 arch/x86/mm/numa.c        |   63 +++++++++++++++++++++--
 arch/x86/mm/srat.c        |    5 ++
 include/linux/memblock.h  |   39 ++++++++++++++-
 mm/memblock.c             |  123 ++++++++++++++++++++++++++++++++++++++-------
 mm/memory_hotplug.c       |    1 +
 mm/page_alloc.c           |   28 ++++++++++-
 15 files changed, 252 insertions(+), 39 deletions(-)

