Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbbALSO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:14:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbbALSGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 090/216] groups: Consolidate the setgroups permission checks
Date: Mon, 12 Jan 2015 18:03:27 +0000
Message-Id: <1421085933-32536-91-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kernel/compat_linux.c | 2 +-
 include/linux/cred.h            | 1 +
 kernel/groups.c                 | 9 ++++++++-
 kernel/uid16.c                  | 2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index ca38139423ae..437e61159279 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -249,7 +249,7 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
 	struct group_info *group_info;
 	int retval;
 
-	if (!capable(CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index f61d6c8f5ef3..e88316355c66 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -68,6 +68,7 @@ extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
 extern void set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
+extern bool may_setgroups(void);
 
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f86cfa..02d8a251c476 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -213,6 +213,13 @@ out:
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
@@ -223,7 +230,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bbbceff..d58cc4d8f0d1 100644
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
2.1.4

