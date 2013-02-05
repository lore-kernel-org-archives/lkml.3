Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab3BEWLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab3BEWLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 65/93] xfs: Fix possible use-after-free with AIO
Date: Tue,  5 Feb 2013 20:06:54 -0200
Message-Id: <1360102042-10732-66-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 4b05d09c18d9aa62d2e7fb4b057f54e5a38963f5 upstream.

Running AIO is pinning inode in memory using file reference. Once AIO
is completed using aio_complete(), file reference is put and inode can
be freed from memory. So we have to be sure that calling aio_complete()
is the last thing we do with the inode.

CC: xfs@oss.sgi.com
CC: Ben Myers <bpm@sgi.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/xfs/xfs_aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8dad722..6868548 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -86,11 +86,11 @@ xfs_destroy_ioend(
 	}
 
 	if (ioend->io_iocb) {
+		inode_dio_done(ioend->io_inode);
 		if (ioend->io_isasync) {
 			aio_complete(ioend->io_iocb, ioend->io_error ?
 					ioend->io_error : ioend->io_result, 0);
 		}
-		inode_dio_done(ioend->io_inode);
 	}
 
 	mempool_free(ioend, xfs_ioend_pool);
-- 
1.7.9.5

