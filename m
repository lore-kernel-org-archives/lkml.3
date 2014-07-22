Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933446AbaGVW0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:26:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbaGVW0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:26:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 023/116] reiserfs: call truncate_setsize under tailpack mutex
Date: Tue, 22 Jul 2014 15:20:34 -0700
Message-Id: <1406067727-19683-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/reiserfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ca71b1f..0c1e96e 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3210,8 +3210,14 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
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

