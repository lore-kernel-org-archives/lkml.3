Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab3GAKAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:00:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab3GAKAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:00:34 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/12] GFS2: Reserve journal space for quota change in do_grow
Date: Mon,  1 Jul 2013 10:33:15 +0100
Message-Id: <1372671195-3472-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

If a GFS2 file system is mounted with quotas and a file is grown
in such a way that its free blocks for the allocation are represented
in a secondary bitmap, GFS2 ran out of blocks in the transaction.
That resulted in "fatal: assertion "tr->tr_num_buf <= tr->tr_blocks".
This patch reserves extra blocks for the quota change so the
transaction has enough space.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 93b5809..5e2f56f 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1232,7 +1232,9 @@ static int do_grow(struct inode *inode, u64 size)
 		unstuff = 1;
 	}
 
-	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT, 0);
+	error = gfs2_trans_begin(sdp, RES_DINODE + RES_STATFS + RES_RG_BIT +
+				 (sdp->sd_args.ar_quota == GFS2_QUOTA_OFF ?
+				  0 : RES_QUOTA), 0);
 	if (error)
 		goto do_grow_release;
 
-- 
1.7.4

