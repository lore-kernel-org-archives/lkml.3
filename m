Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3AaVud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:50:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab3AaVua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:50:30 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] fs: Don't call dio_cleanup() before submitting all bios
Date: Thu, 31 Jan 2013 22:49:52 +0100
Message-Id: <1359668994-13433-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1359668994-13433-1-git-send-email-jack@suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_blockdev_direct_IO() can call dio_cleanup() before submitting
all bios. This will be inconvenient for us because we need to keep
preallocated structure in sdio which we attach to bio on submit and
it is natural to cleanup unused allocation in dio_cleanup().

Since dio_cleanup() is called again after submitting the last bio it is
enough to just remove the first dio_cleanup() call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/direct-io.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index cf5b44b..3a430f3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1209,10 +1209,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 			((sdio.final_block_in_request - sdio.block_in_file) <<
 					blkbits);
 
-		if (retval) {
-			dio_cleanup(dio, &sdio);
+		if (retval)
 			break;
-		}
 	} /* end iovec loop */
 
 	if (retval == -ENOTBLK) {
-- 
1.7.1

