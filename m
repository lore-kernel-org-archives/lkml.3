Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3E3SIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:08:17 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:46051 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab3E3SFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:05:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>, metin d <metdos@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 03/10] mm: shmem: save one radix tree lookup when truncating swapped pages
Date: Thu, 30 May 2013 14:03:59 -0400
Message-Id: <1369937046-27666-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
References: <1369937046-27666-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page cache radix tree slots are usually stabilized by the page lock,
but shmem's swap cookies have no such thing.  Because the overall
truncation loop is lockless, the swap entry is currently confirmed by
a tree lookup and then deleted by another tree lookup under the same
tree lock region.

Use radix_tree_delete_item() instead, which does the verification and
deletion with only one lookup.  This also allows removing the
delete-only special case from shmem_radix_tree_replace().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/shmem.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 1c44af7..f6f5e4c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -240,19 +240,17 @@ static int shmem_radix_tree_replace(struct address_space *mapping,
 			pgoff_t index, void *expected, void *replacement)
 {
 	void **pslot;
-	void *item = NULL;
+	void *item;
 
 	VM_BUG_ON(!expected);
+	VM_BUG_ON(!replacement);
 	pslot = radix_tree_lookup_slot(&mapping->page_tree, index);
-	if (pslot)
-		item = radix_tree_deref_slot_protected(pslot,
-							&mapping->tree_lock);
+	if (!pslot)
+		return -ENOENT;
+	item = radix_tree_deref_slot_protected(pslot, &mapping->tree_lock);
 	if (item != expected)
 		return -ENOENT;
-	if (replacement)
-		radix_tree_replace_slot(pslot, replacement);
-	else
-		radix_tree_delete(&mapping->page_tree, index);
+	radix_tree_replace_slot(pslot, replacement);
 	return 0;
 }
 
@@ -384,14 +382,15 @@ export:
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	int error;
+	void *old;
 
 	spin_lock_irq(&mapping->tree_lock);
-	error = shmem_radix_tree_replace(mapping, index, radswap, NULL);
+	old = radix_tree_delete_item(&mapping->page_tree, index, radswap);
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!error)
-		free_swap_and_cache(radix_to_swp_entry(radswap));
-	return error;
+	if (old != radswap)
+		return -ENOENT;
+	free_swap_and_cache(radix_to_swp_entry(radswap));
+	return 0;
 }
 
 /*
-- 
1.8.3

