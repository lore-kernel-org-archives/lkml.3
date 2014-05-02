Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaEBPuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:50:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaEBPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 118/151] reiserfs: fix race in readdir
Date: Fri,  2 May 2014 08:38:26 -0700
Message-Id: <1399045139-4531-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 01d8885785a60ae8f4c37b0ed75bdc96d0fc6a44 upstream.

jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-2)

The -ENOENT is due to readdir calling dir_emit on the same entry twice.

If the dir_emit callback sleeps and the tree is changed underneath us,
we won't be able to trust deh_offset(deh) anymore. We need to save
next_pos before we might sleep so we can find the next entry.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/reiserfs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 1fd2051..af67735 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -125,6 +125,7 @@ int reiserfs_readdir_inode(struct inode *inode, struct dir_context *ctx)
 				int d_reclen;
 				char *d_name;
 				ino_t d_ino;
+				loff_t cur_pos = deh_offset(deh);
 
 				if (!de_visible(deh))
 					/* it is hidden entry */
@@ -196,8 +197,9 @@ int reiserfs_readdir_inode(struct inode *inode, struct dir_context *ctx)
 				if (local_buf != small_buf) {
 					kfree(local_buf);
 				}
-				// next entry should be looked for with such offset
-				next_pos = deh_offset(deh) + 1;
+
+				/* deh_offset(deh) may be invalid now. */
+				next_pos = cur_pos + 1;
 
 				if (item_moved(&tmp_ih, &path_to_entry)) {
 					set_cpu_key_k_offset(&pos_key,
-- 
1.9.1

