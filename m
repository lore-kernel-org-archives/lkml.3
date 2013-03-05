Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab3CEPDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:03:31 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56852 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab3CEPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:03:28 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>
Subject: [RFC PATCH v1 30/33] mm: use a dedicated lock to protect totalram_pages and zone->managed_pages
Date: Tue,  5 Mar 2013 22:55:13 +0800
Message-Id: <1362495317-32682-31-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
References: <1362495317-32682-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently lock_memory_hotplug()/unlock_memory_hotplug() are used to
protect totalram_pages and zone->managed_pages. Other than the memory
hotplug driver, totalram_pages and zone->managed_pages may be modified
by Xen balloon, virtio_balloon etc at runtime. For those case, memory
hotplug lock is a little too heavy, so introduce a dedicated lock to
protect them.

Now the locking rules for totalram_pages and zone->managed_pages have
been simpilied as:
1) no locking for read accesses because they are unsigned long.
2) no locking for write access at boot time in single-threaded context.
3) serialize write accesses at run time by managed_page_count_lock.

Also adjust zone->managed_pages when dealing with reserved pages.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc: linux-kernel@vger.kernel.org (open list)
---
 include/linux/mm.h     |    6 +-----
 include/linux/mmzone.h |   14 ++++++++++----
 mm/page_alloc.c        |   19 +++++++++++++++++++
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4d1509b..f9cc7f0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1299,14 +1299,10 @@ extern void free_initmem(void);
 #ifdef	CONFIG_HIGHMEM
 extern void free_highmem_page(struct page *page);
 #endif
+extern void adjust_managed_page_count(struct page *page, long count);
 extern unsigned long free_reserved_area(unsigned long start, unsigned long end,
 					int poison, char *s);
 
-static inline void adjust_managed_page_count(struct page *page, long count)
-{
-	totalram_pages += count;
-}
-
 static inline void __free_reserved_page(struct page *page)
 {
 	ClearPageReserved(page);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ede2749..bc58fef 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -474,10 +474,16 @@ struct zone {
 	 * frequently read in proximity to zone->lock.  It's good to
 	 * give them a chance of being in the same cacheline.
 	 *
-	 * Write access to present_pages and managed_pages at runtime should
-	 * be protected by lock_memory_hotplug()/unlock_memory_hotplug().
-	 * Any reader who can't tolerant drift of present_pages and
-	 * managed_pages should hold memory hotplug lock to get a stable value.
+	 * Write access to present_pages at runtime should be protected by
+	 * lock_memory_hotplug()/unlock_memory_hotplug().  Any reader who can't
+	 * tolerant drift of present_pages should hold memory hotplug lock to
+	 * get a stable value.
+	 *
+	 * Read access to managed_pages should be safe because it's unsigned
+	 * long. Write access to zone->managed_pages and totalram_pages are
+	 * protected by managed_page_count_lock at runtime. Basically only
+	 * adjust_managed_page_count() should be used instead of directly
+	 * touching zone->managed_pages and totalram_pages.
 	 */
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8106aa5..2692931 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -99,6 +99,9 @@ nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
 };
 EXPORT_SYMBOL(node_states);
 
+/* Protect totalram_pages and zone->managed_pages */
+static DEFINE_SPINLOCK(managed_page_count_lock);
+
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
 /*
@@ -5113,6 +5116,22 @@ early_param("movablecore", cmdline_parse_movablecore);
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
+void adjust_managed_page_count(struct page *page, long count)
+{
+	bool lock = (system_state != SYSTEM_BOOTING);
+
+	/* No need to acquire the lock during boot */
+	if (lock)
+		spin_lock(&managed_page_count_lock);
+
+	page_zone(page)->managed_pages += count;
+	totalram_pages += count;
+
+	if (lock)
+		spin_unlock(&managed_page_count_lock);
+}
+EXPORT_SYMBOL(adjust_managed_page_count);
+
 unsigned long free_reserved_area(unsigned long start, unsigned long end,
 				 int poison, char *s)
 {
-- 
1.7.9.5

