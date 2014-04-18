Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaDRJtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45891 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 12/72] ext4: Speedup WB_SYNC_ALL pass called from sync(2)
Date: Fri, 18 Apr 2014 11:21:45 +0200
Message-Id: <3042adcc664cb8ec04af94c04ad00c87c94a8288.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 10542c229a4e8e25b40357beea66abe9dacda2c0 upstream.

When doing filesystem wide sync, there's no need to force transaction
commit (or synchronously write inode buffer) separately for each inode
because ext4_sync_fs() takes care of forcing commit at the end (VFS
takes care of flushing buffer cache, respectively). Most of the time
this slowness doesn't manifest because previous WB_SYNC_NONE writeback
doesn't leave much to write but when there are processes aggressively
creating new files and several filesystems to sync, the sync slowness
can be noticeable. In the following test script sync(1) takes around 6
minutes when there are two ext4 filesystems mounted on a standard SATA
drive. After this patch sync takes a couple of seconds so we have about
two orders of magnitude improvement.

      function run_writers
      {
        for (( i = 0; i < 10; i++ )); do
          mkdir $1/dir$i
          for (( j = 0; j < 40000; j++ )); do
            dd if=/dev/zero of=$1/dir$i/$j bs=4k count=4 &>/dev/null
          done &
        done
      }

      for dir in "$@"; do
        run_writers $dir
      done

      sleep 40
      time sync

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 786bf0708904..f173ef12c97a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4447,7 +4447,12 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 			return -EIO;
 		}
 
-		if (wbc->sync_mode != WB_SYNC_ALL)
+		/*
+		 * No need to force transaction in WB_SYNC_NONE mode. Also
+		 * ext4_sync_fs() will force the commit after everything is
+		 * written.
+		 */
+		if (wbc->sync_mode != WB_SYNC_ALL || wbc->for_sync)
 			return 0;
 
 		err = ext4_force_commit(inode->i_sb);
@@ -4457,7 +4462,11 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 		err = __ext4_get_inode_loc(inode, &iloc, 0);
 		if (err)
 			return err;
-		if (wbc->sync_mode == WB_SYNC_ALL)
+		/*
+		 * sync(2) will flush the whole buffer cache. No need to do
+		 * it here separately for each inode.
+		 */
+		if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
 			sync_dirty_buffer(iloc.bh);
 		if (buffer_req(iloc.bh) && !buffer_uptodate(iloc.bh)) {
 			EXT4_ERROR_INODE_BLOCK(inode, iloc.bh->b_blocknr,
-- 
1.9.2

