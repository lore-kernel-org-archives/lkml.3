Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaBGLsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41468 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaBGLsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 021/233] writeback: Fix data corruption on NFS
Date: Fri,  7 Feb 2014 11:44:00 +0000
Message-Id: <1391773652-25214-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit f9b0e058cbd04ada76b13afffa7e1df830543c24 upstream.

Commit 4f8ad655dbc8 "writeback: Refactor writeback_single_inode()" added
a condition to skip clean inode. However this is wrong in WB_SYNC_ALL
mode because there we also want to wait for outstanding writeback on
possibly clean inode. This was causing occasional data corruption issues
on NFS because it uses sync_inode() to make sure all outstanding writes
are flushed to the server before truncating the inode and with
sync_inode() returning prematurely file was sometimes extended back
by an outstanding write after it was truncated.

So modify the test to also check for pages under writeback in
WB_SYNC_ALL mode.

Fixes: 4f8ad655dbc82cf05d2edc11e66b78a42d38bf93
Reported-and-tested-by: Dan Duval <dan.duval@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fs-writeback.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 68851ff..52e5934 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -508,13 +508,16 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
 	}
 	WARN_ON(inode->i_state & I_SYNC);
 	/*
-	 * Skip inode if it is clean. We don't want to mess with writeback
-	 * lists in this function since flusher thread may be doing for example
-	 * sync in parallel and if we move the inode, it could get skipped. So
-	 * here we make sure inode is on some writeback list and leave it there
-	 * unless we have completely cleaned the inode.
+	 * Skip inode if it is clean and we have no outstanding writeback in
+	 * WB_SYNC_ALL mode. We don't want to mess with writeback lists in this
+	 * function since flusher thread may be doing for example sync in
+	 * parallel and if we move the inode, it could get skipped. So here we
+	 * make sure inode is on some writeback list and leave it there unless
+	 * we have completely cleaned the inode.
 	 */
-	if (!(inode->i_state & I_DIRTY))
+	if (!(inode->i_state & I_DIRTY) &&
+	    (wbc->sync_mode != WB_SYNC_ALL ||
+	     !mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK)))
 		goto out;
 	inode->i_state |= I_SYNC;
 	spin_unlock(&inode->i_lock);
-- 
1.8.3.2

