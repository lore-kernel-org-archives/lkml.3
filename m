Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbaAFXaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:30:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaAFWki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zheng Liu <wenqing.lz@taobao.com>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.10 033/129] ext4: fix deadlock when writing in ENOSPC conditions
Date: Mon,  6 Jan 2014 14:37:42 -0800
Message-Id: <20140106223900.552178150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1263,7 +1263,6 @@ static int ext4_journalled_write_end(str
  */
 static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1275,7 +1274,6 @@ static int ext4_da_reserve_metadata(stru
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1295,10 +1293,6 @@ repeat:
 		ei->i_da_metadata_calc_len = save_len;
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			cond_resched();
-			goto repeat;
-		}
 		return -ENOSPC;
 	}
 	ei->i_reserved_meta_blocks += md_needed;
@@ -1312,7 +1306,6 @@ repeat:
  */
 static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1334,7 +1327,6 @@ static int ext4_da_reserve_space(struct
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1354,10 +1346,6 @@ repeat:
 		ei->i_da_metadata_calc_len = save_len;
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			cond_resched();
-			goto repeat;
-		}
 		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		return -ENOSPC;
 	}


