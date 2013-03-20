Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3CTNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:09:58 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:50877 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3CTNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:09:15 -0400
From: tal.tchwella@gmail.com
To: linux-kernel@vger.kernel.org
Cc: tchwella@mit.edu
Subject: [PATCH 2/3] socket checks for uds fds transfer
Date: Wed, 20 Mar 2013 06:09:06 -0700
Message-Id: <1363784947-24060-3-git-send-email-tal.tchwella@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
References: <1363784947-24060-1-git-send-email-tal.tchwella@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tal Tchwella <tchwella@mit.edu>

This patch checks whether another user is trying to send a chrooted application by
a non-root user a fd to a directory, which will allow it to escape.
By preventing this kind of fd transfer to chrooted applications by non-root users,
certain security risks are mitigated.

Signed-off-by: Tal Tchwella <tchwella@mit.edu>
---
 net/core/scm.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/core/scm.c b/net/core/scm.c
index ff52ad0..e505528 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -282,6 +282,15 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 	for (i=0, cmfptr=(__force int __user *)CMSG_DATA(cm); i<fdmax;
 	     i++, cmfptr++)
 	{
+		/*
+		 * Restricts passing of fds via unix domain sockets to non-root
+		 * chrooted applications to files and does not allow directories
+		 * to be passed.
+		 */
+		if (current->user_chroot == CHROOT_USER_MODE) {
+			if (S_ISDIR(fp[i]->f_dentry->d_inode->i_mode))
+				continue;
+		}
 		int new_fd;
 		err = security_file_receive(fp[i]);
 		if (err)
-- 
1.7.9.5

