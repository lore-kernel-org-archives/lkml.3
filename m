Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3KCKBm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 05:01:42 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:55318 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3KCJxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:53:45 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/39] sysfs, kernfs: remove sysfs_add_one()
Date: Sun,  3 Nov 2013 04:52:57 -0500
Message-Id: <1383472398-17812-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383472398-17812-1-git-send-email-tj@kernel.org>
References: <1383472398-17812-1-git-send-email-tj@kernel.org>
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
index 27822a1..14693aa 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -406,7 +406,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
 }
 
 /**
- *	__sysfs_add_one - add sysfs_dirent to parent without warning
+ *	sysfs_add_one - add sysfs_dirent to parent without warning
  *	@acxt: addrm context to use
  *	@sd: sysfs_dirent to be added
  *	@parent_sd: the parent sysfs_dirent to add @sd to
@@ -426,8 +426,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt)
  *	0 on success, -EEXIST if entry with the given name already
  *	exists.
  */
-int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
-		    struct sysfs_dirent *parent_sd)
+int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd,
+		  struct sysfs_dirent *parent_sd)
 {
 	struct sysfs_inode_attrs *ps_iattr;
 	int ret;
@@ -491,39 +491,6 @@ void sysfs_warn_dup(struct sysfs_dirent *parent, const char *name)
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
@@ -689,7 +656,7 @@ struct sysfs_dirent *kernfs_create_dir_ns(struct sysfs_dirent *parent,
 
 	/* link in */
 	sysfs_addrm_start(&acxt);
-	rc = __sysfs_add_one(&acxt, sd, parent);
+	rc = sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (!rc)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 74d803f..1317dab 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -990,7 +990,7 @@ struct sysfs_dirent *kernfs_create_file_ns(struct sysfs_dirent *parent,
 		sd->s_flags |= SYSFS_FLAG_HAS_MMAP;
 
 	sysfs_addrm_start(&acxt);
-	rc = __sysfs_add_one(&acxt, sd, parent);
+	rc = sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (rc) {
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 82182e6..aad41a3 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -46,7 +46,7 @@ struct sysfs_dirent *kernfs_create_link(struct sysfs_dirent *parent,
 	sysfs_get(target);	/* ref owned by symlink */
 
 	sysfs_addrm_start(&acxt);
-	error = __sysfs_add_one(&acxt, sd, parent);
+	error = sysfs_add_one(&acxt, sd, parent);
 	sysfs_addrm_finish(&acxt);
 
 	if (!error)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index e227c9a..064e106 100644
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
1.8.3.1

