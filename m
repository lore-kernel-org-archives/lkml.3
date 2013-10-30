Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3J3LbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:31:25 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51799 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3J3La5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:30:57 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3/4] staging/lustre: remove cfs_get_environ and cfs_access_process_vm
Date: Wed, 30 Oct 2013 19:30:35 +0800
Message-Id: <1383132636-8952-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |  150 --------------------
 2 files changed, 151 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index de8e35b..1c49ef4 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -64,7 +64,6 @@ int    cfs_curproc_groups_nr(void);
 int current_is_32bit(void);
 #define current_pid()		(current->pid)
 #define current_comm()		(current->comm)
-int cfs_get_environ(const char *key, char *value, int *val_len);
 
 typedef __u32 cfs_cap_t;
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index ea9e949..007f197 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -152,156 +152,6 @@ int current_is_32bit(void)
 	return is_compat_task();
 }
 
-static int cfs_access_process_vm(struct task_struct *tsk, unsigned long addr,
-				 void *buf, int len, int write)
-{
-	/* Just copied from kernel for the kernels which doesn't
-	 * have access_process_vm() exported */
-	struct mm_struct *mm;
-	struct vm_area_struct *vma;
-	struct page *page;
-	void *old_buf = buf;
-
-	mm = get_task_mm(tsk);
-	if (!mm)
-		return 0;
-
-	down_read(&mm->mmap_sem);
-	/* ignore errors, just check how much was sucessfully transfered */
-	while (len) {
-		int bytes, rc, offset;
-		void *maddr;
-
-		rc = get_user_pages(tsk, mm, addr, 1,
-				     write, 1, &page, &vma);
-		if (rc <= 0)
-			break;
-
-		bytes = len;
-		offset = addr & (PAGE_SIZE-1);
-		if (bytes > PAGE_SIZE-offset)
-			bytes = PAGE_SIZE-offset;
-
-		maddr = kmap(page);
-		if (write) {
-			copy_to_user_page(vma, page, addr,
-					  maddr + offset, buf, bytes);
-			set_page_dirty_lock(page);
-		} else {
-			copy_from_user_page(vma, page, addr,
-					    buf, maddr + offset, bytes);
-		}
-		kunmap(page);
-		page_cache_release(page);
-		len -= bytes;
-		buf += bytes;
-		addr += bytes;
-	}
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-
-	return buf - old_buf;
-}
-
-/* Read the environment variable of current process specified by @key. */
-int cfs_get_environ(const char *key, char *value, int *val_len)
-{
-	struct mm_struct *mm;
-	char *buffer, *tmp_buf = NULL;
-	int buf_len = PAGE_CACHE_SIZE;
-	int key_len = strlen(key);
-	unsigned long addr;
-	int rc;
-
-	buffer = kmalloc(buf_len, GFP_USER);
-	if (!buffer)
-		return -ENOMEM;
-
-	mm = get_task_mm(current);
-	if (!mm) {
-		kfree(buffer);
-		return -EINVAL;
-	}
-
-	/* Avoid deadlocks on mmap_sem if called from sys_mmap_pgoff(),
-	 * which is already holding mmap_sem for writes.  If some other
-	 * thread gets the write lock in the meantime, this thread will
-	 * block, but at least it won't deadlock on itself.  LU-1735 */
-	if (down_read_trylock(&mm->mmap_sem) == 0)
-		return -EDEADLK;
-	up_read(&mm->mmap_sem);
-
-	addr = mm->env_start;
-	while (addr < mm->env_end) {
-		int this_len, retval, scan_len;
-		char *env_start, *env_end;
-
-		memset(buffer, 0, buf_len);
-
-		this_len = min_t(int, mm->env_end - addr, buf_len);
-		retval = cfs_access_process_vm(current, addr, buffer,
-					       this_len, 0);
-		if (retval != this_len)
-			break;
-
-		addr += retval;
-
-		/* Parse the buffer to find out the specified key/value pair.
-		 * The "key=value" entries are separated by '\0'. */
-		env_start = buffer;
-		scan_len = this_len;
-		while (scan_len) {
-			char *entry;
-			int entry_len;
-
-			env_end = memscan(env_start, '\0', scan_len);
-			LASSERT(env_end >= env_start &&
-				env_end <= env_start + scan_len);
-
-			/* The last entry of this buffer cross the buffer
-			 * boundary, reread it in next cycle. */
-			if (unlikely(env_end - env_start == scan_len)) {
-				/* This entry is too large to fit in buffer */
-				if (unlikely(scan_len == this_len)) {
-					CERROR("Too long env variable.\n");
-					GOTO(out, rc = -EINVAL);
-				}
-				addr -= scan_len;
-				break;
-			}
-
-			entry = env_start;
-			entry_len = env_end - env_start;
-
-			/* Key length + length of '=' */
-			if (entry_len > key_len + 1 &&
-			    !memcmp(entry, key, key_len)) {
-				entry += key_len + 1;
-				entry_len -= key_len + 1;
-				/* The 'value' buffer passed in is too small.*/
-				if (entry_len >= *val_len)
-					GOTO(out, rc = -EOVERFLOW);
-
-				memcpy(value, entry, entry_len);
-				*val_len = entry_len;
-				GOTO(out, rc = 0);
-			}
-
-			scan_len -= (env_end - env_start + 1);
-			env_start = env_end + 1;
-		}
-	}
-	GOTO(out, rc = -ENOENT);
-
-out:
-	mmput(mm);
-	kfree((void *)buffer);
-	if (tmp_buf)
-		kfree((void *)tmp_buf);
-	return rc;
-}
-EXPORT_SYMBOL(cfs_get_environ);
-
 EXPORT_SYMBOL(cfs_curproc_groups_nr);
 EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
-- 
1.7.9.5

