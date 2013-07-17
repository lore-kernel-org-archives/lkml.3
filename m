Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515Ab3GQW40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707Ab3GQW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 070/145] ext3: fix data=journal fast mount/umount hang
Date: Wed, 17 Jul 2013 15:46:42 -0700
Message-Id: <1374101277-7915-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e643692138cfa33528f054b071ba2583509bb217 upstream.

In data=journal mode, if we unmount the file system before a
transaction has a chance to complete, when the journal inode is being
evicted, we can end up calling into log_wait_commit() for the
last transaction, after the journalling machinery has been shut down.
That triggers the WARN_ONCE in __log_start_commit().

Arguably we should adjust ext3_should_journal_data() to return FALSE
for the journal inode, but the only place it matters is
ext3_evict_inode(), and so it's to save a bit of CPU time, and to make
the patch much more obviously correct by inspection(tm), we'll fix it
by explicitly not trying to waiting for a journal commit when we are
evicting the journal inode, since it's guaranteed to never succeed in
this case.

This can be easily replicated via:

     mount -t ext3 -o data=journal /dev/vdb /vdb ; umount /vdb

This is a port of ext4 fix from Ted Ts'o.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext3/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b176d42..f790d6e 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -218,7 +218,8 @@ void ext3_evict_inode (struct inode *inode)
 	 */
 	if (inode->i_nlink && ext3_should_journal_data(inode) &&
 	    EXT3_SB(inode->i_sb)->s_journal &&
-	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode))) {
+	    (S_ISLNK(inode->i_mode) || S_ISREG(inode->i_mode)) &&
+	    inode->i_ino != EXT3_JOURNAL_INO) {
 		tid_t commit_tid = atomic_read(&ei->i_datasync_tid);
 		journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 
-- 
1.8.1.2

