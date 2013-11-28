Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626Ab3K1UB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 15:01:58 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:42272 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3K1TzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:55:11 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/34] sysfs, kernfs: remove sysfs_add_one()
Date: Thu, 28 Nov 2013 14:54:25 -0500
Message-Id: <1385668487-10181-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385668487-10181-1-git-send-email-tj@kernel.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_add_one() is a wrapper around __sysfs_add_one() which prints out
duplicate name warning if __sysfs_add_one() fails with -EEXIST.  The
previous kernfs conversions moved all dup warnings to sysfs interface
functions and sysfs_add_one() doesn't have any user left.

Remove sysfs_add_one() and update __sysfs_add_one() to take its name.

This patch doesn't make any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/sysfs/dir.c     | 41 ++++-------------------------------------
 fs/sysfs/file.c    |  2 +-
 fs/sysfs/symlink.c |  2 +-
 fs/sysfs/sysfs.h   |  2 --
 4 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index cfbf409..e88e9a9 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -395,7 +395,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
 }
 
 /**
- *	__sysfs_add_one - add sysfs_dirent to parent without warning
+ *	sysfs_add_one - add sysfs_dirent to parent without warning
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
  *	@parent_sd: the parent sysfs_dirent to add @sd to
@@ -415,8 +415,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-		    struct sysfs_dirent *parent_sd)
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
+		  struct sysfs_dirent *parent_sd)
 {
 	bool has_ns = parent_sd->s_flags & SYSFS_FLAG_NS;
 	struct sysfs_inode_attrs *ps_iattr;
@@ -488,39 +488,6 @@ void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name)
 }
 
 /**
- *	sysfs_add_one - add sysfs_dirent to parent
- *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be added
- *	@parent_sd: the parent sysfs_dirent to add @sd to
- *
- *	Get @parent_sd and set @sd->s_parent to it and increment nlink of
- *	the parent inode if @sd is a directory and link into the children
- *	list of the parent.
- *
- *	This function should be called between calls to
- *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
- *	passed the same @acxt as passed to sysfs_addrm_start().
- *
- *	LOCKING:
- *	Determined by sysfs_addrm_start().
- *
- *	RETURNS:
- *	0 on success, -EEXIST if entry with the given name already
- *	exists.
- */
-int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-		  struct sysfs_dirent *parent_sd)
-{
-	int ret;
-
-	ret = __sysfs_add_one(acxt, sd, parent_sd);
-
-	if (ret == -EEXIST)
-		sysfs_warn_dup(parent_sd, sd->s_name);
-	return ret;
-}
-
-/**
  *	sysfs_remove_one - remove sysfs_dirent from parent
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be removed
@@ -694,7 +661,7 @@ struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 
 	/* link in */
 	sysfs_addrm_start(&acxt);
-	rc = __sysfs_add_one(&acxt, sd, parent);
+	rc = sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (!rc)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 69cca0f..9852450 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -1007,7 +1007,7 @@ struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
 		sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
 
 	sysfs_addrm_start(&acxt);
-	rc = __sysfs_add_one(&acxt, sd, parent);
+	rc = sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc) {
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 352fbbb..76efeab 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -47,7 +47,7 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 	sysfs_get(target);	/* ref owned by symlink */
 
 	sysfs_addrm_start(&acxt);
-	error = __sysfs_add_one(&acxt, sd, parent);
+	error = sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (!error)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 28898fa..a6542d2 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -167,8 +167,6 @@ struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd);
 void sysfs_put_active(struct sysfs_dirent *sd);
 void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt);
 void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name);
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-		    struct sysfs_dirent *parent_sd);
 int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
 		  struct sysfs_dirent *parent_sd);
 void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt);
-- 
1.8.4.2

