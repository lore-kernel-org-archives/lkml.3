Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3LJOuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:50:16 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63855 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3LJOuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:50:10 -0500
Date: Tue, 10 Dec 2013 09:50:04 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: [PATCH driver-core-next] sysfs: bail early from kernfs_file_mmap()
 to avoid spurious lockdep warning
Message-ID: <20131210145004.GA4610@htj.dyndns.org>
References: <20131209144712.57a50d7ed468ae8a4d57a0bf@canb.auug.org.au>
 <20131209082152.GA26809@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209082152.GA26809@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yeap, I was planning to send this out earlier but was completely
passed out yesterday after the first snowboarding in over a decade. :)

The offending commit a8b14744429f isn't applicable to
driver-core-next.  This was done this way because no matter what we
do, conflict is inevitable and keeping things minimal is the least
painful.  The following git branch pulls driver-core-linus into
driver-core-next, resolves the conflict by ignoring the offending
commit and applies this patch on top of it to implement the equivalent
fix.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git driver-core-fix-lockdep-class

For some reason, I can't reproduce the spurious lockdep warning Dave
is seeing so I'm not 100% sure but this is the same behavior as the
other patch that Dave tested in the original thread, so I'm relatively
sure this is the right fix.  This patch also adds comment to the
confusing if/else in the open path.

Greg, given that there will be more patches in driver-core-next, I
think it'll be best to pull driver-core-linus into driver-core-next to
avoid conflicts from the same commit.  You can pull my commit or if
you pull it yourself, just take all the chunks from driver-core-next
so that the resulting fs/sysfs/file.c is unchanged compared to
driver-core-next before pull, and then apply this patch.

Thanks.

------ 8< ------
>From 5cb9f29a28c87cbf62f74ff6bde3d9da2a565b1d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 10 Dec 2013 09:29:17 -0500

This is v3.14 fix for the same issue that a8b14744429f ("sysfs: give
different locking key to regular and bin files") addresses for v3.13.
Due to the extensive kernfs reorganization in v3.14 branch, the same
fix couldn't be ported as-is.  The v3.13 fix was ignored while merging
it into v3.14 branch.

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

For v3.13, a8b14744429f ("sysfs: give different locking key to regular
and bin files") fixed it by giving sysfs_open_file->mutex different
lockdep keys depending on whether the file is regular or bin instead
of whether mmap exists or not; however, due to the way sysfs is now
layered behind kernfs, this approach is no longer viable.  kernfs can
tell whether a sysfs node has mmap implemented or not but can't tell
whether a bin file from a regular one.

This patch updates kernfs such that kernfs_file_mmap() checks
SYSFS_FLAG_HAS_MMAP and bail before grabbing sysfs_open_file->mutex so
that it doesn't add spurious locking dependency from mmap to
sysfs_open_file->mutex and changes sysfs so that it specifies
kernfs_ops->mmap iff the sysfs file implements mmap.  Combined, this
ensures that sysfs_open_file->mutex is grabbed under mmap path iff the
sysfs file actually implements mmap.  As sysfs_open_file->mutex is
already given a different lockdep key if mmap is implemented, this
removes the spurious locking dependency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/g/20131203184324.GA11320@redhat.com
---
 fs/kernfs/file.c | 18 ++++++++++++++----
 fs/sysfs/file.c  | 12 ++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 4a5863b..fa05315 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -421,6 +421,16 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	const struct kernfs_ops *ops;
 	int rc;
 
+	/*
+	 * mmap path and of->mutex are prone to triggering spurious lockdep
+	 * warnings and we don't want to add spurious locking dependency
+	 * between the two.  Check whether mmap is actually implemented
+	 * without grabbing @of->mutex by testing HAS_MMAP flag.  See the
+	 * comment in kernfs_file_open() for more details.
+	 */
+	if (!(of->sd->s_flags & SYSFS_FLAG_HAS_MMAP))
+		return -ENODEV;
+
 	mutex_lock(&of->mutex);
 
 	rc = -ENODEV;
@@ -428,10 +438,7 @@ static int kernfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out_unlock;
 
 	ops = kernfs_ops(of->sd);
-	if (ops->mmap)
-		rc = ops->mmap(of, vma);
-	if (rc)
-		goto out_put;
+	rc = ops->mmap(of, vma);
 
 	/*
 	 * PowerPC's pci_mmap of legacy_mem uses shmem_zero_setup()
@@ -596,6 +603,9 @@ static int kernfs_file_open(struct inode *inode, struct file *file)
 	 * happen on the same file.  At this point, we can't easily give
 	 * each file a separate locking class.  Let's differentiate on
 	 * whether the file has mmap or not for now.
+	 *
+	 * Both paths of the branch look the same.  They're supposed to
+	 * look that way and give @of->mutex different static lockdep keys.
 	 */
 	if (has_mmap)
 		mutex_init(&of->mutex);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index ac77d2b..a67d1c6 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -142,9 +142,6 @@ static int sysfs_kf_bin_mmap(struct sysfs_open_file *of,
 	struct bin_attribute *battr = of->sd->priv;
 	struct kobject *kobj = of->sd->s_parent->priv;
 
-	if (!battr->mmap)
-		return -ENODEV;
-
 	return battr->mmap(of->file, kobj, battr, vma);
 }
 
@@ -197,6 +194,11 @@ static const struct kernfs_ops sysfs_bin_kfops_wo = {
 static const struct kernfs_ops sysfs_bin_kfops_rw = {
 	.read		= sysfs_kf_bin_read,
 	.write		= sysfs_kf_bin_write,
+};
+
+static const struct kernfs_ops sysfs_bin_kfops_mmap = {
+	.read		= sysfs_kf_bin_read,
+	.write		= sysfs_kf_bin_write,
 	.mmap		= sysfs_kf_bin_mmap,
 };
 
@@ -232,7 +234,9 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	} else {
 		struct bin_attribute *battr = (void *)attr;
 
-		if ((battr->read && battr->write) || battr->mmap)
+		if (battr->mmap)
+			ops = &sysfs_bin_kfops_mmap;
+		else if (battr->read && battr->write)
 			ops = &sysfs_bin_kfops_rw;
 		else if (battr->read)
 			ops = &sysfs_bin_kfops_ro;
-- 
1.8.4.2

