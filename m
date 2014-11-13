Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986AbaKMVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:30:49 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51898 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956AbaKMVak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:30:40 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com (moderated list:ORACLE CLUSTER FI...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 36/56] fs/ocfs2: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:13 +0100
Message-Id: <1415913813-362-37-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from ocfs2 when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/ocfs2/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2930e23..44b9605 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2430,6 +2430,7 @@ out_sems:
 	return ret;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t ocfs2_file_splice_read(struct file *in,
 				      loff_t *ppos,
 				      struct pipe_inode_info *pipe,
@@ -2459,6 +2460,7 @@ static ssize_t ocfs2_file_splice_read(struct file *in,
 bail:
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 				   struct iov_iter *to)
@@ -2629,8 +2631,8 @@ const struct file_operations ocfs2_fops = {
 #endif
 	.lock		= ocfs2_lock,
 	.flock		= ocfs2_flock,
-	.splice_read	= ocfs2_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(ocfs2_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.fallocate	= ocfs2_fallocate,
 };
 
@@ -2676,8 +2678,8 @@ const struct file_operations ocfs2_fops_no_plocks = {
 	.compat_ioctl   = ocfs2_compat_ioctl,
 #endif
 	.flock		= ocfs2_flock,
-	.splice_read	= ocfs2_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(ocfs2_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.fallocate	= ocfs2_fallocate,
 };
 
-- 
1.9.1

