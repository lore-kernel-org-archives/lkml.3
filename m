Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaJLUq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:46:27 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:51760 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaJLUqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:46:24 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 2/5] fs/anon_inodes.c: Simplify control flow in anon_inode_getfd()
Date: Sun, 12 Oct 2014 15:42:39 -0500
Message-Id: <1413146562-18147-2-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
References: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/anon_inodes.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 1faff09..268153a 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -136,26 +136,20 @@ EXPORT_SYMBOL_GPL(anon_inode_getfile);
 int anon_inode_getfd(const char *name, const struct file_operations *fops,
 		     void *priv, int flags)
 {
-	int error, fd;
+	int fd;
 	struct file *file;
 
-	error = get_unused_fd_flags(flags);
-	if (error < 0)
-		return error;
-	fd = error;
+	fd = get_unused_fd_flags(flags);
+	if (fd < 0)
+		return fd;
 
 	file = anon_inode_getfile(name, fops, priv, flags);
 	if (IS_ERR(file)) {
-		error = PTR_ERR(file);
-		goto err_put_unused_fd;
+		put_unused_fd(fd);
+		return PTR_ERR(file);
 	}
 	fd_install(fd, file);
-
 	return fd;
-
-err_put_unused_fd:
-	put_unused_fd(fd);
-	return error;
 }
 EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
-- 
2.1.2

