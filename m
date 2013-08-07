Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab3HGKzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:55:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24966 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932670Ab3HGKxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:53:53 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8144158"
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
Subject: [PATCH v3 15/25] x86: get pg_data_t's memory from other node
Date: Wed, 7 Aug 2013 18:52:06 +0800
Message-Id: <1375872736-4822-16-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1375872736-4822-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:52:19,
	Serialize complete at 2013/08/07 18:52:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

If system can create movable node which all memory of the node is allocated
as ZONE_MOVABLE, setup_node_data() cannot allocate memory for the node's
pg_data_t. So, use memblock_alloc_try_nid() instead of memblock_alloc_nid()
to retry when the first allocation fails. Otherwise, the system could failed
to boot.

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

In the later patches, a boot option will be introduced to enable/disable this
functionality. If users disable it, the node_data will still be put on the
local node.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/numa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 8bf93ba..d532b6d 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -209,10 +209,9 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 * Allocate node data.  Try node-local memory and then any node.
 	 * Never allocate in DMA zone.
 	 */
-	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
+	nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in node %d\n",
-		       nd_size, nid);
+		pr_err("Cannot find %zu bytes in any node\n", nd_size);
 		return;
 	}
 	nd = __va(nd_pa);
-- 
1.7.1

