Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab3CTMyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:54:11 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:38816 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab3CTMx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:53:56 -0400
From: Tal Tchwella <tal.tchwella@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tchwella@mit.edu
Subject: [PATCH 3/3] open fds check when starting chroot
Date: Wed, 20 Mar 2013 05:53:45 -0700
Message-Id: <1363784025-23870-4-git-send-email-tchwella@mit.edu>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363784025-23870-1-git-send-email-tchwella@mit.edu>
References: <1363784025-23870-1-git-send-email-tchwella@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks for open fds to directories when a non-root user tries to chroot,
and does not allow that user to chroot if the application has an open fd to a directory
because the appilcation has an escape path with that fd.

Signed-off-by: Tal Tchwella <tchwella@mit.edu>
---
 fs/open.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index 82832d8..6dc6443 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -426,6 +426,30 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
 {
 	struct path path;
 	int error;
+	struct files_struct *current_files;
+	struct fdtable *files_table;
+	int i = 0;
+
+	error = -EPERM;
+	/*
+	 * Checks to see if there are open file descriptors to directories
+	 * when a user that does not have the chroot capability
+	 * tries to chroot. Since chroot is availble to all users,
+	 * want to eliminate ways to break out. The second part
+	 * of the if statement, is true by default,
+	 * since during the initilization of the kernel, it
+	 * goes into chroot mode.
+	 */
+	if (!capable(CAP_SYS_CHROOT) && current->user_chroot != CHROOT_INIT) {
+		current_files = current->files;
+		files_table = files_fdtable(current_files);
+		while (files_table->fd[i] != NULL) {
+			if (S_ISDIR(files_table->fd[i]->
+				f_dentry->d_inode->i_mode))
+					 goto out;
+			i++;
+		}
+	}
 
 	error = user_path_dir(filename, &path);
 	if (error)
-- 
1.7.9.5

