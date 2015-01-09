Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbbAIKcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:32:33 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44489 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752904AbbAIKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Kelley Nielsen <kelleynnn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 18/78] mm: fix swapoff hang after page migration and fork
Date: Fri,  9 Jan 2015 11:31:27 +0100
Message-Id: <0315eaed91c9cbf0e26aa0bdcef213e45e9c44a3.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2022b4d18a491a578218ce7a4eca8666db895a73 upstream.

I've been seeing swapoff hangs in recent testing: it's cycling around
trying unsuccessfully to find an mm for some remaining pages of swap.

I have been exercising swap and page migration more heavily recently,
and now notice a long-standing error in copy_one_pte(): it's trying to
add dst_mm to swapoff's mmlist when it finds a swap entry, but is doing
so even when it's a migration entry or an hwpoison entry.

Which wouldn't matter much, except it adds dst_mm next to src_mm,
assuming src_mm is already on the mmlist: which may not be so.  Then if
pages are later swapped out from dst_mm, swapoff won't be able to find
where to replace them.

There's already a !non_swap_entry() test for stats: move that up before
the swap_duplicate() and the addition to mmlist.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Kelley Nielsen <kelleynnn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/memory.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index b5901068495f..827a7ed7f5a2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -808,20 +808,20 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		if (!pte_file(pte)) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (swap_duplicate(entry) < 0)
-				return entry.val;
-
-			/* make sure dst_mm is on swapoff's mmlist. */
-			if (unlikely(list_empty(&dst_mm->mmlist))) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&dst_mm->mmlist))
-					list_add(&dst_mm->mmlist,
-						 &src_mm->mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			if (likely(!non_swap_entry(entry)))
+			if (likely(!non_swap_entry(entry))) {
+				if (swap_duplicate(entry) < 0)
+					return entry.val;
+
+				/* make sure dst_mm is on swapoff's mmlist. */
+				if (unlikely(list_empty(&dst_mm->mmlist))) {
+					spin_lock(&mmlist_lock);
+					if (list_empty(&dst_mm->mmlist))
+						list_add(&dst_mm->mmlist,
+							 &src_mm->mmlist);
+					spin_unlock(&mmlist_lock);
+				}
 				rss[MM_SWAPENTS]++;
-			else if (is_migration_entry(entry)) {
+			} else if (is_migration_entry(entry)) {
 				page = migration_entry_to_page(entry);
 
 				if (PageAnon(page))
-- 
2.2.1

