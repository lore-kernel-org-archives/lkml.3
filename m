Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3CEG6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:58:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39410 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3CEG6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:58:31 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-b2-51359795ffdc
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC/PATCH 1/5] mm: introduce migrate_replace_page() for migrating
 page to the given target
Date: Tue, 05 Mar 2013 07:57:55 +0100
Message-id: <1362466679-17111-2-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd2p000DDdackLeYs34Nm8XfScfY
	LTbOWM9qcbbpDbvFlysPmSwu75rDZnFvzX9Wi7VH7rJb/D7YyW6x4HgLq8Wyr+/ZHbg9fv+a
	xOjRu/crq8emVZ1sHps+TWL3ODHjN4vH7X+PmT3W/XnF5NG3ZRWjx+dNcgGcUVw2Kak5mWWp
	Rfp2CVwZM3btZy7YL1nRv2AaewPjWZEuRg4OCQETiRMTGbsYOYFMMYkL99azdTFycQgJTGeU
	6Ju/nRXCaWeS2LNvOgtIFZuAoUTX2y42EFtEIEziT+M2sCJmgeNMEn8urgVLCAukSSz7epAZ
	xGYRUJV4u3wpK4jNK+AhsX3Xc0aIzQoScybZgIQ5BTwlniz/CDZfCKhk3rbPTBMYeRcwMqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7SZ9I7GFc1WBxiFOBgVOLhZThqEijEmlhWXJl7
	iFGCg1lJhFeszjRQiDclsbIqtSg/vqg0J7X4EKM0B4uSOC/jqScBQgLpiSWp2ampBalFMFkm
	Dk6pBkbFg2cefnTazrXT9qPatj13Et7lake/6ihZ0ruUrff8JqfU6ztl+3c++7/mlVSX0/Md
	cuW314myvH3KKX/s3M+TQqv3sF6YIH95mdvx34vcujNY13Fwl83b3O9y//yhwPt9hx929OmW
	bl26UCIi8Hpsa1L+MaN8PnPHNZ6lU8RTP/R2FV58VsOoxFKckWioxVxUnAgAhMpzAU4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce migrate_replace_page() function for migrating single page to the
given target page.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/migrate.h |    5 ++++
 mm/migrate.c            |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index a405d3dc..3a8a6c1 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -35,6 +35,8 @@ enum migrate_reason {
 
 #ifdef CONFIG_MIGRATION
 
+extern int migrate_replace_page(struct page *oldpage, struct page *newpage);
+
 extern void putback_lru_pages(struct list_head *l);
 extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
@@ -57,6 +59,9 @@ extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
 #else
 
+static inline int migrate_replace_page(struct page *oldpage,
+		struct page *newpage) { return -ENOSYS; }
+
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
diff --git a/mm/migrate.c b/mm/migrate.c
index 3bbaf5d..a2a6950 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1067,6 +1067,65 @@ out:
 	return rc;
 }
 
+/*
+ * migrate_replace_page
+ *
+ * The function takes one single page and a target page (newpage) and
+ * tries to migrate data to the target page. The caller must ensure that
+ * the source page is locked with one additional get_page() call, which
+ * will be freed during the migration. The caller also must release newpage
+ * if migration fails, otherwise the ownership of the newpage is taken.
+ * Source page is released if migration succeeds.
+ *
+ * Return: error code or 0 on success.
+ */
+int migrate_replace_page(struct page *page, struct page *newpage)
+{
+	struct zone *zone = page_zone(page);
+	unsigned long flags;
+	int ret = -EAGAIN;
+	int pass;
+
+	migrate_prep();
+
+	spin_lock_irqsave(&zone->lru_lock, flags);
+
+	if (PageLRU(page) &&
+	    __isolate_lru_page(page, ISOLATE_UNEVICTABLE) == 0) {
+		struct lruvec *lruvec = mem_cgroup_page_lruvec(page, zone);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+	} else {
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		return -EAGAIN;
+	}
+
+	/* page is now isolated, so release additional reference */
+	put_page(page);
+
+	for (pass = 0; pass < 10 && ret != 0; pass++) {
+		cond_resched();
+
+		if (page_count(page) == 1) {
+			/* page was freed from under us, so we are done */
+			ret = 0;
+			break;
+		}
+		ret = __unmap_and_move(page, newpage, 1, MIGRATE_SYNC);
+	}
+
+	if (ret == 0) {
+		/* take ownership of newpage and add it to lru */
+		putback_lru_page(newpage);
+	} else {
+		/* restore additional reference to the oldpage */
+		get_page(page);
+	}
+
+	putback_lru_page(page);
+	return ret;
+}
+
 #ifdef CONFIG_NUMA
 /*
  * Move a list of individual pages
-- 
1.7.9.5

