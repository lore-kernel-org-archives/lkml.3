Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaGZUV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:21:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaGZTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Sasha Levin <sasha.levin@oracle.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 02/23] shmem: fix faulting into a hole while its punched
Date: Sat, 26 Jul 2014 12:02:02 -0700
Message-Id: <20140726190149.796467545@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190149.723570428@linuxfoundation.org>
References: <20140726190149.723570428@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 mm/shmem.c    |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/truncate.c |   25 ---------------
 2 files changed, 91 insertions(+), 25 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -76,6 +76,16 @@ static struct vfsmount *shm_mnt;
 /* Symlink up to this size is kmalloc'ed instead of using a swappable page */
 #define SHORT_SYMLINK_LEN 128
 
+/*
+ * vmtruncate_range() communicates with shmem_fault via
+ * inode->i_private (with i_mutex making sure that it has only one user at
+ * a time): we would prefer not to enlarge the shmem inode just for that.
+ */
+struct shmem_falloc {
+	pgoff_t start;		/* start of range currently being fallocated */
+	pgoff_t next;		/* the next page offset to be fallocated */
+};
+
 struct shmem_xattr {
 	struct list_head list;	/* anchored by shmem_inode_info->xattr_list */
 	char *name;		/* xattr name */
@@ -1060,6 +1070,43 @@ static int shmem_fault(struct vm_area_st
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
+		    vmf->pgoff < shmem_falloc->start ||
+		    vmf->pgoff >= shmem_falloc->next)
+			shmem_falloc = NULL;
+		spin_unlock(&inode->i_lock);
+		/*
+		 * i_lock has protected us from taking shmem_falloc seriously
+		 * once return from vmtruncate_range() went back up that stack.
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
@@ -1071,6 +1118,44 @@ static int shmem_fault(struct vm_area_st
 	return ret;
 }
 
+int vmtruncate_range(struct inode *inode, loff_t lstart, loff_t lend)
+{
+	/*
+	 * If the underlying filesystem is not going to provide
+	 * a way to truncate a range of blocks (punch a hole) -
+	 * we should return failure right now.
+	 * Only CONFIG_SHMEM shmem.c ever supported i_op->truncate_range().
+	 */
+	if (inode->i_op->truncate_range != shmem_truncate_range)
+		return -ENOSYS;
+
+	mutex_lock(&inode->i_mutex);
+	{
+		struct shmem_falloc shmem_falloc;
+		struct address_space *mapping = inode->i_mapping;
+		loff_t unmap_start = round_up(lstart, PAGE_SIZE);
+		loff_t unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
+
+		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
+		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
+		spin_lock(&inode->i_lock);
+		inode->i_private = &shmem_falloc;
+		spin_unlock(&inode->i_lock);
+
+		if ((u64)unmap_end > (u64)unmap_start)
+			unmap_mapping_range(mapping, unmap_start,
+					    1 + unmap_end - unmap_start, 0);
+		shmem_truncate_range(inode, lstart, lend);
+		/* No need to unmap again: hole-punching leaves COWed pages */
+
+		spin_lock(&inode->i_lock);
+		inode->i_private = NULL;
+		spin_unlock(&inode->i_lock);
+	}
+	mutex_unlock(&inode->i_mutex);
+	return 0;
+}
+
 #ifdef CONFIG_NUMA
 static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
 {
@@ -2547,6 +2632,12 @@ void shmem_truncate_range(struct inode *
 }
 EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
+int vmtruncate_range(struct inode *inode, loff_t lstart, loff_t lend)
+{
+	/* Only CONFIG_SHMEM shmem.c ever supported i_op->truncate_range(). */
+	return -ENOSYS;
+}
+
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
 #define shmem_get_inode(sb, dir, mode, dev, flags)	ramfs_get_inode(sb, dir, mode, dev)
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -603,31 +603,6 @@ int vmtruncate(struct inode *inode, loff
 }
 EXPORT_SYMBOL(vmtruncate);
 
-int vmtruncate_range(struct inode *inode, loff_t lstart, loff_t lend)
-{
-	struct address_space *mapping = inode->i_mapping;
-	loff_t holebegin = round_up(lstart, PAGE_SIZE);
-	loff_t holelen = 1 + lend - holebegin;
-
-	/*
-	 * If the underlying filesystem is not going to provide
-	 * a way to truncate a range of blocks (punch a hole) -
-	 * we should return failure right now.
-	 */
-	if (!inode->i_op->truncate_range)
-		return -ENOSYS;
-
-	mutex_lock(&inode->i_mutex);
-	inode_dio_wait(inode);
-	unmap_mapping_range(mapping, holebegin, holelen, 1);
-	inode->i_op->truncate_range(inode, lstart, lend);
-	/* unmap again to remove racily COWed private pages */
-	unmap_mapping_range(mapping, holebegin, holelen, 1);
-	mutex_unlock(&inode->i_mutex);
-
-	return 0;
-}
-
 /**
  * truncate_pagecache_range - unmap and remove pagecache that is hole-punched
  * @inode: inode


