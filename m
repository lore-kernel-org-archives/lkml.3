Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3INXyr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 19:54:47 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52407 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab3INXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 19:54:39 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [RESEND PATCH v2 3/4] mm/hwpoison: fix false report 2nd try page recovery
Date: Sun, 15 Sep 2013 07:53:58 +0800
Message-Id: <1379202839-23939-3-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091423-2674-0000-0000-00000AA74967
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the page is poisoned by software inject w/ MF_COUNT_INCREASED flag, there
is a false report 2nd try page recovery which is not truth, this patch fix it
by report first try free buddy page recovery if MF_COUNT_INCREASED is set.

Before patch:

[  346.332041] Injecting memory failure at pfn 200010
[  346.332189] MCE 0x200010: free buddy, 2nd try page recovery: Delayed

After patch:

[  297.742600] Injecting memory failure at pfn 200010
[  297.742941] MCE 0x200010: free buddy page recovery: Delayed

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b114570..6293164 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1114,8 +1114,10 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 			 * shake_page could have turned it free.
 			 */
 			if (is_free_buddy_page(p)) {
-				action_result(pfn, "free buddy, 2nd try",
-						DELAYED);
+				if (flags & MF_COUNT_INCREASED)
+					action_result(pfn, "free buddy", DELAYED);
+				else
+					action_result(pfn, "free buddy, 2nd try", DELAYED);
 				return 0;
 			}
 			action_result(pfn, "non LRU", IGNORED);
-- 
1.7.5.4

