Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaAWSrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:47:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaAWSjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3.10 10/23] writeback: Fix data corruption on NFS
Date: Thu, 23 Jan 2014 10:39:43 -0800
Message-Id: <20140123183901.305366437@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
References: <20140123183859.635713053@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -505,13 +505,16 @@ writeback_single_inode(struct inode *ino
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


