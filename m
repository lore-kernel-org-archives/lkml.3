Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3LDOGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:06:45 -0500
Received: from mail-qe0-f47.google.com ([209.85.128.47]:61651 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433Ab3LDOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:06:44 -0500
Date: Wed, 4 Dec 2013 09:06:39 -0500
From: Tejun Heo <tj@kernel.org>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: [PATCH driver-core-linus] sysfs: bail early from sysfs_bin_mmap() to
 avoid spurious lockdep warning
Message-ID: <20131204140639.GI3158@htj.dyndns.org>
References: <20131128051223.45739660885@gitolite.kernel.org>
 <20131203184324.GA11320@redhat.com>
 <20131203211028.GN8277@htj.dyndns.org>
 <20131203211515.GA17951@redhat.com>
 <20131203213649.GO8277@htj.dyndns.org>
 <20131203221543.GP8277@htj.dyndns.org>
 <20131204044306.GA13248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204044306.GA13248@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This can be fixed by either giving sysfs_open_file->mutex different
lockdep keys depending on whether the file is regular or bin instead
of whether mmap exists or not, or avoiding grabbing
sysfs_open_file->mutex from sysfs_bin_mmap() if mmap is not actually
implemented.  While the former is simpler for driver-core-linus,
driver-core-next already has SYSFS_FLAG_HAS_MMAP in place to implement
the latter and doesn't have inherent distinction between regular and
bin files.  This patch implements the latter so that the fix is more
conducive to driver-core-next.

Because anything beyond sysfs_open_file->sd can't be dereferenced
without locking the open file, cache whether mmap is implemented or
not in sysfs_open_file->sd->s_flags and update sysfs_bin_mmap() test
the flag and bail without grabbing the mutex if not implemented.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Dave Jones <davej@redhat.com>
Link: http://lkml.kernel.org/g/20131203184324.GA11320@redhat.com
---
 fs/sysfs/file.c  |   21 ++++++++++++++++++---
 fs/sysfs/sysfs.h |    1 +
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b94f936..90e9e5d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -470,6 +470,16 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 	struct kobject *kobj = of->sd->s_parent->s_dir.kobj;
 	int rc;
 
+	/*
+	 * mmap path and of->mutex are prone to triggering spurious lockdep
+	 * warnings and we don't want to add spurious locking dependency
+	 * between the two.  Check whether mmap is actually implemented
+	 * without grabbing @of->mutex by testing HAS_MMAP flag.  See the
+	 * comment in sysfs_open_file() for more details.
+	 */
+	if (!(of->sd->s_flags & SYSFS_FLAG_HAS_MMAP))
+		return -ENODEV;
+
 	mutex_lock(&of->mutex);
 
 	/* need of->sd for battr, its parent for kobj */
@@ -477,9 +487,6 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!sysfs_get_active(of->sd))
 		goto out_unlock;
 
-	if (!battr->mmap)
-		goto out_put;
-
 	rc = battr->mmap(file, kobj, battr, vma);
 	if (rc)
 		goto out_put;
@@ -851,6 +858,14 @@ int sysfs_add_file_mode_ns(struct sysfs_dirent *dir_sd,
 	sd->s_attr.attr = (void *)attr;
 	sysfs_dirent_init_lockdep(sd);
 
+	if (type == SYSFS_KOBJ_BIN_ATTR) {
+		const struct bin_attribute *battr =
+			container_of(attr, struct bin_attribute, attr);
+
+		if (battr->mmap)
+			sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
+	}
+
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, sd, dir_sd);
 	sysfs_addrm_finish(&acxt);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 0af09fb..27c1f7e 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -96,6 +96,7 @@ struct sysfs_dirent {
 
 #define SYSFS_FLAG_MASK			~(SYSFS_NS_TYPE_MASK|SYSFS_TYPE_MASK)
 #define SYSFS_FLAG_REMOVED		0x02000
+#define SYSFS_FLAG_HAS_MMAP		0x04000
 
 static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 {
