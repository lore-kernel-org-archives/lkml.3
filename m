Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3JAJzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:55:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:37546 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab3JAJzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:55:37 -0400
X-IronPort-AV: E=Sophos;i="4.90,1013,1371052800"; 
   d="scan'208";a="8662843"
Message-ID: <524A9BE1.6040604@cn.fujitsu.com>
Date: Tue, 01 Oct 2013 17:54:41 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: robert.moore@intel.com, lv.zheng@intel.com,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        "mina86@mina86.com" <mina86@mina86.com>, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, Rik van Riel <riel@redhat.com>,
        prarit@redhat.com, Toshi Kani <toshi.kani@hp.com>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, linux-acpi@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>, imtangchen@gmail.com,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: [PATCH -mm 6/8] acpi, numa, mem_hotplug: Mark all nodes the kernel
 resides un-hotpluggable
References: <524A991D.3050005@cn.fujitsu.com>
In-Reply-To: <524A991D.3050005@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:53:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:53:42,
	Serialize complete at 2013/10/01 17:53:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Chen <tangchen@cn.fujitsu.com>

At very early time, the kernel have to use some memory such as
loading the kernel image. We cannot prevent this anyway. So any
node the kernel resides in should be un-hotpluggable.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index ef9130d..1673821 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -494,6 +494,14 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 		struct numa_memblk *mb = &mi->blk[i];
 		memblock_set_node(mb->start, mb->end - mb->start,
 				  &memblock.memory, mb->nid);
+
+		/*
+		 * At this time, all memory regions reserved by memblock are
+		 * used by the kernel. Set the nid in memblock.reserved will
+		 * mark out all the nodes the kernel resides in.
+		 */
+		memblock_set_node(mb->start, mb->end - mb->start,
+				  &memblock.reserved, mb->nid);
 	}
 
 	/*
@@ -555,6 +563,30 @@ static void __init numa_init_array(void)
 	}
 }
 
+static void __init numa_clear_kernel_node_hotplug(void)
+{
+	int i, nid;
+	nodemask_t numa_kernel_nodes;
+	unsigned long start, end;
+	struct memblock_type *type = &memblock.reserved;
+
+	/* Mark all kernel nodes. */
+	for (i = 0; i < type->cnt; i++)
+		node_set(type->regions[i].nid, numa_kernel_nodes);
+
+	/* Clear MEMBLOCK_HOTPLUG flag for memory in kernel nodes. */
+	for (i = 0; i < numa_meminfo.nr_blks; i++) {
+		nid = numa_meminfo.blk[i].nid;
+		if (!node_isset(nid, numa_kernel_nodes))
+			continue;
+
+		start = numa_meminfo.blk[i].start;
+		end = numa_meminfo.blk[i].end;
+
+		memblock_clear_hotplug(start, end - start);
+	}
+}
+
 static int __init numa_init(int (*init_func)(void))
 {
 	int i;
@@ -569,6 +601,8 @@ static int __init numa_init(int (*init_func)(void))
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.memory,
 				  MAX_NUMNODES));
+	WARN_ON(memblock_set_node(0, ULLONG_MAX, &memblock.reserved,
+				  MAX_NUMNODES));
 	/* In case that parsing SRAT failed. */
 	WARN_ON(memblock_clear_hotplug(0, ULLONG_MAX));
 	numa_reset_distance();
@@ -595,6 +629,16 @@ static int __init numa_init(int (*init_func)(void))
 			numa_clear_node(i);
 	}
 	numa_init_array();
+
+	/*
+	 * At very early time, the kernel have to use some memory such as
+	 * loading the kernel image. We cannot prevent this anyway. So any
+	 * node the kernel resides in should be un-hotpluggable.
+	 *
+	 * And when we come here, numa_init() won't fail.
+	 */
+	numa_clear_kernel_node_hotplug();
+
 	return 0;
 }
 
-- 
1.7.1
