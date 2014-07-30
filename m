Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaG3Mpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:45:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36617 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752441AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 07/94] shmem: fix faulting into a hole while it's punched
Date: Wed, 30 Jul 2014 14:13:56 +0200
Message-Id: <8685789bd8ec12a02b07ea76df4527b055efbf20.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f00cdc6df7d7cfcabb5b740911e6788cb0802bdb upstream.

Trinity finds that mmap access to a hole while it's punched from shmem
can prevent the madvise(MADV_REMOVE) or fallocate(FALLOC_FL_PUNCH_HOLE)
from completing, until the reader chooses to stop; with the puncher's
hold on i_mutex locking out all other writers until it can complete.

It appears that the tmpfs fault path is too light in comparison with its
hole-punching path, lacking an i_data_sem to obstruct it; but we don't
want to slow down the common case.

Extend shmem_fallocate()'s existing range notification mechanism, so
shmem_fault() can refrain from faulting pages into the hole while it's
punched, waiting instead on i_mutex (when safe to sleep; or repeatedly
faulting when not).

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/shmem.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8297623fcaed..00d412fd2254 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -80,11 +80,12 @@ static struct vfsmount *shm_mnt;
 #define SHORT_SYMLINK_LEN 128
 
 /*
- * shmem_fallocate and shmem_writepage communicate via inode->i_private
- * (with i_mutex making sure that it has only one user at a time):
- * we would prefer not to enlarge the shmem inode just for that.
+ * shmem_fallocate communicates with shmem_fault or shmem_writepage via
+ * inode->i_private (with i_mutex making sure that it has only one user at
+ * a time): we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
+	int	mode;		/* FALLOC_FL mode currently operating */
 	pgoff_t start;		/* start of range currently being fallocated */
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
@@ -826,6 +827,7 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
 			if (shmem_falloc &&
+			    !shmem_falloc->mode &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
 				shmem_falloc->nr_unswapped++;
@@ -1300,6 +1302,44 @@ static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
+	/*
+	 * Trinity finds that probing a hole which tmpfs is punching can
+	 * prevent the hole-punch from ever completing: which in turn
+	 * locks writers out with its hold on i_mutex.  So refrain from
+	 * faulting pages into the hole while it's being punched, and
+	 * wait on i_mutex to be released if vmf->flags permits.
+	 */
+	if (unlikely(inode->i_private)) {
+		struct shmem_falloc *shmem_falloc;
+
+		spin_lock(&inode->i_lock);
+		shmem_falloc = inode->i_private;
+		if (!shmem_falloc ||
+		    shmem_falloc->mode != FALLOC_FL_PUNCH_HOLE ||
+		    vmf->pgoff < shmem_falloc->start ||
+		    vmf->pgoff >= shmem_falloc->next)
+			shmem_falloc = NULL;
+		spin_unlock(&inode->i_lock);
+		/*
+		 * i_lock has protected us from taking shmem_falloc seriously
+		 * once return from shmem_fallocate() went back up that stack.
+		 * i_lock does not serialize with i_mutex at all, but it does
+		 * not matter if sometimes we wait unnecessarily, or sometimes
+		 * miss out on waiting: we just need to make those cases rare.
+		 */
+		if (shmem_falloc) {
+			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
+			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
+				up_read(&vma->vm_mm->mmap_sem);
+				mutex_lock(&inode->i_mutex);
+				mutex_unlock(&inode->i_mutex);
+				return VM_FAULT_RETRY;
+			}
+			/* cond_resched? Leave that to GUP or return to user */
+			return VM_FAULT_NOPAGE;
+		}
+	}
+
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
@@ -1815,18 +1855,26 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
 	mutex_lock(&inode->i_mutex);
 
+	shmem_falloc.mode = mode & ~FALLOC_FL_KEEP_SIZE;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
 
+		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
+		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
+		spin_lock(&inode->i_lock);
+		inode->i_private = &shmem_falloc;
+		spin_unlock(&inode->i_lock);
+
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 		error = 0;
-		goto out;
+		goto undone;
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
-- 
2.0.1

