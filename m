Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3APQHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:07:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab3APQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 156/222] udf: fix memory leak while allocating blocks during write
Date: Wed, 16 Jan 2013 13:55:56 -0200
Message-Id: <1358351822-7675-157-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 2fb7d99d0de3fd8ae869f35ab682581d8455887a upstream.

Need to brelse the buffer_head stored in cur_epos and next_epos.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/udf/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 873e1ba..8873c47 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -738,6 +738,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
+			brelse(cur_epos.bh);
+			brelse(next_epos.bh);
 			*err = -ENOSPC;
 			return 0;
 		}
@@ -768,6 +770,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);
-- 
1.7.9.5

