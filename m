Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478Ab3BNRaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:30:15 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39458 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752Ab3BNRaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:30:13 -0500
From: Justin Maggard <jmaggard10@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, LinoSanfilippo@gmx.de, tzvetanc@commtouch.com,
        Justin Maggard <jmaggard10@gmail.com>
Subject: [PATCH] fanotify: fix support of large files
Date: Thu, 14 Feb 2013 09:29:26 -0800
Message-Id: <1360862966-6376-1-git-send-email-jmaggard10@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opening a file of >2GB in an area of the filesystem that has been marked for
fanotify events currently results in an EOVERFLOW error.  This is particularly
problematic if you are using fanotify permissions checking, because it prevents
large files from being opened at all.  Fix this by setting the O_LARGEFILE flag
on the new file handle.

Signed-off-by: Justin Maggard <jmaggard10@gmail.com> 
---
 fs/notify/fanotify/fanotify_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9ff4a5e..ef02b3d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -64,6 +64,7 @@ static int create_fd(struct fsnotify_group *group,
 			struct file **file)
 {
 	int client_fd;
+	int f_flags;
 	struct file *new_file;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
@@ -82,12 +83,11 @@ static int create_fd(struct fsnotify_group *group,
 	 * we need a new file handle for the userspace program so it can read even if it was
 	 * originally opened O_WRONLY.
 	 */
+	f_flags = group->fanotify_data.f_flags | FMODE_NONOTIFY | O_LARGEFILE;
 	/* it's possible this event was an overflow event.  in that case dentry and mnt
 	 * are NULL;  That's fine, just don't call dentry open */
 	if (event->path.dentry && event->path.mnt)
-		new_file = dentry_open(&event->path,
-				       group->fanotify_data.f_flags | FMODE_NONOTIFY,
-				       current_cred());
+		new_file = dentry_open(&event->path, f_flags, current_cred());
 	else
 		new_file = ERR_PTR(-EOVERFLOW);
 	if (IS_ERR(new_file)) {
-- 
1.7.9.5

