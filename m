Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3LDOUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:20:45 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:63825 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LDOUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:20:44 -0500
Date: Wed, 4 Dec 2013 09:20:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: [PATCH driver-core-linus] sysfs: give different locking key to
 regular and bin files
Message-ID: <20131204142040.GK3158@htj.dyndns.org>
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
 <20131203211515.GA17951@redhat.com>
 <20131203213649.GO8277@htj.dyndns.org>
 <20131203221543.GP8277@htj.dyndns.org>
 <20131204044306.GA13248@redhat.com>
 <20131204140639.GI3158@htj.dyndns.org>
 <20131204141345.GJ3158@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204141345.GJ3158@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, can you please test this one too?  Greg, once this turns out to
be okay, I'll send you a merged branch which pulls in
driver-core-linus + this patch into driver-core-next which will surely
generate conflict.

Thanks.
----- 8< ------
027a485d12e0 ("sysfs: use a separate locking class for open files
depending on mmap") assigned different lockdep key to
sysfs_open_file->mutex depending on whether the file implements mmap
or not in an attempt to avoid spurious lockdep warning caused by
merging of regular and bin file paths.

While this restored some of the original behavior of using different
locks (at least lockdep is concerned) for the different clases of
files.  The restoration wasn't full because now the lockdep key
assignment depends on whether the file has mmap or not instead of
whether it's a regular file or not.

This means that bin files which don't implement mmap will get assigned
the same lockdep class as regular files.  This is problematic because
file_operations for bin files still implements the mmap file operation
and checking whether the sysfs file actually implements mmap happens
in the file operation after grabbing @sysfs_open_file->mutex.  We
still end up adding locking dependency from mmap locking to
sysfs_open_file->mutex to the regular file mutex which triggers
spurious circular locking warning.

Fix it by restoring the original behavior fully by differentiating
lockdep key by whether the file is regular or bin, instead of the
existence of mmap.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/g/20131203184324.GA11320@redhat.com
---
 fs/sysfs/file.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b94f936..35e7d08 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -609,7 +609,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_open_file *of;
-	bool has_read, has_write, has_mmap;
+	bool has_read, has_write;
 	int error = -EACCES;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
@@ -621,7 +621,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 
 		has_read = battr->read || battr->mmap;
 		has_write = battr->write || battr->mmap;
-		has_mmap = battr->mmap;
 	} else {
 		const struct sysfs_ops *ops = sysfs_file_ops(attr_sd);
 
@@ -633,7 +632,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 
 		has_read = ops->show;
 		has_write = ops->store;
-		has_mmap = false;
 	}
 
 	/* check perms and supported operations */
@@ -661,9 +659,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 * open file has a separate mutex, it's okay as long as those don't
 	 * happen on the same file.  At this point, we can't easily give
 	 * each file a separate locking class.  Let's differentiate on
-	 * whether the file has mmap or not for now.
+	 * whether the file is bin or not for now.
 	 */
-	if (has_mmap)
+	if (sysfs_is_bin(attr_sd))
 		mutex_init(&of->mutex);
 	else
 		mutex_init(&of->mutex);
