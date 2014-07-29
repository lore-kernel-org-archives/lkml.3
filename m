Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaG2LkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:40:14 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:14112 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaG2LkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:40:12 -0400
Message-ID: <53D78804.2070701@huawei.com>
Date: Tue, 29 Jul 2014 19:39:48 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>
CC: <wangnan0@huawei.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: [PATCH v3] memory hotplug: update the variables after memory removed
References: <53D786EE.3070800@huawei.com>
In-Reply-To: <53D786EE.3070800@huawei.com>
X-Forwarded-Message-Id: <53D786EE.3070800@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.53D7880F.014E,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 382ee77ee266bfe7541aa9b49610a243
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ea0854170c95 ("memory hotplug: fix a bug on /dev/mem
for 64-bit kernels") added a fuction update_end_of_memory_vars()
to update high_memory, max_pfn and max_low_pfn.

Here we may access wrong memory via /dev/mem after memory remove
without this patch.
I modified the function and call it in arch_remove_memory() to update
these variables too.

Change v1->v2:
- according to Dave Hansen and David Rientjes's suggestions modified
  update_end_of_memory_vars().
change v2->v3:
- remove the extra space before the function identifier of
  update_end_of_memory_vars().
- remove the end_pfn and use start_pfn + nr_pages in the conditional.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/init_64.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df1a992..d16368e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -673,15 +673,11 @@ void __init paging_init(void)
  * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
  * updating.
  */
-static void  update_end_of_memory_vars(u64 start, u64 size)
+static void update_end_of_memory_vars(u64 end_pfn)
 {
-	unsigned long end_pfn = PFN_UP(start + size);
-
-	if (end_pfn > max_pfn) {
-		max_pfn = end_pfn;
-		max_low_pfn = end_pfn;
-		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
-	}
+	max_pfn = end_pfn;
+	max_low_pfn = end_pfn;
+	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
 }

 /*
@@ -694,6 +690,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long end_pfn;
 	int ret;

 	init_memory_mapping(start, start + size);
@@ -702,7 +699,9 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	WARN_ON_ONCE(ret);

 	/* update max_pfn, max_low_pfn and high_memory */
-	update_end_of_memory_vars(start, size);
+	end_pfn = start_pfn + nr_pages;
+	if (end_pfn > max_pfn)
+		update_end_of_memory_vars(end_pfn);

 	return ret;
 }
@@ -1025,6 +1024,10 @@ int __ref arch_remove_memory(u64 start, u64 size)
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);

+	/* update max_pfn, max_low_pfn and high_memory */
+	if ((max_pfn >= start_pfn) && (max_pfn < (start_pfn + nr_pages)))
+		update_end_of_memory_vars(start_pfn);
+
 	return ret;
 }
 #endif
-- 
1.8.1.2


.






