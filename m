Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbaKMV30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:29:26 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43965 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418AbaKMV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:29:21 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/56] fs/bad_inode: support compiling out splice
Date: Thu, 13 Nov 2014 22:22:46 +0100
Message-Id: <1415913813-362-10-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from bad_inode when the splice-family of syscalls is
not supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

add/remove: 0/2 grow/shrink: 0/0 up/down: 0/-12 (-12)
function                                     old     new   delta
bad_file_splice_write                          6       -      -6
bad_file_splice_read                           6       -      -6

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/bad_inode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index afd2b44..ccb076d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -131,14 +131,16 @@ static int bad_file_flock(struct file *filp, int cmd, struct file_lock *fl)
 	return -EIO;
 }
 
-static ssize_t bad_file_splice_write(struct pipe_inode_info *pipe,
+static ssize_t __maybe_unused bad_file_splice_write(
+			struct pipe_inode_info *pipe,
 			struct file *out, loff_t *ppos, size_t len,
 			unsigned int flags)
 {
 	return -EIO;
 }
 
-static ssize_t bad_file_splice_read(struct file *in, loff_t *ppos,
+static ssize_t __maybe_unused bad_file_splice_read(
+			struct file *in, loff_t *ppos,
 			struct pipe_inode_info *pipe, size_t len,
 			unsigned int flags)
 {
@@ -168,8 +170,8 @@ static const struct file_operations bad_file_ops =
 	.get_unmapped_area = bad_file_get_unmapped_area,
 	.check_flags	= bad_file_check_flags,
 	.flock		= bad_file_flock,
-	.splice_write	= bad_file_splice_write,
-	.splice_read	= bad_file_splice_read,
+	SPLICE_WRITE_INIT(bad_file_splice_write)
+	SPLICE_READ_INIT(bad_file_splice_read)
 };
 
 static int bad_inode_create (struct inode *dir, struct dentry *dentry,
-- 
1.9.1

