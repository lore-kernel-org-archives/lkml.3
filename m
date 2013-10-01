Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3JAJqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 05:46:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56299 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3JAJqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:46:30 -0400
X-IronPort-AV: E=Sophos;i="4.90,1013,1371052800"; 
   d="scan'208";a="8662825"
Message-ID: <524A99BB.5040000@cn.fujitsu.com>
Date: Tue, 01 Oct 2013 17:45:31 +0800
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
Subject: [PATCH -mm 1/8] x86: get pg_data_t's memory from other node
References: <524A991D.3050005@cn.fujitsu.com>
In-Reply-To: <524A991D.3050005@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:44:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/01 17:44:34,
	Serialize complete at 2013/10/01 17:44:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

If system can create movable node which all memory of the node is allocated
as ZONE_MOVABLE, setup_node_data() cannot allocate memory for the node's
pg_data_t. So, invoke memblock_alloc_nid(...MAX_NUMNODES) again to retry when
the first allocation fails. Otherwise, the system could failed to boot.
(We don't use memblock_alloc_try_nid() to retry because in this function,
if the allocation fails, it will panic the system.)

The node_data could be on hotpluggable node. And so could pagetable and
vmemmap. But for now, doing so will break memory hot-remove path.

A node could have several memory devices. And the device who holds node
data should be hot-removed in the last place. But in NUMA level, we don't
know which memory_block (/sys/devices/system/node/nodeX/memoryXXX) belongs
to which memory device. We only have node. So we can only do node hotplug.

But in virtualization, developers are now developing memory hotplug in qemu,
which support a single memory device hotplug. So a whole node hotplug will
not satisfy virtualization users.

So at last, we concluded that we'd better do memory hotplug and local node
things (local node node data, pagetable, vmemmap, ...) in two steps.
Please refer to https://lkml.org/lkml/2013/6/19/73

For now, we put node_data of movable node to another node, and then improve
it in the future.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/numa.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 8bf93ba..1f68d0e 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -211,9 +211,14 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in node %d\n",
-		       nd_size, nid);
-		return;
+		pr_warn("Cannot find %zu bytes in node %d, so try other nodes",
+			nd_size, nid);
+		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES,
+					   MAX_NUMNODES);
+		if (!nd_pa) {
+			pr_err("Cannot find %zu bytes in any node\n", nd_size);
+			return;
+		}
 	}
 	nd = __va(nd_pa);
 
-- 
1.7.1
