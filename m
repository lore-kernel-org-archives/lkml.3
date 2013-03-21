Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab3CUJSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:18:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45098 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758047Ab3CUJSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:18:42 -0400
X-IronPort-AV: E=Sophos;i="4.84,884,1355068800"; 
   d="scan'208";a="6917174"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com, mgorman@suse.de,
        walken@google.com, riel@redhat.com, khlebnikov@openvz.org,
        tj@kernel.org, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, kosaki.motohiro@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH part2 0/4] Allow allocating pagetable on local node in movablemem_map.
Date: Thu, 21 Mar 2013 17:21:12 +0800
Message-Id: <1363857676-30694-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:17:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/21 17:17:11,
	Serialize complete at 2013/03/21 17:17:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai, all,

This patch-set is based on Yinghai's tree:
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm

For main line, we need to apply Yinghai's
"x86, ACPI, numa: Parse numa info early" patch-set first.
Please refer to:
v1: https://lkml.org/lkml/2013/3/7/642
v2: https://lkml.org/lkml/2013/3/10/47


In this part2 patch-set, we didi the following things:
1) Introduce a "bool hotpluggable" member into struct numa_memblk so that we are
   able to know which memory ranges in numa_meminfo are hotpluggable.
   All the related apis have been changed.
2) Introduce a new global variable "numa_meminfo_all" to store all the memory ranges
   recorded in SRAT, because numa_cleanup_meminfo() will remove ranges higher than
   max_pfn.
   We need full numa memory info to limit zone_movable_pfn[].
3) Move movablemem_map sanitization after memory mapping is initialized so that
   pagetable allocation will not be limited by movablemem_map.


On the other hand, we may have another way to solve this problem:

Not only pagetable and vmemmap pages, but also all the data whose life cycle is the
same as a node, could be put on local node.

1) Introduce a flag into memblock, such as "LOCAL_NODE_DATA", to mark out which
   ranges have the same life cycle with node.
2) Only keep existing memory ranges in movablemem_map (no need to introduce
   numa_meminfo_all), and exclude these LOCAL_NODE_DATA ranges.
3) When hot-removing, we are able to find out these ranges, and free them first.
   This is very important.

Also, hot-add logic needs to be modified, too. As Yinghai mentioned before, I think
we can make memblock alive when memory is hot-added. And go with the same logic
as it is when booting.

How do you think?


Tang Chen (4):
  x86, mm, numa, acpi: Introduce numa_meminfo_all to store all the numa
    meminfo.
  x86, mm, numa, acpi: Introduce hotplug info into struct numa_meminfo.
  x86, mm, numa, acpi: Consider hotplug info when cleanup numa_meminfo.
  x86, mm, numa, acpi: Sanitize movablemem_map after memory mapping
    initialized.

 arch/x86/include/asm/numa.h     |    3 +-
 arch/x86/kernel/apic/numaq_32.c |    2 +-
 arch/x86/mm/amdtopology.c       |    3 +-
 arch/x86/mm/numa.c              |  161 +++++++++++++++++++++++++++++++++++++--
 arch/x86/mm/numa_internal.h     |    1 +
 arch/x86/mm/srat.c              |  141 +++++-----------------------------
 6 files changed, 178 insertions(+), 133 deletions(-)

