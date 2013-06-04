Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3FDXEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:04:53 -0400
Received: from 1wt.eu ([62.212.114.60]:35604 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab3FDWmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:54 -0400
Message-Id: <20130604172135.820868480@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>, Jan Kara <jack@suse.cz>,
        Shuah Khan <shuah.khan@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 133/184] udf: fix memory leak while allocating blocks during
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 write

From: Namjae Jeon <namjae.jeon@samsung.com>

commit 2fb7d99d0de3fd8ae869f35ab682581d8455887a upstream.

Need to brelse the buffer_head stored in cur_epos and next_epos.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6d24c2c..3c4ffb2 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -648,6 +648,8 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 				goal, err);
 		if (!newblocknum) {
 			brelse(prev_epos.bh);
+			brelse(cur_epos.bh);
+			brelse(next_epos.bh);
 			*err = -ENOSPC;
 			return NULL;
 		}
@@ -678,6 +680,8 @@ static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
 	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
 
 	brelse(prev_epos.bh);
+	brelse(cur_epos.bh);
+	brelse(next_epos.bh);
 
 	newblock = udf_get_pblock(inode->i_sb, newblocknum,
 				iinfo->i_location.partitionReferenceNum, 0);
-- 
1.7.12.2.21.g234cd45.dirty



