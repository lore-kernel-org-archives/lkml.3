Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbbAGCmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:42:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbbAGCHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 34/52] groups: Consolidate the setgroups permission checks
Date: Tue,  6 Jan 2015 18:07:02 -0800
Message-Id: <20150107020600.662807565@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/compat_linux.c |    2 +-
 include/linux/cred.h            |    1 +
 kernel/groups.c                 |    9 ++++++++-
 kernel/uid16.c                  |    2 +-
 4 files changed, 11 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -245,7 +245,7 @@ asmlinkage long sys32_setgroups16(int gi
 	struct group_info *group_info;
 	int retval;
 
-	if (!capable(CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -68,6 +68,7 @@ extern void groups_free(struct group_inf
 extern int set_current_groups(struct group_info *);
 extern int set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
+extern bool may_setgroups(void);
 
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
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
@@ -233,7 +240,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsi
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -176,7 +176,7 @@ SYSCALL_DEFINE2(setgroups16, int, gidset
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;


