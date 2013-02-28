Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab3B1PFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:05:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab3B1OtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 085/139] ext4: fix possible use-after-free with AIO
Date: Thu, 28 Feb 2013 14:43:55 +0000
Message-Id: <1362062689-2567-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 091e26dfc156aeb3b73bc5c5f277e433ad39331c upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/inode.c   |  2 +-
 fs/ext4/page-io.c | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 20b2687..0589bb2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2867,9 +2867,9 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
 out:
+		inode_dio_done(inode);
 		if (is_async)
 			aio_complete(iocb, ret, 0);
-		inode_dio_done(inode);
 		return;
 	}
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dcdeef1..7e04138 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -106,15 +106,13 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 			 "(inode %lu, offset %llu, size %zd, error %d)",
 			 inode->i_ino, offset, size, ret);
 	}
-
-	if (io->iocb)
-		aio_complete(io->iocb, io->result, 0);
-
-	if (io->flag & EXT4_IO_END_DIRECT)
-		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
 	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
 		wake_up_all(ext4_ioend_wq(io->inode));
+	if (io->flag & EXT4_IO_END_DIRECT)
+		inode_dio_done(inode);
+	if (io->iocb)
+		aio_complete(io->iocb, io->result, 0);
 	return ret;
 }
 
-- 
1.8.1.2

