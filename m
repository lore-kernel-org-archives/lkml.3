Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab3IRAjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:39:12 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49753 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3IRAjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:39:10 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 2/4] mm/hwpoison: fix miss catch transparent huge page
Date: Wed, 18 Sep 2013 08:38:55 +0800
Message-Id: <1379464737-23592-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379464737-23592-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1379464737-23592-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091800-4790-0000-0000-00000A5F0E2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 *v1 -> v2: reverse PageTransHuge(page) && !PageHuge(page) check

PageTransHuge() can't guarantee the page is transparent huge page since it
return true for both transparent huge and hugetlbfs pages. This patch fix
it by check the page is also !hugetlbfs page.

Before patch:

[  121.571128] Injecting memory failure at pfn 23a200
[  121.571141] MCE 0x23a200: huge page recovery: Delayed
[  140.355100] MCE: Memory failure is now running on 0x23a200

After patch:

[   94.290793] Injecting memory failure at pfn 23a000
[   94.290800] MCE 0x23a000: huge page recovery: Delayed
[  105.722303] MCE: Software-unpoisoned page 0x23a000

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e28ee77..ed41c63 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1349,7 +1349,7 @@ int unpoison_memory(unsigned long pfn)
 	 * worked by memory_failure() and the page lock is not held yet.
 	 * In such case, we yield to memory_failure() and make unpoison fail.
 	 */
-	if (PageTransHuge(page)) {
+	if (!PageHuge(page) && PageTransHuge(page)) {
 		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
 			return 0;
 	}
-- 
1.7.5.4

