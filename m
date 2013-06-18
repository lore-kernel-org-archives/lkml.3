Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab3FRURV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:17:21 -0400
Received: from longford.logfs.org ([213.229.74.203]:59568 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab3FRURT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:17:19 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>
Subject: [PATCH 2/2] mmap: allow MAP_HUGETLB for hugetlbfs files
Date: Tue, 18 Jun 2013 14:47:05 -0400
Message-Id: <1371581225-27535-3-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371581225-27535-1-git-send-email-joern@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is counterintuitive at best that mmap'ing a hugetlbfs file with
MAP_HUGETLB fails, while mmap'ing it without will a) succeed and b)
return huge pages.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 mm/mmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2a594246..76eb6df 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -33,6 +33,7 @@
 #include <linux/uprobes.h>
 #include <linux/rbtree_augmented.h>
 #include <linux/sched/sysctl.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1313,6 +1314,11 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	return addr;
 }
 
+static inline int is_hugetlb_file(struct file *file)
+{
+	return file->f_inode->i_sb->s_magic == HUGETLBFS_MAGIC;
+}
+
 SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
 		unsigned long, fd, unsigned long, pgoff)
@@ -1322,11 +1328,12 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
 	if (!(flags & MAP_ANONYMOUS)) {
 		audit_mmap_fd(fd, flags);
-		if (unlikely(flags & MAP_HUGETLB))
-			return -EINVAL;
 		file = fget(fd);
 		if (!file)
 			goto out;
+		retval = -EINVAL;
+		if (unlikely(flags & MAP_HUGETLB && !is_hugetlb_file(file)))
+			goto out_fput;
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
 		/*
@@ -1346,6 +1353,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
 	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+out_fput:
 	if (file)
 		fput(file);
 out:
-- 
1.7.10.4

