Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaDSUzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 16:55:09 -0400
Received: from mout.gmx.net ([212.227.15.19]:56979 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaDSUzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 16:55:00 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] fanotify: check permissions when creating file descriptor
Date: Sat, 19 Apr 2014 22:53:53 +0200
Message-Id: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:5OWyVznTCNazjtHJKis/5CWpBxwEbaXHY+T9LjJRwYCWBuke8LL
 CyJ5KzuTQG3o0IFs+QsYgrwObbnZm2fRkcdQibtGlbMO/i+KKKF+J2lhXMCmr4SKoMjzjwG
 T6bYW2sDdtUUui8gSLZa+PiQ2hXVJ8hEjnIp2Kxjyiy+poaibEklYOyeIDMM2GKAufDw11F
 I88sX8Xf3XaGY1Y+xTbVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When monitoring a directory or a mount with the fanotify API
the call to fanotify_init checks,
 * the process has cap_sys_admin capability

The call to fanotify_mark checks,
 * the process has read authorization for directory or mount

A directory or mount may contain files for which the process
has no read or write authorization.
Yet when reading from the fanotify file descriptor, structures
fanotify_event_metadata are returned, which contain a file
descriptor for these files, and will allow to read or write.

The patch adds an authorization check for read and write
permission. In case of missing permission, reading from the
fanotify file descriptor returns EACCES.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/notify/fanotify/fanotify_user.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 4e565c8..5d22a20 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -62,6 +62,8 @@ static int create_fd(struct fsnotify_group *group,
 {
 	int client_fd;
 	struct file *new_file;
+	int mask;
+	int ret;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -75,11 +77,19 @@ static int create_fd(struct fsnotify_group *group,
 	 */
 	/* it's possible this event was an overflow event.  in that case dentry and mnt
 	 * are NULL;  That's fine, just don't call dentry open */
-	if (event->path.dentry && event->path.mnt)
-		new_file = dentry_open(&event->path,
-				       group->fanotify_data.f_flags | FMODE_NONOTIFY,
-				       current_cred());
-	else
+	if (event->path.dentry && event->path.mnt) {
+		/* check permissions before granting access to file */
+		mask = MAY_READ;
+		if (group->fanotify_data.f_flags & (O_RDWR | O_WRONLY))
+			mask |= MAY_WRITE;
+		ret = inode_permission(event->path.dentry->d_inode, mask);
+		if (ret)
+			new_file = ERR_PTR(ret);
+		else
+			new_file = dentry_open(&event->path,
+					       group->fanotify_data.f_flags | FMODE_NONOTIFY,
+					       current_cred());
+	} else
 		new_file = ERR_PTR(-EOVERFLOW);
 	if (IS_ERR(new_file)) {
 		/*
-- 
1.9.1

