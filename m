Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaKFXP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:15:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbaKFWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 152/162] ext4: fix overflow when updating superblock backups after resize
Date: Thu,  6 Nov 2014 14:36:56 -0800
Message-Id: <1415313426-9622-153-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 14e0f8a..2400ad1 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1071,7 +1071,7 @@ static void update_backups(struct super_block *sb, int blk_off, char *data,
 			break;
 
 		if (meta_bg == 0)
-			backup_block = group * bpg + blk_off;
+			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
 			backup_block = (ext4_group_first_block_no(sb, group) +
 					ext4_bg_has_super(sb, group));
-- 
1.9.1

