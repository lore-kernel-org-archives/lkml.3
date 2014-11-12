Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaKLIiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:38:08 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:34350 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbaKLIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:38:06 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="43261153"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: <akpm@linux-foundation.org>, <grygorii.strashko@ti.com>,
        <yinghai@kernel.org>, <isimatu.yasuaki@jp.fujitsu.com>,
        <fabf@skynet.be>, <nzimmer@sgi.com>, <wangnan0@huawei.com>,
        <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <stable@vger.kernel.org.#.3.16+>
Subject: [PATCH v3 2/2] mem-hotplug: Reset node present pages when hot-adding a new pgdat.
Date: Wed, 12 Nov 2014 16:37:14 +0800
Message-ID: <1415781434-20230-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415781434-20230-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1415781434-20230-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.71]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When memory is hot-added, all the memory is in offline state. So
clear all zones' present_pages because they will be updated in
online_pages() and offline_pages(). Otherwise, /proc/zoneinfo
will corrupt:

When the memory of node2 is offline:
# cat /proc/zoneinfo
......
Node 2, zone   Movable
......
        spanned  8388608
        present  8388608
        managed  0

When we online memory on node2:
# cat /proc/zoneinfo
......
Node 2, zone   Movable
......
        spanned  8388608
        present  16777216
        managed  8388608

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: stable@vger.kernel.org # 3.16+
---
 mm/memory_hotplug.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8aba12b..d0c9b7c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1067,6 +1067,16 @@ out:
 }
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+static void reset_node_present_pages(pg_data_t *pgdat)
+{
+	struct zone *z;
+
+	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
+		z->present_pages = 0;
+
+	pgdat->node_present_pages = 0;
+}
+
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
 static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
 {
@@ -1105,6 +1115,13 @@ static pg_data_t __ref *hotadd_new_pgdat(int nid, u64 start)
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

