Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab3CQI1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:27:22 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55871 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab3CQI1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:27:15 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/5] f2fs: remove nid_free from f2fs_new_inode
Date: Sun, 17 Mar 2013 17:27:07 +0900
Message-Id: <1363508828-2920-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

we can remove nid_free from new inode allocation part.
Since, nid_free is used to check if we need to free alloced nid
in case of failure.
Instead we can directly call alloc_nid_failed from that point, as
there is no dependency in that path.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/namei.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index d4a171b..261d821 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -24,7 +24,6 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 	nid_t ino;
 	struct inode *inode;
-	bool nid_free = false;
 	int err;
 
 	inode = new_inode(sb);
@@ -58,7 +57,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	err = insert_inode_locked(inode);
 	if (err) {
 		err = -EINVAL;
-		nid_free = true;
+		alloc_nid_failed(sbi, ino);
 		goto out;
 	}
 
@@ -70,8 +69,6 @@ out:
 	unlock_new_inode(inode);
 fail:
 	iput(inode);
-	if (nid_free)
-		alloc_nid_failed(sbi, ino);
 	return ERR_PTR(err);
 }
 
-- 
1.7.9.5

