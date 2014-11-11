Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaKKLQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:16:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaKKLLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 157/170] ext4: fix overflow when updating superblock backups after resize
Date: Tue, 11 Nov 2014 11:08:36 +0000
Message-Id: <1415704129-12709-158-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9378c6768e4fca48971e7b6a9075bc006eda981d upstream.

When there are no meta block groups update_backups() will compute the
backup block in 32-bit arithmetics thus possibly overflowing the block
number and corrupting the filesystem. OTOH filesystems without meta
block groups larger than 16 TB should be rare. Fix the problem by doing
the counting in 64-bit arithmetics.

Coverity-id: 741252
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f298c60f907d..ca4588388fc3 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1081,7 +1081,7 @@ static void update_backups(struct super_block *sb, int blk_off, char *data,
 			break;
 
 		if (meta_bg == 0)
-			backup_block = group * bpg + blk_off;
+			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
 			backup_block = (ext4_group_first_block_no(sb, group) +
 					ext4_bg_has_super(sb, group));
-- 
2.1.0

