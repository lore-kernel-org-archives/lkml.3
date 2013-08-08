Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007Ab3HHKSC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:18:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49522 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934193Ab3HHKRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:17:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,838,1367942400"; 
   d="scan'208";a="8154034"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Date: Thu, 8 Aug 2013 18:16:12 +0800
Message-Id: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 18:16:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 18:16:18,
	Serialize complete at 2013/08/08 18:16:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

In previous parts' patches, we have obtained SRAT earlier enough, right after
memblock is ready. So this patch-set does the following things:

1. Improve memblock to support flags, which are used to indicate different 
   memory type.

2. Mark all hotpluggable memory in memblock.memory[].

3. Make the default memblock allocator skip hotpluggable memory.

4. Introduce "movablenode" boot option to allow users to enable/disable this
   functionality.


Tang Chen (6):
  x86, numa, mem_hotplug: Skip all the regions the kernel resides in.
  memblock, numa: Introduce flag into memblock.
  memblock, mem_hotplug: Introduce MEMBLOCK_HOTPLUG flag to mark
    hotpluggable regions.
  memblock, mem_hotplug: Make memblock skip hotpluggable regions by
    default.
  mem-hotplug: Introduce movablenode boot option to {en|dis}able using
    SRAT.
  x86, numa, acpi, memory-hotplug: Make movablenode have higher
    priority.

Yasuaki Ishimatsu (1):
  x86: get pg_data_t's memory from other node

 Documentation/kernel-parameters.txt |   15 ++++++
 arch/x86/kernel/setup.c             |   10 +++-
 arch/x86/mm/numa.c                  |    5 +-
 include/linux/memblock.h            |   13 +++++
 include/linux/memory_hotplug.h      |    3 +
 mm/memblock.c                       |   92 +++++++++++++++++++++++++++++------
 mm/memory_hotplug.c                 |   56 +++++++++++++++++++++-
 mm/page_alloc.c                     |   31 +++++++++++-
 8 files changed, 201 insertions(+), 24 deletions(-)

