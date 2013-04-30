Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab3D3JSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:18:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:19629 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759173Ab3D3JSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:18:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,580,1363104000"; 
   d="scan'208";a="7159145"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org, laijs@cn.fujitsu.com,
        davem@davemloft.net, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: =?UTF-8?q?=5BPATCH=20v2=2000/13=5D=20Arrange=20hotpluggable=20memory=20in=20SRAT=20as=20ZONE=5FMOVABLE=2E?=
Date: Tue, 30 Apr 2013 17:21:10 +0800
Message-Id: <1367313683-10267-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 17:16:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/30 17:16:52
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In memory hotplug situation, the hotpluggable memory should be
arranged in ZONE_MOVABLE because memory in ZONE_NORMAL may be
used by kernel, and Linux cannot migrate pages used by kernel.

So we need a way to specify hotpluggable memory as movable. It
should be as easy as possible.

According to ACPI spec 5.0, SRAT table has memory affinity
structure and the structure has Hot Pluggable Filed. 
See "5.2.16.2 Memory Affinity Structure".

If we use the information, we might be able to specify hotpluggable
memory by firmware. For example, if Hot Pluggable Filed is enabled,
kernel sets the memory as movable memory.

To achieve this goal, we need to do the following:
1. Prevent memblock from allocating hotpluggable memroy for kernel.
   This is done by reserving hotpluggable memory in memblock as the
   folowing steps:
   1) Parse SRAT early enough so that memblock knows which memory
      is hotpluggable.
   2) Add a "flags" member to memblock so that it is able to tell
      which memory is hotpluggable when freeing it to buddy.

2. Free hotpluggable memory to buddy system when memory initialization
   is done.

3. Arrange hotpluggable memory in ZONE_MOVABLE.
   (This will cause NUMA performance decreased)

4. Provide a user interface to enable/disable this functionality.
   (This is useful for those who don't use memory hotplug and who don't
    want to lose their NUMA performance.)


This patch-set does the following:
patch1:        Fix a little problem.
patch2:        Have Hot-Pluggable Field in SRAT printed when parsing SRAT.
patch4,5:      Introduce hotpluggable field to numa_meminfo.
patch6,7:      Introduce flags to memblock, and keep the public APIs prototype
               unmodified.
patch8,9:      Reserve node-life-cycle memory as MEMBLK_LOCAL_NODE with memblock.
patch10,11:    Reserve hotpluggable memory as MEMBLK_HOTPLUGGABLE with memblock,
               and free it to buddy when memory initialization is done.
patch3,12,13:  Improve "movablecore" boot option to support "movablecore=acpi".


Change log:
1. Fix a bug in patch10: forgot to update start and end value.
2. Add new patch8: make alloc_low_pages be able to call
   memory_add_physaddr_to_nid().


This patch-set is based on Yinghai's
"x86, ACPI, numa: Parse numa info early" patch-set.
Please refer to:
v1: https://lkml.org/lkml/2013/3/7/642
v2: https://lkml.org/lkml/2013/3/10/47
v3: https://lkml.org/lkml/2013/4/4/639
v4: https://lkml.org/lkml/2013/4/11/829

And Yinghai's patch did the following things:
1) Parse SRAT early enough.
2）Allocate pagetable pages in local node.


Tang Chen (12):
  acpi: Print Hot-Pluggable Field in SRAT.
  page_alloc, mem-hotplug: Improve movablecore to {en|dis}able using
    SRAT.
  x86, numa, acpi, memory-hotplug: Introduce hotplug info into struct
    numa_meminfo.
  x86, numa, acpi, memory-hotplug: Consider hotplug info when cleanup
    numa_meminfo.
  memblock, numa: Introduce flag into memblock.
  x86, numa, mem-hotplug: Mark nodes which the kernel resides in.
  x86, numa: Move memory_add_physaddr_to_nid() to CONFIG_NUMA.
  x86, numa, memblock: Introduce MEMBLK_LOCAL_NODE to mark and reserve
    node-life-cycle data.
  x86, acpi, numa, mem-hotplug: Introduce MEMBLK_HOTPLUGGABLE to mark
    and reserve hotpluggable memory.
  x86, memblock, mem-hotplug: Free hotpluggable memory reserved by
    memblock.
  x86, numa, acpi, memory-hotplug: Make movablecore=acpi have higher
    priority.
  doc, page_alloc, acpi, mem-hotplug: Add doc for movablecore=acpi boot
    option.

Yasuaki Ishimatsu (1):
  x86: get pg_data_t's memory from other node

 Documentation/kernel-parameters.txt |    8 ++
 arch/x86/include/asm/numa.h         |    3 +-
 arch/x86/kernel/apic/numaq_32.c     |    2 +-
 arch/x86/mm/amdtopology.c           |    3 +-
 arch/x86/mm/init.c                  |   16 +++-
 arch/x86/mm/numa.c                  |   64 +++++++++++++++---
 arch/x86/mm/numa_internal.h         |    1 +
 arch/x86/mm/srat.c                  |   11 ++-
 include/linux/memblock.h            |   16 +++++
 include/linux/memory_hotplug.h      |    3 +
 mm/memblock.c                       |  127 ++++++++++++++++++++++++++++++----
 mm/nobootmem.c                      |    3 +
 mm/page_alloc.c                     |   37 ++++++++++-
 13 files changed, 256 insertions(+), 38 deletions(-)

