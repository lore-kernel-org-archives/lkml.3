Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3CAAbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:31:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3CAAbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:31:13 -0500
Date: Thu, 28 Feb 2013 16:31:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] shmem: fix build regression
Message-Id: <20130228163111.5d61d391.akpm@linux-foundation.org>
In-Reply-To: <1362093459-24608-1-git-send-email-wsa@the-dreams.de>
References: <1362093459-24608-1-git-send-email-wsa@the-dreams.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Mar 2013 00:17:39 +0100
Wolfram Sang <wsa@the-dreams.de> wrote:

> commit 6b4d0b27 (clean shmem_file_setup() a bit) broke allnoconfig since
> this needs the NOMMU path where 'error' is still needed:
> 
> mm/shmem.c:2935:2: error: 'error' undeclared (first use in this function)
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  mm/shmem.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ed2befb..56ff7d7 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2897,6 +2897,7 @@ static struct dentry_operations anon_ops = {
>   */
>  struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
>  {
> +	int error;
>  	struct file *res;
>  	struct inode *inode;
>  	struct path path;

That will generate an unused-var warning on CONFIG_MMU=y.  We can
avoid that by doing

+	{
+		int error;
		...
+	}

or by reusing an existing local.

How's this?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem-fix-build-regression-fix

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ramfs.h |    8 +++++++-
 mm/shmem.c            |   12 ++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/shmem.c~shmem-fix-build-regression-fix mm/shmem.c
--- a/mm/shmem.c~shmem-fix-build-regression-fix
+++ a/mm/shmem.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
+#include <linux/ramfs.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/mm.h>
@@ -2830,8 +2831,6 @@ out4:
  * effectively equivalent, but much lighter weight.
  */
 
-#include <linux/ramfs.h>
-
 static struct file_system_type shmem_fs_type = {
 	.name		= "tmpfs",
 	.mount		= ramfs_mount,
@@ -2897,7 +2896,6 @@ static struct dentry_operations anon_ops
  */
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
 {
-	int error;
 	struct file *res;
 	struct inode *inode;
 	struct path path;
@@ -2932,12 +2930,10 @@ struct file *shmem_file_setup(const char
 	d_instantiate(path.dentry, inode);
 	inode->i_size = size;
 	clear_nlink(inode);	/* It is unlinked */
-#ifndef CONFIG_MMU
-	error = ramfs_nommu_expand_for_mapping(inode, size);
-	res = ERR_PTR(error);
-	if (error)
+
+	res = ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
+	if (IS_ERR(res))
 		goto put_dentry;
-#endif
 
 	res = alloc_file(&path, FMODE_WRITE | FMODE_READ,
 		  &shmem_file_operations);
diff -puN include/linux/ramfs.h~shmem-fix-build-regression-fix include/linux/ramfs.h
--- a/include/linux/ramfs.h~shmem-fix-build-regression-fix
+++ a/include/linux/ramfs.h
@@ -6,7 +6,13 @@ struct inode *ramfs_get_inode(struct sup
 extern struct dentry *ramfs_mount(struct file_system_type *fs_type,
 	 int flags, const char *dev_name, void *data);
 
-#ifndef CONFIG_MMU
+#ifdef CONFIG_MMU
+static inline int
+ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
+{
+	return 0;
+}
+#else
 extern int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize);
 extern unsigned long ramfs_nommu_get_unmapped_area(struct file *file,
 						   unsigned long addr,
_


