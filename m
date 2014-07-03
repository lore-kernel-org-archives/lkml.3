Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030372AbaGCKPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:15:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51591 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbaGCJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 036/198] reiserfs: call truncate_setsize under tailpack mutex
Date: Thu,  3 Jul 2014 10:17:59 +0100
Message-Id: <1404379241-8590-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 22e7478ddbcb670e33fab72d0bbe7c394c3a2c84 upstream.

Prior to commit 0e4f6a791b1e (Fix reiserfs_file_release()), reiserfs
truncates serialized on i_mutex. They mostly still do, with the exception
of reiserfs_file_release. That blocks out other writers via the tailpack
mutex and the inode openers counter adjusted in reiserfs_file_open.

However, NFS will call reiserfs_setattr without having called ->open, so
we end up with a race when nfs is calling ->setattr while another
process is releasing the file. Ultimately, it triggers the
BUG_ON(inode->i_size != new_file_size) check in maybe_indirect_to_direct.

The solution is to pull the lock into reiserfs_setattr to encompass the
truncate_setsize call as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/reiserfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 0048cc16a6a8..9fa970e7b2cd 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3217,8 +3217,14 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_size != i_size_read(inode)) {
 		error = inode_newsize_ok(inode, attr->ia_size);
 		if (!error) {
+			/*
+			 * Could race against reiserfs_file_release
+			 * if called from NFS, so take tailpack mutex.
+			 */
+			mutex_lock(&REISERFS_I(inode)->tailpack);
 			truncate_setsize(inode, attr->ia_size);
-			reiserfs_vfs_truncate_file(inode);
+			reiserfs_truncate_file(inode, 1);
+			mutex_unlock(&REISERFS_I(inode)->tailpack);
 		}
 	}
 
-- 
1.9.1

