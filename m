Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaJLQU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:20:29 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:39874 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaJLQUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:20:23 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ebiggers3@gmail.com
Subject: [PATCH] kernel/groups.c: Code simplifications
Date: Sun, 12 Oct 2014 11:20:10 -0500
Message-Id: <1413130810-28144-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce nesting and simplify the control flow, remove redundant
'gidsetsize < 0' check in sys_getgroups(), and inline groups_to_user().

This patch reduces the length of kernel/groups.c by 27 lines.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 kernel/groups.c | 69 ++++++++++++++++++---------------------------------------
 1 file changed, 21 insertions(+), 48 deletions(-)

diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f..fae9d11 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -62,23 +62,6 @@ void groups_free(struct group_info *group_info)
 
 EXPORT_SYMBOL(groups_free);
 
-/* export the group_info to a user-space array */
-static int groups_to_user(gid_t __user *grouplist,
-			  const struct group_info *group_info)
-{
-	struct user_namespace *user_ns = current_user_ns();
-	int i;
-	unsigned int count = group_info->ngroups;
-
-	for (i = 0; i < count; i++) {
-		gid_t gid;
-		gid = from_kgid_munged(user_ns, GROUP_AT(group_info, i));
-		if (put_user(gid, grouplist+i))
-			return -EFAULT;
-	}
-	return 0;
-}
-
 /* fill a group_info from a user-space array - it must be allocated already */
 static int groups_from_user(struct group_info *group_info,
     gid_t __user *grouplist)
@@ -191,26 +174,23 @@ EXPORT_SYMBOL(set_current_groups);
 
 SYSCALL_DEFINE2(getgroups, int, gidsetsize, gid_t __user *, grouplist)
 {
-	const struct cred *cred = current_cred();
+	/* no need to grab task_lock here; our group_info cannot change */
+	const struct group_info *group_info = current_cred()->group_info;
+	int ngroups = group_info->ngroups;
+	struct user_namespace *user_ns = current_user_ns();
 	int i;
+	gid_t gid;
 
-	if (gidsetsize < 0)
+	if (!gidsetsize)
+		return ngroups;
+	if (gidsetsize < ngroups)
 		return -EINVAL;
-
-	/* no need to grab task_lock here; it cannot change */
-	i = cred->group_info->ngroups;
-	if (gidsetsize) {
-		if (i > gidsetsize) {
-			i = -EINVAL;
-			goto out;
-		}
-		if (groups_to_user(grouplist, cred->group_info)) {
-			i = -EFAULT;
-			goto out;
-		}
+	for (i = 0; i < ngroups; i++) {
+		gid = from_kgid_munged(user_ns, GROUP_AT(group_info, i));
+		if (put_user(gid, grouplist + i))
+			return -EFAULT;
 	}
-out:
-	return i;
+	return ngroups;
 }
 
 /*
@@ -232,14 +212,9 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	if (!group_info)
 		return -ENOMEM;
 	retval = groups_from_user(group_info, grouplist);
-	if (retval) {
-		put_group_info(group_info);
-		return retval;
-	}
-
-	retval = set_current_groups(group_info);
+	if (!retval)
+		retval = set_current_groups(group_info);
 	put_group_info(group_info);
-
 	return retval;
 }
 
@@ -249,11 +224,10 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 int in_group_p(kgid_t grp)
 {
 	const struct cred *cred = current_cred();
-	int retval = 1;
 
-	if (!gid_eq(grp, cred->fsgid))
-		retval = groups_search(cred->group_info, grp);
-	return retval;
+	if (gid_eq(grp, cred->fsgid))
+		return 1;
+	return groups_search(cred->group_info, grp);
 }
 
 EXPORT_SYMBOL(in_group_p);
@@ -261,11 +235,10 @@ EXPORT_SYMBOL(in_group_p);
 int in_egroup_p(kgid_t grp)
 {
 	const struct cred *cred = current_cred();
-	int retval = 1;
 
-	if (!gid_eq(grp, cred->egid))
-		retval = groups_search(cred->group_info, grp);
-	return retval;
+	if (gid_eq(grp, cred->egid))
+		return 1;
+	return groups_search(cred->group_info, grp);
 }
 
 EXPORT_SYMBOL(in_egroup_p);
-- 
2.1.2

