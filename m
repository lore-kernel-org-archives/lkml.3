Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab3FEVpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:45:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933043Ab3FEVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 095/127] reiserfs: fix deadlock with nfs racing on create/lookup
Date: Wed,  5 Jun 2013 14:34:22 -0700
Message-Id: <20130605213228.769499918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/inode.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1810,11 +1810,16 @@ int reiserfs_new_inode(struct reiserfs_t
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


