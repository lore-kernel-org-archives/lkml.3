Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934619AbaKMVfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:35:03 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45755 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbaKMVbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:10 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 45/56] fs/xfs: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:22 +0100
Message-Id: <1415913813-362-46-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from xfs when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/xfs/xfs_file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 076b170..0357dfc 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -311,6 +311,7 @@ xfs_file_read_iter(
 	return ret;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 STATIC ssize_t
 xfs_file_splice_read(
 	struct file		*infilp,
@@ -342,6 +343,7 @@ xfs_file_splice_read(
 	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 /*
  * This routine is called to handle zeroing any space in the last block of the
@@ -1415,8 +1417,8 @@ const struct file_operations xfs_file_operations = {
 	.write		= new_sync_write,
 	.read_iter	= xfs_file_read_iter,
 	.write_iter	= xfs_file_write_iter,
-	.splice_read	= xfs_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(xfs_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.unlocked_ioctl	= xfs_file_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= xfs_file_compat_ioctl,
-- 
1.9.1

