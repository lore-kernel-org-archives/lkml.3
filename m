Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaKKB2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:28:17 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:33752 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbaKKB2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:28:13 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43170856"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.co>, <fabf@skynet.be>, <nzimmer@sgi.com>,
        <wangnan0@huawei.com>, <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <miaox@cn.fujitsu.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] mem-hotplug: Reset node present pages when hot-adding a new pgdat.
Date: Tue, 11 Nov 2014 09:27:07 +0800
Message-ID: <1415669227-10996-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415669227-10996-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1415669227-10996-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When onlining memory on node2, node2 zoneinfo and node3 meminfo corrupted:

# for ((i = 2048; i < 2064; i++)); do echo online_movable > /sys/devices/system/node/node2/memory$i/state; done
# cat /sys/devices/system/node/node2/meminfo
Node 2 MemTotal:       33554432 kB
Node 2 MemFree:        33549092 kB
Node 2 MemUsed:            5340 kB
......
# cat /sys/devices/system/node/node3/meminfo
Node 3 MemTotal:              0 kB
Node 3 MemFree:               248 kB      /* corrupted, should be 0 */
Node 3 MemUsed:               0 kB
......

# cat /proc/zoneinfo
......
Node 2, zone   Movable
......
        spanned  8388608
        present  16777216               /* corrupted, should be 8388608 */
        managed  8388608


When memory is hot-added, all the memory is in offline state. So
clear all zone->present_pages because they will be updated in 
online_pages() and offline_pages().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 mm/memory_hotplug.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8aba12b..26eac61 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1067,6 +1067,14 @@ out:
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+static void reset_node_present_pages(pg_data_t *pgdat)
+{
+        struct zone *z;
+
+        for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+                z->present_pages = 0;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
@@ -1105,6 +1113,13 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 	 */
 	reset_node_managed_pages(pgdat);
 
+	/*
+	 * When memory is hot-added, all the memory is in offline state. So
+	 * clear all zones' present_pages because they will be updated in
+	 * online_pages() and offline_pages().
+	 */
+	reset_node_present_pages(pgdat);
+
 	return pgdat;
 }
 
-- 
1.8.3.1

