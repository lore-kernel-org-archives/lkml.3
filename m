Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761744AbaGRNJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:09:05 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17421 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761723AbaGRNJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jan Kara <jack@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/170] reiserfs: call truncate_setsize under tailpack mutex
Date: Fri, 18 Jul 2014 14:10:54 +0200
Message-Id: <a4424b76ff576642a98409dd587631dd34891e62.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/reiserfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ad62bdbb451e..1e4cf9d73130 100644
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
2.0.0

