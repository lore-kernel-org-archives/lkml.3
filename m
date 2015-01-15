Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbbAOWOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:14:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 15/19] groups: Consolidate the setgroups permission checks
Date: Thu, 15 Jan 2015 14:09:51 -0800
Message-Id: <1421359795-11155-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 7ff4d90b4c24a03666f296c3d4878cd39001e81e upstream.

Today there are 3 instances of setgroups and due to an oversight their
permission checking has diverged.  Add a common function so that
they may all share the same permission checking code.

This corrects the current oversight in the current permission checks
and adds a helper to avoid this in the future.

A user namespace security fix will update this new helper, shortly.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kernel/compat_linux.c | 2 +-
 include/linux/cred.h            | 1 +
 kernel/groups.c                 | 9 ++++++++-
 kernel/uid16.c                  | 2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index e030d2b..b67da3b 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -245,7 +245,7 @@ asmlinkage long sys32_setgroups16(int gidsetsize, u16 __user *grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!capable(CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 04421e8..6c58dd7 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -68,6 +68,7 @@ extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
 extern int set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
+extern bool may_setgroups(void);
 
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
diff --git a/kernel/groups.c b/kernel/groups.c
index 90cf1c3..984bb62 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -223,6 +223,13 @@ out:
 	return i;
 }
 
+bool may_setgroups(void)
+{
+	struct user_namespace *user_ns = current_user_ns();
+
+	return ns_capable(user_ns, CAP_SETGID);
+}
+
 /*
  *	SMP: Our groups are copy-on-write. We can set them safely
  *	without another task interfering.
@@ -233,7 +240,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bb..d58cc4d 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -176,7 +176,7 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
-- 
1.9.1

