Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934665AbaKMVbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:31:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63803 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364AbaKMVba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:31:30 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 48/56] mm/shmem: support compiling out splice
Date: Thu, 13 Nov 2014 22:23:25 +0100
Message-Id: <1415913813-362-49-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile out splice support from shmem when the splice-family of syscalls is not
supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 mm/shmem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 0e5fb22..4fb78b3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1626,6 +1626,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return retval ? retval : error;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 				struct pipe_inode_info *pipe, size_t len,
 				unsigned int flags)
@@ -1739,6 +1740,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 	}
 	return error;
 }
+#endif /* #ifdef CONFIG_SYSCALL_SPLICE */
 
 /*
  * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
@@ -3088,8 +3090,8 @@ static const struct file_operations shmem_file_operations = {
 	.read_iter	= shmem_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.fsync		= noop_fsync,
-	.splice_read	= shmem_file_splice_read,
-	.splice_write	= iter_file_splice_write,
+	SPLICE_READ_INIT(shmem_file_splice_read)
+	SPLICE_WRITE_INIT(iter_file_splice_write)
 	.fallocate	= shmem_fallocate,
 #endif
 };
-- 
1.9.1

