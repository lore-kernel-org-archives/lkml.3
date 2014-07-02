Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaGBTLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:11:13 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64563 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaGBTLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:11:11 -0400
Date: Wed, 2 Jul 2014 12:09:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Revert "shmem: fix faulting into a hole while it's
 punched"
Message-ID: <alpine.LSU.2.11.1407021204180.12131@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f00cdc6df7d7cfcabb5b740911e6788cb0802bdb.

(a) It was buggy: Sasha sent a lockdep report to remind us that grabbing
i_mutex in the fault path is a no-no (write syscall may already hold
i_mutex while faulting user buffer), no matter that the patch took care
to drop mmap_sem first.

(b) It may be thought too elaborate: see the diffstat.

(c) Vlastimil proposed a preferred approach, better for backporting to
v3.1..v3.4, which had madvise hole-punch support before the fallocate
infrastructure used in that commit - backporting being required once
the issue fixed was tagged with CVE-2014-4171.

(d) Hugh noticed a further pessimization fix needed in the same area.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dave Jones <davej@redhat.com>
---

 mm/shmem.c |   56 +++------------------------------------------------
 1 file changed, 4 insertions(+), 52 deletions(-)

--- 3.16-rc3/mm/shmem.c	2014-06-29 15:22:10.592003936 -0700
+++ linux/mm/shmem.c	2014-07-02 03:31:12.956546569 -0700
@@ -80,12 +80,11 @@ static struct vfsmount *shm_mnt;
 #define SHORT_SYMLINK_LEN 128
 
 /*
- * shmem_fallocate communicates with shmem_fault or shmem_writepage via
- * inode->i_private (with i_mutex making sure that it has only one user at
- * a time): we would prefer not to enlarge the shmem inode just for that.
+ * shmem_fallocate and shmem_writepage communicate via inode->i_private
+ * (with i_mutex making sure that it has only one user at a time):
+ * we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
-	int	mode;		/* FALLOC_FL mode currently operating */
 	pgoff_t start;		/* start of range currently being fallocated */
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
@@ -760,7 +759,6 @@ static int shmem_writepage(struct page *
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
 			if (shmem_falloc &&
-			    !shmem_falloc->mode &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
 				shmem_falloc->nr_unswapped++;
@@ -1235,44 +1233,6 @@ static int shmem_fault(struct vm_area_st
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
-	/*
-	 * Trinity finds that probing a hole which tmpfs is punching can
-	 * prevent the hole-punch from ever completing: which in turn
-	 * locks writers out with its hold on i_mutex.  So refrain from
-	 * faulting pages into the hole while it's being punched, and
-	 * wait on i_mutex to be released if vmf->flags permits.
-	 */
-	if (unlikely(inode->i_private)) {
-		struct shmem_falloc *shmem_falloc;
-
-		spin_lock(&inode->i_lock);
-		shmem_falloc = inode->i_private;
-		if (!shmem_falloc ||
-		    shmem_falloc->mode != FALLOC_FL_PUNCH_HOLE ||
-		    vmf->pgoff < shmem_falloc->start ||
-		    vmf->pgoff >= shmem_falloc->next)
-			shmem_falloc = NULL;
-		spin_unlock(&inode->i_lock);
-		/*
-		 * i_lock has protected us from taking shmem_falloc seriously
-		 * once return from shmem_fallocate() went back up that stack.
-		 * i_lock does not serialize with i_mutex at all, but it does
-		 * not matter if sometimes we wait unnecessarily, or sometimes
-		 * miss out on waiting: we just need to make those cases rare.
-		 */
-		if (shmem_falloc) {
-			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
-			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
-				up_read(&vma->vm_mm->mmap_sem);
-				mutex_lock(&inode->i_mutex);
-				mutex_unlock(&inode->i_mutex);
-				return VM_FAULT_RETRY;
-			}
-			/* cond_resched? Leave that to GUP or return to user */
-			return VM_FAULT_NOPAGE;
-		}
-	}
-
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
@@ -1769,26 +1729,18 @@ static long shmem_fallocate(struct file
 
 	mutex_lock(&inode->i_mutex);
 
-	shmem_falloc.mode = mode & ~FALLOC_FL_KEEP_SIZE;
-
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
 
-		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
-		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
-		spin_lock(&inode->i_lock);
-		inode->i_private = &shmem_falloc;
-		spin_unlock(&inode->i_lock);
-
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 		error = 0;
-		goto undone;
+		goto out;
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
