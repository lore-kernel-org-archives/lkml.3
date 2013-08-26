Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3HZBTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:19:22 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44142 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3HZBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:19:14 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 6/8] mm/hwpoison: drop forward reference declarations __soft_offline_page()
Date: Mon, 26 Aug 2013 09:18:49 +0800
Message-Id: <1377479931-7430-6-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1377479931-7430-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1377479931-7430-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082601-4790-0000-0000-000009F839A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop forward reference declarations __soft_offline_page.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/memory-failure.c | 128 ++++++++++++++++++++++++++--------------------------
 1 file changed, 63 insertions(+), 65 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f357c91..ca714ac 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1511,71 +1511,6 @@ static int soft_offline_huge_page(struct page *page, int flags)
 	return ret;
 }
 
-static int __soft_offline_page(struct page *page, int flags);
-
-/**
- * soft_offline_page - Soft offline a page.
- * @page: page to offline
- * @flags: flags. Same as memory_failure().
- *
- * Returns 0 on success, otherwise negated errno.
- *
- * Soft offline a page, by migration or invalidation,
- * without killing anything. This is for the case when
- * a page is not corrupted yet (so it's still valid to access),
- * but has had a number of corrected errors and is better taken
- * out.
- *
- * The actual policy on when to do that is maintained by
- * user space.
- *
- * This should never impact any application or cause data loss,
- * however it might take some time.
- *
- * This is not a 100% solution for all memory, but tries to be
- * ``good enough'' for the majority of memory.
- */
-int soft_offline_page(struct page *page, int flags)
-{
-	int ret;
-	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_trans_head(page);
-
-	if (PageHWPoison(page)) {
-		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
-	}
-	if (!PageHuge(page) && PageTransHuge(hpage)) {
-		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
-			pr_info("soft offline: %#lx: failed to split THP\n",
-				pfn);
-			return -EBUSY;
-		}
-	}
-
-	ret = get_any_page(page, pfn, flags);
-	if (ret < 0)
-		return ret;
-	if (ret) { /* for in-use pages */
-		if (PageHuge(page))
-			ret = soft_offline_huge_page(page, flags);
-		else
-			ret = __soft_offline_page(page, flags);
-	} else { /* for free pages */
-		if (PageHuge(page)) {
-			set_page_hwpoison_huge_page(hpage);
-			dequeue_hwpoisoned_huge_page(hpage);
-			atomic_long_add(1 << compound_order(hpage),
-					&num_poisoned_pages);
-		} else {
-			SetPageHWPoison(page);
-			atomic_long_inc(&num_poisoned_pages);
-		}
-	}
-	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
-	return ret;
-}
-
 static int __soft_offline_page(struct page *page, int flags)
 {
 	int ret;
@@ -1662,3 +1597,66 @@ static int __soft_offline_page(struct page *page, int flags)
 	}
 	return ret;
 }
+
+/**
+ * soft_offline_page - Soft offline a page.
+ * @page: page to offline
+ * @flags: flags. Same as memory_failure().
+ *
+ * Returns 0 on success, otherwise negated errno.
+ *
+ * Soft offline a page, by migration or invalidation,
+ * without killing anything. This is for the case when
+ * a page is not corrupted yet (so it's still valid to access),
+ * but has had a number of corrected errors and is better taken
+ * out.
+ *
+ * The actual policy on when to do that is maintained by
+ * user space.
+ *
+ * This should never impact any application or cause data loss,
+ * however it might take some time.
+ *
+ * This is not a 100% solution for all memory, but tries to be
+ * ``good enough'' for the majority of memory.
+ */
+int soft_offline_page(struct page *page, int flags)
+{
+	int ret;
+	unsigned long pfn = page_to_pfn(page);
+	struct page *hpage = compound_trans_head(page);
+
+	if (PageHWPoison(page)) {
+		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		return -EBUSY;
+	}
+	if (!PageHuge(page) && PageTransHuge(hpage)) {
+		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
+			pr_info("soft offline: %#lx: failed to split THP\n",
+				pfn);
+			return -EBUSY;
+		}
+	}
+
+	ret = get_any_page(page, pfn, flags);
+	if (ret < 0)
+		return ret;
+	if (ret) { /* for in-use pages */
+		if (PageHuge(page))
+			ret = soft_offline_huge_page(page, flags);
+		else
+			ret = __soft_offline_page(page, flags);
+	} else { /* for free pages */
+		if (PageHuge(page)) {
+			set_page_hwpoison_huge_page(hpage);
+			dequeue_hwpoisoned_huge_page(hpage);
+			atomic_long_add(1 << compound_order(hpage),
+					&num_poisoned_pages);
+		} else {
+			SetPageHWPoison(page);
+			atomic_long_inc(&num_poisoned_pages);
+		}
+	}
+	unset_migratetype_isolate(page, MIGRATE_MOVABLE);
+	return ret;
+}
-- 
1.8.1.2

