Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3JLGLB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:11:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37941 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3JLGK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:10:57 -0400
X-IronPort-AV: E=Sophos;i="4.93,480,1378828800"; 
   d="scan'208";a="8731007"
Message-ID: <5258E7A5.70701@cn.fujitsu.com>
Date: Sat, 12 Oct 2013 14:09:41 +0800
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
Subject: [PATCH part2 v2 8/8] x86, numa, acpi, memory-hotplug: Make movable_node
 have higher priority
References: <5258E560.5050506@cn.fujitsu.com>
In-Reply-To: <5258E560.5050506@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/12 14:08:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/12 14:08:42,
	Serialize complete at 2013/10/12 14:08:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

If users specify the original movablecore=nn@ss boot option, the kernel will
arrange [ss, ss+nn) as ZONE_MOVABLE. The kernelcore=nn@ss boot option is similar
except it specifies ZONE_NORMAL ranges.

Now, if users specify "movable_node" in kernel commandline, the kernel will
arrange hotpluggable memory in SRAT as ZONE_MOVABLE. And if users do this, all
the other movablecore=nn@ss and kernelcore=nn@ss options should be ignored.

For those who don't want this, just specify nothing. The kernel will act as
before.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/page_alloc.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..768ea0e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5021,9 +5021,33 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	nodemask_t saved_node_state = node_states[N_MEMORY];
 	unsigned long totalpages = early_calculate_totalpages();
 	int usable_nodes = nodes_weight(node_states[N_MEMORY]);
+	struct memblock_type *type = &memblock.memory;
+
+	/* Need to find movable_zone earlier when movable_node is specified. */
+	find_usable_zone_for_movable();
+
+	/*
+	 * If movable_node is specified, ignore kernelcore and movablecore
+	 * options.
+	 */
+	if (movable_node_is_enabled()) {
+		for (i = 0; i < type->cnt; i++) {
+			if (!memblock_is_hotpluggable(&type->regions[i]))
+				continue;
+
+			nid = type->regions[i].nid;
+
+			usable_startpfn = PFN_DOWN(type->regions[i].base);
+			zone_movable_pfn[nid] = zone_movable_pfn[nid] ?
+				min(usable_startpfn, zone_movable_pfn[nid]) :
+				usable_startpfn;
+		}
+
+		goto out2;
+	}
 
 	/*
-	 * If movablecore was specified, calculate what size of
+	 * If movablecore=nn[KMG] was specified, calculate what size of
 	 * kernelcore that corresponds so that memory usable for
 	 * any allocation type is evenly spread. If both kernelcore
 	 * and movablecore are specified, then the value of kernelcore
@@ -5049,7 +5073,6 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		goto out;
 
 	/* usable_startpfn is the lowest possible pfn ZONE_MOVABLE can be at */
-	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
 restart:
@@ -5140,6 +5163,7 @@ restart:
 	if (usable_nodes && required_kernelcore > usable_nodes)
 		goto restart;
 
+out2:
 	/* Align start of ZONE_MOVABLE on all nids to MAX_ORDER_NR_PAGES */
 	for (nid = 0; nid < MAX_NUMNODES; nid++)
 		zone_movable_pfn[nid] =
-- 
1.7.1
