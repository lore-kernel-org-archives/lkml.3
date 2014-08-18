Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaHRCDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:03:10 -0400
Received: from [119.145.14.66] ([119.145.14.66]:2202 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaHRCDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:03:08 -0400
Message-ID: <53F15E37.9080602@huawei.com>
Date: Mon, 18 Aug 2014 10:00:23 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Tang Chen" <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] mem-hotplug: let memblock skip the hotpluggable memory
 regions in __next_mem_range()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.53F15E69.0035,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: b694182893aca467843f8c5b8e808661
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let memblock skip the hotpluggable memory regions in __next_mem_range(),
it is used to to prevent memblock from allocating hotpluggable memory 
for the kernel at early time. The code is the same as __next_mem_range_rev().

Clear hotpluggable flag before releasing free pages to the buddy allocator.
If we don't clear hotpluggable flag in free_low_memory_core_early(), the 
memory which marked hotpluggable flag will not free to buddy allocator.
Because __next_mem_range() will skip them.

free_low_memory_core_early
	for_each_free_mem_range
		for_each_mem_range
			__next_mem_range

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
 
-- 1.7.1 



. 

