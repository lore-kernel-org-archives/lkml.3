Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaG1MdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:33:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63165 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaG1MdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:33:04 -0400
Message-ID: <53D642E5.2010305@huawei.com>
Date: Mon, 28 Jul 2014 20:32:37 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <shaohui.zheng@intel.com>, <mgorman@suse.de>, <mingo@redhat.com>,
        Linux MM <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <wangnan0@huawei.com>, <akpm@linux-foundation.org>
Subject: [PATCH] memory hotplug: update the variables after memory removed
References: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com>
In-Reply-To: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com>
X-Forwarded-Message-Id: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ea0854170c95245a258b386c7a9314399c949fe0 added a fuction
update_end_of_memory_vars() to update high_memory, max_pfn and
max_low_pfn.

Here modified the function(added an argument to show add or remove).
And call it in arch_remove_memory() to update these variables too.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 arch/x86/mm/init_64.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df1a992..2557091 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -673,14 +673,24 @@ void __init paging_init(void)
  * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
  * updating.
  */
-static void  update_end_of_memory_vars(u64 start, u64 size)
+static void  update_end_of_memory_vars(u64 start, u64 size, bool flag)
 {
-	unsigned long end_pfn = PFN_UP(start + size);
-
-	if (end_pfn > max_pfn) {
-		max_pfn = end_pfn;
-		max_low_pfn = end_pfn;
-		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	unsigned long end_pfn;
+
+	if (flag) {
+		end_pfn = PFN_UP(start + size);
+		if (end_pfn > max_pfn) {
+			max_pfn = end_pfn;
+			max_low_pfn = end_pfn;
+			high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+		}
+	} else {
+		end_pfn = PFN_UP(start);
+		if (end_pfn < max_pfn) {
+			max_pfn = end_pfn;
+			max_low_pfn = end_pfn;
+			high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+		}
 	}
 }

@@ -702,7 +712,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	WARN_ON_ONCE(ret);

 	/* update max_pfn, max_low_pfn and high_memory */
-	update_end_of_memory_vars(start, size);
+	update_end_of_memory_vars(start, size, true);

 	return ret;
 }
@@ -1025,6 +1035,9 @@ int __ref arch_remove_memory(u64 start, u64 size)
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);

+	/* update max_pfn, max_low_pfn and high_memory */
+	update_end_of_memory_vars(start, size, false);
+
 	return ret;
 }
 #endif
-- 
1.8.1.2


.




