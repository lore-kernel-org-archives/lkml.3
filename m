Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbaGHTrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:47:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755657AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        "Jeff Mahoney" <jeffm@suse.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.418956117@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 010/125] reiserfs: call truncate_setsize under
 tailpack mutex
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3211,8 +3211,14 @@ int reiserfs_setattr(struct dentry *dent
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
 

