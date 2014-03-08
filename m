Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbaCHBIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:08:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385AbaCHBHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 62/99] ext4: fix possible use-after-free with AIO
Date: Fri,  7 Mar 2014 17:07:58 -0800
Message-Id: <20140308010613.585618263@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c   |    2 +-
 fs/ext4/page-io.c |    9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2800,9 +2800,9 @@ static void ext4_end_io_dio(struct kiocb
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
 out:
+		inode_dio_done(inode);
 		if (is_async)
 			aio_complete(iocb, ret, 0);
-		inode_dio_done(inode);
 		return;
 	}
 
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -107,14 +107,13 @@ int ext4_end_io_nolock(ext4_io_end_t *io
 			 inode->i_ino, offset, size, ret);
 	}
 
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
 


