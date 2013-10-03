Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3JCAxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:53:07 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62058 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3JCAw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:52:27 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dhaval.giani@gmail.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 12/14] vrange: Support background purging for vrange-file
Date: Wed,  2 Oct 2013 17:51:41 -0700
Message-Id: <1380761503-14509-13-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380761503-14509-1-git-send-email-john.stultz@linaro.org>
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

Add support to purge vrange file pages via the shrinker interface.

This is useful, since some filesystems like shmem/tmpfs use anonymous
pages, which won't be aged off the page LRU if swap is disabled.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Robert Love <rlove@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
[jstultz: Commit message tweaks]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 mm/vrange.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 49 insertions(+), 7 deletions(-)

diff --git a/mm/vrange.c b/mm/vrange.c
index c6bc32f..3f21dc9 100644
--- a/mm/vrange.c
+++ b/mm/vrange.c
@@ -13,6 +13,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
+#include <linux/pagevec.h>
 
 static struct kmem_cache *vrange_cachep;
 
@@ -854,21 +855,62 @@ out:
 	return ret;
 }
 
+static int __discard_vrange_file(struct address_space *mapping,
+			struct vrange *vrange, unsigned int *ret_discard)
+{
+	struct pagevec pvec;
+	pgoff_t index;
+	int i;
+	unsigned int nr_discard = 0;
+	unsigned long start_idx = vrange->node.start;
+	unsigned long end_idx = vrange->node.last;
+	const pgoff_t start = start_idx >> PAGE_CACHE_SHIFT;
+	pgoff_t end = end_idx >> PAGE_CACHE_SHIFT;
+	LIST_HEAD(pagelist);
+
+	pagevec_init(&pvec, 0);
+	index = start;
+	while (index <= end && pagevec_lookup(&pvec, mapping, index,
+			min(end - index, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
+		for (i = 0; i < pagevec_count(&pvec); i++) {
+			struct page *page = pvec.pages[i];
+			index = page->index;
+			if (index > end)
+				break;
+			if (isolate_lru_page(page))
+				continue;
+			list_add(&page->lru, &pagelist);
+			inc_zone_page_state(page, NR_ISOLATED_ANON);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+		index++;
+	}
+
+	if (!list_empty(&pagelist))
+		nr_discard = discard_vrange_pagelist(&pagelist);
+
+	*ret_discard = nr_discard;
+	putback_lru_pages(&pagelist);
+
+	return 0;
+}
+
 static int discard_vrange(struct vrange *vrange)
 {
 	int ret = 0;
-	struct mm_struct *mm;
 	struct vrange_root *vroot;
 	unsigned int nr_discard = 0;
 	vroot = vrange->owner;
 
-	/* TODO : handle VRANGE_FILE */
-	if (vroot->type != VRANGE_MM)
-		goto out;
+	if (vroot->type == VRANGE_MM) {
+		struct mm_struct *mm = vroot->object;
+		ret = __discard_vrange_anon(mm, vrange, &nr_discard);
+	} else if (vroot->type == VRANGE_FILE) {
+		struct address_space *mapping = vroot->object;
+		ret = __discard_vrange_file(mapping, vrange, &nr_discard);
+	}
 
-	mm = vroot->object;
-	ret = __discard_vrange_anon(mm, vrange, &nr_discard);
-out:
 	return nr_discard;
 }
 
-- 
1.8.1.2

