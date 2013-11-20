Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3KTCfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:35:48 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41563 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab3KTCfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:35:46 -0500
Message-ID: <1384914940.14597.2.camel@phoenix>
Subject: [PATCH] ramfs: nommu: Statize ramfs_nommu_get_unmapped_area and
 ramfs_nommu_mmap
From: Axel Lin <axel.lin@ingics.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 20 Nov 2013 10:35:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 853ac43ab194f "shmem: unify regular and tiny shmem",
ramfs_nommu_get_unmapped_area() and ramfs_nommu_mmap() are not directly
referenced outside of file-nommu.c. Thus make them static.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 fs/ramfs/file-nommu.c | 10 ++++++++--
 include/linux/ramfs.h |  7 -------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index f2487c3..9b831f7 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -27,6 +27,12 @@
 #include "internal.h"
 
 static int ramfs_nommu_setattr(struct dentry *, struct iattr *);
+static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
+						   unsigned long addr,
+						   unsigned long len,
+						   unsigned long pgoff,
+						   unsigned long flags);
+static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma);
 
 const struct address_space_operations ramfs_aops = {
 	.readpage		= simple_readpage,
@@ -197,7 +203,7 @@ static int ramfs_nommu_setattr(struct dentry *dentry, struct iattr *ia)
  *   - the pages to be mapped must exist
  *   - the pages be physically contiguous in sequence
  */
-unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
+static unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 					    unsigned long addr, unsigned long len,
 					    unsigned long pgoff, unsigned long flags)
 {
@@ -256,7 +262,7 @@ out:
 /*
  * set up a mapping for shared memory segments
  */
-int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
+static int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if (!(vma->vm_flags & VM_SHARED))
 		return -ENOSYS;
diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index 753207c..ecc7309 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -14,13 +14,6 @@ ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 }
 #else
 extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
-extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
-						   unsigned long addr,
-						   unsigned long len,
-						   unsigned long pgoff,
-						   unsigned long flags);
-
-extern int ramfs_nommu_mmap(struct file *file, struct vm_area_struct *vma);
 #endif
 
 extern const struct file_operations ramfs_file_operations;
-- 
1.8.1.2



