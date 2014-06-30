Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaF3WuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 18:50:10 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35235 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaF3WuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 18:50:08 -0400
Date: Mon, 30 Jun 2014 15:48:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH mmotm/next] mm: memcontrol: rewrite charge API: fix
 shmem_unuse
Message-ID: <alpine.LSU.2.11.1406301541420.4349@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under shmem swapping and swapoff load, I sometimes hit the
VM_BUG_ON_PAGE(!page->mapping) in mem_cgroup_commit_charge() at
mm/memcontrol.c:6502!  Each time it has been a call from shmem_unuse().

Yes, there are some cases (most commonly when the page being unswapped
is in a file being unlinked and evicted at that time) when the charge
should not be committed.  In the old scheme, the page got uncharged
again on release; but in the new scheme, it hits that BUG beforehand.

It's a useful BUG, so adapt shmem_unuse() to allow for it.  Which needs
more info from shmem_unuse_inode(): so abuse -EAGAIN internally to
replace the previous !found state (-ENOENT would be a more natural
code, but that's exactly what you get when the swap has been evicted).

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- 3.16-rc2-mm1/mm/shmem.c	2014-06-25 18:43:59.868588121 -0700
+++ linux/mm/shmem.c	2014-06-30 15:05:50.736335600 -0700
@@ -611,7 +611,7 @@ static int shmem_unuse_inode(struct shme
 	radswap = swp_to_radix_entry(swap);
 	index = radix_tree_locate_item(&mapping->page_tree, radswap);
 	if (index == -1)
-		return 0;
+		return -EAGAIN;
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -670,7 +670,6 @@ static int shmem_unuse_inode(struct shme
 			spin_unlock(&info->lock);
 			swap_free(swap);
 		}
-		error = 1;	/* not an error, but entry was found */
 	}
 	return error;
 }
@@ -683,7 +682,6 @@ int shmem_unuse(swp_entry_t swap, struct
 	struct list_head *this, *next;
 	struct shmem_inode_info *info;
 	struct mem_cgroup *memcg;
-	int found = 0;
 	int error = 0;
 
 	/*
@@ -702,22 +700,24 @@ int shmem_unuse(swp_entry_t swap, struct
 	if (error)
 		goto out;
 	/* No radix_tree_preload: swap entry keeps a place for page in tree */
+	error = -EAGAIN;
 
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(this, next, &shmem_swaplist) {
 		info = list_entry(this, struct shmem_inode_info, swaplist);
 		if (info->swapped)
-			found = shmem_unuse_inode(info, swap, &page);
+			error = shmem_unuse_inode(info, swap, &page);
 		else
 			list_del_init(&info->swaplist);
 		cond_resched();
-		if (found)
+		if (error != -EAGAIN)
 			break;
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
 
-	if (found < 0) {
-		error = found;
+	if (error) {
+		if (error != -ENOMEM)
+			error = 0;
 		mem_cgroup_cancel_charge(page, memcg);
 	} else
 		mem_cgroup_commit_charge(page, memcg, true);
