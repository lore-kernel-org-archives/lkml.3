Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaIKUzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:55:19 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54303 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaIKUzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:55:09 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 08/10] zsmalloc: add reclaim_zspage()
Date: Thu, 11 Sep 2014 16:53:59 -0400
Message-Id: <1410468841-320-9-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function reclaim_zspage() to evict each object in use in the provided
zspage, so that it can be freed.  This is required to be able to shrink
the zs_pool.  Check in zs_free() if the handle's zspage is in the reclaim
fullness group, and if so ignore it, since it will be freed during reclaim.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index ab72390..60fd23e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -170,6 +170,7 @@ enum fullness_group {
 	_ZS_NR_FULLNESS_GROUPS,
 
 	ZS_EMPTY,
+	ZS_RECLAIM
 };
 #define _ZS_NR_AVAILABLE_FULLNESS_GROUPS ZS_FULL
 
@@ -786,6 +787,80 @@ cleanup:
 	return first_page;
 }
 
+/*
+ * This tries to reclaim all the provided zspage's objects by calling the
+ * zs_pool's ops->evict function for each object in use.  This requires
+ * the zspage's class lock to be held when calling this function.  Since
+ * the evict function may sleep, this drops the class lock before evicting
+ * and objects.  No other locks should be held when calling this function.
+ * This will return with the class lock unlocked.
+ *
+ * If there is no zs_pool->ops or ops->evict function, this returns error.
+ *
+ * This returns 0 on success, -err on failure.  On failure, some of the
+ * objects may have been freed, but not all.  On success, the entire zspage
+ * has been freed and should not be used anymore.
+ */
+static int reclaim_zspage(struct zs_pool *pool, struct page *first_page)
+{
+	struct size_class *class;
+	enum fullness_group fullness;
+	struct page *page = first_page;
+	unsigned long handle;
+	int class_idx, ret = 0;
+
+	BUG_ON(!is_first_page(first_page));
+
+	get_zspage_mapping(first_page, &class_idx, &fullness);
+	class = &pool->size_class[class_idx];
+
+	assert_spin_locked(&class->lock);
+
+	if (!pool->ops || !pool->ops->evict) {
+		spin_unlock(&class->lock);
+		return -EINVAL;
+	}
+
+	/* move the zspage into the reclaim fullness group,
+	 * so it's not available for use by zs_malloc,
+	 * and won't be freed by zs_free
+	 */
+	remove_zspage(first_page, class, fullness);
+	set_zspage_mapping(first_page, class_idx, ZS_RECLAIM);
+
+	spin_unlock(&class->lock);
+
+	might_sleep();
+
+	while (page) {
+		unsigned long offset, idx = 0;
+
+		while ((offset = obj_idx_to_offset(page, idx, class->size))
+					< PAGE_SIZE) {
+			handle = (unsigned long)obj_location_to_handle(page,
+						idx++);
+			if (obj_handle_is_free(first_page, class, handle))
+				continue;
+			ret = pool->ops->evict(pool, handle);
+			if (ret) {
+				spin_lock(&class->lock);
+				fix_fullness_group(pool, first_page);
+				spin_unlock(&class->lock);
+				return ret;
+			}
+			obj_free(handle, page, offset);
+		}
+
+		page = get_next_page(page);
+	}
+
+	free_zspage(first_page);
+
+	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+
+	return 0;
+}
+
 static struct page *find_available_zspage(struct size_class *class)
 {
 	int i;
@@ -1200,6 +1275,13 @@ void zs_free(struct zs_pool *pool, unsigned long obj)
 
 	spin_lock(&class->lock);
 
+	/* must re-check fullness after taking class lock */
+	get_zspage_mapping(first_page, &class_idx, &fullness);
+	if (fullness == ZS_RECLAIM) {
+		spin_unlock(&class->lock);
+		return; /* will be freed during reclaim */
+	}
+
 	obj_free(obj, f_page, f_offset);
 
 	fullness = fix_fullness_group(pool, first_page);
-- 
1.8.3.1

