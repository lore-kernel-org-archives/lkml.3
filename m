Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaBPPcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 10:32:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50071 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaBPPcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 10:32:32 -0500
Date: Sun, 16 Feb 2014 23:31:07 +0800
From: Wang YanQing <udknight@gmail.com>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/groups.c: remove return value of set_groups
Message-ID: <20140216153107.GA3622@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	akpm@linux-foundation.org, ebiederm@xmission.com,
	serge.hallyn@canonical.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 6307f8fee295b364716d28686df6e69c2fee751a
("security: remove dead hook task_setgroups"), set_groups
will always return zero, so we could just remove return
value of set_groups.

This patch reduce code size, and simplfy code logician
to use set_groups, because we don't need to check its
return value anymore.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 I can't find out the maintainer of kernel/group.c,
 so... I hope I haven't send and cc to the wrong people :)
 fs/nfsd/auth.c       |  5 +----
 include/linux/cred.h |  2 +-
 kernel/groups.c      | 11 ++---------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 06cddd5..2645be4 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -71,10 +71,8 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 	if (gid_eq(new->fsgid, INVALID_GID))
 		new->fsgid = exp->ex_anon_gid;
 
-	ret = set_groups(new, gi);
+	set_groups(new, gi);
 	put_group_info(gi);
-	if (ret < 0)
-		goto error;
 
 	if (!uid_eq(new->fsuid, GLOBAL_ROOT_UID))
 		new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
@@ -89,7 +87,6 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 
 oom:
 	ret = -ENOMEM;
-error:
 	abort_creds(new);
 	return ret;
 }
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..f61d6c8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -66,7 +66,7 @@ extern struct group_info *groups_alloc(int);
 extern struct group_info init_groups;
 extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
-extern int set_groups(struct cred *, struct group_info *);
+extern void set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
 
 /* access the groups "array" with this macro */
diff --git a/kernel/groups.c b/kernel/groups.c
index 90cf1c3..1ccdd28 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -161,13 +161,12 @@ int groups_search(const struct group_info *group_info, kgid_t grp)
  * Validate a group subscription and, if valid, insert it into a set
  * of credentials.
  */
-int set_groups(struct cred *new, struct group_info *group_info)
+void set_groups(struct cred *new, struct group_info *group_info)
 {
 	put_group_info(new->group_info);
 	groups_sort(group_info);
 	get_group_info(group_info);
 	new->group_info = group_info;
-	return 0;
 }
 
 EXPORT_SYMBOL(set_groups);
@@ -182,18 +181,12 @@ EXPORT_SYMBOL(set_groups);
 int set_current_groups(struct group_info *group_info)
 {
 	struct cred *new;
-	int ret;
 
 	new = prepare_creds();
 	if (!new)
 		return -ENOMEM;
 
-	ret = set_groups(new, group_info);
-	if (ret < 0) {
-		abort_creds(new);
-		return ret;
-	}
-
+	set_groups(new, group_info);
 	return commit_creds(new);
 }
 
-- 
1.8.3.4.8.g69490f3.dirty
