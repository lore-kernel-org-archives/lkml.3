Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaHLTvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:51:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:58078 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100AbaHLTtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:35 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 09/13] f2fs: give a chance to mount again when encountering errors
Date: Tue, 12 Aug 2014 12:49:23 -0700
Message-Id: <1407872967-26423-9-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gives another chance to try mount process when we encounter an error.
This makes an effect on the roll-forward recovery failures as well.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 60e3554..2856020 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -899,8 +899,10 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	struct buffer_head *raw_super_buf;
 	struct inode *root;
 	long err = -EINVAL;
+	bool retry = true;
 	int i;
 
+try_onemore:
 	/* allocate memory for f2fs-specific super block info */
 	sbi = kzalloc(sizeof(struct f2fs_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -1080,9 +1082,11 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* recover fsynced data */
 	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
 		err = recover_fsync_data(sbi);
-		if (err)
+		if (err) {
 			f2fs_msg(sb, KERN_ERR,
 				"Cannot recover all fsync data errno=%ld", err);
+			goto free_kobj;
+		}
 	}
 
 	/*
@@ -1123,6 +1127,13 @@ free_sb_buf:
 	brelse(raw_super_buf);
 free_sbi:
 	kfree(sbi);
+
+	/* give only one another chance */
+	if (retry) {
+		retry = !retry;
+		shrink_dcache_sb(sb);
+		goto try_onemore;
+	}
 	return err;
 }
 
-- 
1.8.5.2 (Apple Git-48)

