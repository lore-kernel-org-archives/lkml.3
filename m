Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbaBEVSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:18:13 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47856 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaBEUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 006/213] inotify: fix double free/corruption of stuct user
Date: Wed, 5 Feb 2014 14:59:21 -0500
Message-ID: <1391630568-49251-7-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d0de4dc584ec6aa3b26fffea320a8457827768fc upstream.

On an error path in inotify_init1 a normal user can trigger a double
free of struct user.  This is a regression introduced by a2ae4cc9a16e
("inotify: stop kernel memory leak on file creation failure").

We fix this by making sure that if a group exists the user reference is
dropped when the group is cleaned up.  We should not explictly drop the
reference on error and also drop the reference when the group is cleaned
up.

The new lifetime rules are that an inotify group lives from
inotify_new_group to the last fsnotify_put_group.  Since the struct user
and inotify_devs are directly tied to this lifetime they are only
changed/updated in those two locations.  We get rid of all special
casing of struct user or user->inotify_devs.

Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/notify/inotify/inotify_fsnotify.c |  1 +
 fs/notify/inotify/inotify_user.c     | 39 ++++++++++++------------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 5d3d2a782abc..29da76656b9c 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -150,6 +150,7 @@ static void inotify_free_group_priv(struct fsnotify_group *group)
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
+	atomic_dec(&group->inotify_data.user->inotify_devs);
 	free_uid(group->inotify_data.user);
 }
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 72f882552608..7b1a2c3e36c6 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -290,15 +290,12 @@ static int inotify_fasync(int fd, struct file *file, int on)
 static int inotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
-	struct user_struct *user = group->inotify_data.user;
 
 	fsnotify_clear_marks_by_group(group);
 
 	/* free this group, matching get was inotify_init->fsnotify_obtain_group */
 	fsnotify_put_group(group);
 
-	atomic_dec(&user->inotify_devs);
-
 	return 0;
 }
 
@@ -616,7 +613,7 @@ retry:
 	return ret;
 }
 
-static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsigned int max_events)
+static struct fsnotify_group *inotify_new_group(unsigned int max_events)
 {
 	struct fsnotify_group *group;
 	unsigned int grp_num;
@@ -632,8 +629,14 @@ static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsign
 	spin_lock_init(&group->inotify_data.idr_lock);
 	idr_init(&group->inotify_data.idr);
 	group->inotify_data.last_wd = 0;
-	group->inotify_data.user = user;
 	group->inotify_data.fa = NULL;
+	group->inotify_data.user = get_current_user();
+
+	if (atomic_inc_return(&group->inotify_data.user->inotify_devs) >
+	    inotify_max_user_instances) {
+		fsnotify_put_group(group);
+		return ERR_PTR(-EMFILE);
+	}
 
 	return group;
 }
@@ -643,7 +646,6 @@ static struct fsnotify_group *inotify_new_group(struct user_struct *user, unsign
 SYSCALL_DEFINE1(inotify_init1, int, flags)
 {
 	struct fsnotify_group *group;
-	struct user_struct *user;
 	int ret;
 
 	/* Check the IN_* constants for consistency.  */
@@ -653,31 +655,16 @@ SYSCALL_DEFINE1(inotify_init1, int, flags)
 	if (flags & ~(IN_CLOEXEC | IN_NONBLOCK))
 		return -EINVAL;
 
-	user = get_current_user();
-	if (unlikely(atomic_read(&user->inotify_devs) >=
-			inotify_max_user_instances)) {
-		ret = -EMFILE;
-		goto out_free_uid;
-	}
-
 	/* fsnotify_obtain_group took a reference to group, we put this when we kill the file in the end */
-	group = inotify_new_group(user, inotify_max_queued_events);
-	if (IS_ERR(group)) {
-		ret = PTR_ERR(group);
-		goto out_free_uid;
-	}
-
-	atomic_inc(&user->inotify_devs);
+	group = inotify_new_group(inotify_max_queued_events);
+	if (IS_ERR(group))
+		return PTR_ERR(group);
 
 	ret = anon_inode_getfd("inotify", &inotify_fops, group,
 				  O_RDONLY | flags);
-	if (ret >= 0)
-		return ret;
+	if (ret < 0)
+		fsnotify_put_group(group);
 
-	fsnotify_put_group(group);
-	atomic_dec(&user->inotify_devs);
-out_free_uid:
-	free_uid(user);
 	return ret;
 }
 
-- 
1.8.5.2

