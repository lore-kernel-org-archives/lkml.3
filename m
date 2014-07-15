Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914AbaGOVhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:37:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54642 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbaGOVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 045/198] reiserfs: call truncate_setsize under tailpack mutex
Date: Tue, 15 Jul 2014 14:28:35 -0700
Message-Id: <1405459868-15089-46-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
index ad62bdb..1e4cf9d 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3220,8 +3220,14 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
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

