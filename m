Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbaKROt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:49:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbaKROJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 126/206] ext4: fix overflow when updating superblock backups after resize
Date: Tue, 18 Nov 2014 15:08:01 +0100
Message-Id: <6eac6ac49db2487a748258be990a34cff73dc792.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 14e0f8a25c81..2400ad1c3d12 100644
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
2.1.3

