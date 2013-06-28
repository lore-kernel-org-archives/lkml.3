Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3F1S4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41786 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3F1S4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 019/105] reiserfs: fix deadlock with nfs racing on create/lookup
Date: Fri, 28 Jun 2013 11:50:41 -0700
Message-Id: <1372445527-24414-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit a1457c0ce976bad1356b9b0437f2a5c3ab8a9cfc upstream.

Reiserfs is currently able to be deadlocked by having two NFS clients
where one has removed and recreated a file and another is accessing the
file with an open file handle.

If one client deletes and recreates a file with timing such that the
recreated file obtains the same [dirid, objectid] pair as the original
file while another client accesses the file via file handle, the create
and lookup can race and deadlock if the lookup manages to create the
in-memory inode first.

The create thread, in insert_inode_locked4, will hold the write lock
while waiting on the other inode to be unlocked. The lookup thread,
anywhere in the iget path, will release and reacquire the write lock while
it schedules. If it needs to reacquire the lock while the create thread
has it, it will never be able to make forward progress because it needs
to reacquire the lock before ultimately unlocking the inode.

This patch drops the write lock across the insert_inode_locked4 call so
that the ordering of inode_wait -> write lock is retained. Since this
would have been the case before the BKL push-down, this is safe.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/reiserfs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 95d7680..ca71b1f 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1810,11 +1810,16 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 				  TYPE_STAT_DATA, SD_SIZE, MAX_US_INT);
 	memcpy(INODE_PKEY(inode), &(ih.ih_key), KEY_SIZE);
 	args.dirid = le32_to_cpu(ih.ih_key.k_dir_id);
-	if (insert_inode_locked4(inode, args.objectid,
-			     reiserfs_find_actor, &args) < 0) {
+
+	reiserfs_write_unlock(inode->i_sb);
+	err = insert_inode_locked4(inode, args.objectid,
+			     reiserfs_find_actor, &args);
+	reiserfs_write_lock(inode->i_sb);
+	if (err) {
 		err = -EINVAL;
 		goto out_bad_inode;
 	}
+
 	if (old_format_only(sb))
 		/* not a perfect generation count, as object ids can be reused, but
 		 ** this is as good as reiserfs can do right now.
-- 
1.8.1.2

