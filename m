Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaHLTtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:49:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:58003 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbaHLTtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:22 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 04/13] f2fs: clear FI_INC_LINK during the recovery
Date: Tue, 12 Aug 2014 12:49:18 -0700
Message-Id: <1407872967-26423-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an inode are fsynced multiple times with fsync & dent marks, this inode will
set FI_INC_LINK at find_fsync_dnodes during the recovery.
But, in recover_inode, recover_dentry doesn't clear that flag when multiple hits
were occurred.

So this patch removes the flag for the further consistency.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/recovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index fe1c6d9..cfb2aa9 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -62,8 +62,10 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	}
 retry:
 	de = f2fs_find_entry(dir, &name, &page);
-	if (de && inode->i_ino == le32_to_cpu(de->ino))
+	if (de && inode->i_ino == le32_to_cpu(de->ino)) {
+		clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
 		goto out_unmap_put;
+	}
 	if (de) {
 		einode = f2fs_iget(inode->i_sb, le32_to_cpu(de->ino));
 		if (IS_ERR(einode)) {
-- 
1.8.5.2 (Apple Git-48)

