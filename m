Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaAOV7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:59:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaAOV6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 102/166] ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
Date: Wed, 15 Jan 2014 13:51:56 -0800
Message-Id: <1389822780-4729-103-git-send-email-kamal@canonical.com>
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

commit df4e7ac0bb70abc97fbfd9ef09671fc084b3f9db upstream.

ext2_quota_write() doesn't properly setup bh it passes to
ext2_get_block() and thus we hit assertion BUG_ON(maxblocks == 0) in
ext2_get_blocks() (or we could actually ask for mapping arbitrary number
of blocks depending on whatever value was on stack).

Fix ext2_quota_write() to properly fill in number of blocks to map.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext2/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index fa04d02..9d8b0ad 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1493,6 +1493,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 				sb->s_blocksize - offset : towrite;
 
 		tmp_bh.b_state = 0;
+		tmp_bh.b_size = sb->s_blocksize;
 		err = ext2_get_block(inode, blk, &tmp_bh, 1);
 		if (err < 0)
 			goto out;
-- 
1.8.3.2

