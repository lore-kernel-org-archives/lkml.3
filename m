Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaBGLY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaBGLXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 01/88] ext4: fix deadlock when writing in ENOSPC conditions
Date: Fri,  7 Feb 2014 11:21:58 +0000
Message-Id: <1391772205-22239-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8aacdda..efecfb7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1175,7 +1175,6 @@ static int ext4_journalled_write_end(struct file *file,
  */
 static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1197,7 +1196,6 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1217,10 +1215,6 @@ repeat:
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

