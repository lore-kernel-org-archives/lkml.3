Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaL2BMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:12:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hugh Dickins" <hughd@google.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Kelley Nielsen" <kelleynnn@gmail.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.457703049@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 04/27] mm: fix swapoff hang after page migration and fork
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/memory.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -870,20 +870,20 @@ copy_one_pte(struct mm_struct *dst_mm, s
 		if (!pte_file(pte)) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (swap_duplicate(entry) < 0)
-				return entry.val;
+			if (likely(!non_swap_entry(entry))) {
+				if (swap_duplicate(entry) < 0)
+					return entry.val;
 
-			/* make sure dst_mm is on swapoff's mmlist. */
-			if (unlikely(list_empty(&dst_mm->mmlist))) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&dst_mm->mmlist))
-					list_add(&dst_mm->mmlist,
-						 &src_mm->mmlist);
-				spin_unlock(&mmlist_lock);
-			}
-			if (likely(!non_swap_entry(entry)))
+				/* make sure dst_mm is on swapoff's mmlist. */
+				if (unlikely(list_empty(&dst_mm->mmlist))) {
+					spin_lock(&mmlist_lock);
+					if (list_empty(&dst_mm->mmlist))
+						list_add(&dst_mm->mmlist,
+							 &src_mm->mmlist);
+					spin_unlock(&mmlist_lock);
+				}
 				rss[MM_SWAPENTS]++;
-			else if (is_write_migration_entry(entry) &&
+			} else if (is_write_migration_entry(entry) &&
 					is_cow_mapping(vm_flags)) {
 				/*
 				 * COW mappings require pages in both parent

