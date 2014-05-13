Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaEMJkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:40:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60894 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760106AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jan Kara <jack@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/182] reiserfs: fix race in readdir
Date: Tue, 13 May 2014 11:27:11 +0200
Message-Id: <bbecbad0dc5029824fca336179fc7cf0fb45d996.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 01d8885785a60ae8f4c37b0ed75bdc96d0fc6a44 upstream.

jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-2)

The -ENOENT is due to readdir calling dir_emit on the same entry twice.

If the dir_emit callback sleeps and the tree is changed underneath us,
we won't be able to trust deh_offset(deh) anymore. We need to save
next_pos before we might sleep so we can find the next entry.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/reiserfs/dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 1fd2051109a3..af677353a3f5 100644
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
1.9.3

