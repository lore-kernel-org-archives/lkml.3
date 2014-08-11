Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaHKNc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:32:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:15135 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbaHKNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:32:55 -0400
Message-ID: <53E8C5AA.5040506@huawei.com>
Date: Mon, 11 Aug 2014 21:31:22 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, <tj@kernel.org>,
        Wen Congyang <wency@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        "Xishi Qiu" <qiuxishi@huawei.com>
Subject: [PATCH] mem-hotplug: let memblock skip the hotpluggable memory regions
 in __next_mem_range()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let memblock skip the hotpluggable memory regions in __next_mem_range(),
it is used to to prevent memblock from allocating hotpluggable memory 
for the kernel at early time. The code is the same as __next_mem_range_rev().

Clear hotpluggable flag before releasing free pages to the buddy allocator.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 mm/memblock.c  |    4 ++++
 mm/nobootmem.c |    2 ++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 6d2f219..5090050 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -817,6 +817,10 @@ void __init_memblock __next_mem_range(u64 *idx, int nid,
 		if (nid != NUMA_NO_NODE && nid != m_nid)
 			continue;
 
+		/* skip hotpluggable memory regions if needed */
+		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
+			continue;
+
 		if (!type_b) {
 			if (out_start)
 				*out_start = m_start;
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 7ed5860..03de286 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -119,6 +119,8 @@ static unsigned long __init free_low_memory_core_early(void)
 	phys_addr_t start, end;
 	u64 i;
 
+	memblock_clear_hotplug(0, ULLONG_MAX);
+
 	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
-- 
1.7.1


