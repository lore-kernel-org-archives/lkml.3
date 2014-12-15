Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaLOOet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaLOO3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hugh Dickins <hughd@google.com>, Kelley Nielsen <kelleynnn@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 145/168] mm: fix swapoff hang after page migration and fork
Date: Mon, 15 Dec 2014 14:26:39 +0000
Message-Id: <1418653622-21105-146-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7e9f0918559b..00a99f5614df 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -813,20 +813,20 @@ copy_one_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
2.1.3

