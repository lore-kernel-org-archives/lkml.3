Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbaJXWHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:07:39 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:39243 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950AbaJXWGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:06:53 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: akpm@linux-foundation.org
Cc: hughd@google.com, riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dbueso@suse.de,
        linux-mm@kvack.org, Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 09/10] mm/nommu: share the i_mmap_rwsem
Date: Fri, 24 Oct 2014 15:06:19 -0700
Message-Id: <1414188380-17376-10-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrinking/truncate logic can call nommu_shrink_inode_mappings()
to verify that any shared mappings of the inode in question aren't
broken (dead zone). afaict the only user being ramfs to handle
the size change attribute.

Pretty much a no-brainer to share the lock.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 mm/nommu.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 52a5765..cd519e1 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -2094,14 +2094,14 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	high = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	down_write(&nommu_region_sem);
-	i_mmap_lock_write(inode->i_mapping);
+	i_mmap_lock_read(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
 	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
-			i_mmap_unlock_write(inode->i_mapping);
+			i_mmap_unlock_read(inode->i_mapping);
 			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
 		}
@@ -2113,8 +2113,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap,
-				  0, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, 0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
@@ -2129,7 +2128,7 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 		}
 	}
 
-	i_mmap_unlock_write(inode->i_mapping);
+	i_mmap_unlock_read(inode->i_mapping);
 	up_write(&nommu_region_sem);
 	return 0;
 }
-- 
1.8.4.5

