Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaAOV5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41027 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaAOV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:45 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 106/166] ext4: fix deadlock when writing in ENOSPC conditions
Date: Wed, 15 Jan 2014 13:52:00 -0800
Message-Id: <1389822780-4729-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 34cf865d54813aab3497838132fb1bbd293f4054 upstream.

Akira-san has been reporting rare deadlocks of his machine when running
xfstests test 269 on ext4 filesystem. The problem turned out to be in
ext4_da_reserve_metadata() and ext4_da_reserve_space() which called
ext4_should_retry_alloc() while holding i_data_sem. Since
ext4_should_retry_alloc() can force a transaction commit, this is a
lock ordering violation and leads to deadlocks.

Fix the problem by just removing the retry loops. These functions should
just report ENOSPC to the caller (e.g. ext4_da_write_begin()) and that
function must take care of retrying after dropping all necessary locks.

Reported-and-tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ kamal: backport to 3.8 (no ext4_da_reserve_metadata) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fe1fada..46c10b5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1182,7 +1182,6 @@ static int ext4_journalled_write_end(struct file *file,
  */
 static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1204,7 +1203,6 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1224,10 +1222,6 @@ repeat:
 		ei->i_da_metadata_calc_len = save_len;
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			yield();
-			goto repeat;
-		}
 		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		return -ENOSPC;
 	}
-- 
1.8.3.2

