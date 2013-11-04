Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3KDLgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab3KDLgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:17 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/19] GFS2: optimize rbm_from_block wrt bi_start
Date: Mon,  4 Nov 2013 11:09:25 +0000
Message-Id: <1383563382-8535-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

In function gfs2_rbm_from_block, it starts by checking if the block
falls within the first bitmap. It does so by checking if the rbm's
offset is less than (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY.
However, the first bitmap will always have bi_start==0. Therefore
this is an unnecessary calculation in a function that gets called
billions of times. This patch removes the reference to bi_start.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 6931743..7a6fa03 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -262,7 +262,7 @@ static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 	rbm->bi = rbm->rgd->rd_bits;
 	rbm->offset = (u32)(rblock);
 	/* Check if the block is within the first block */
-	if (rbm->offset < (rbm->bi->bi_start + rbm->bi->bi_len) * GFS2_NBBY)
+	if (rbm->offset < rbm->bi->bi_len * GFS2_NBBY)
 		return 0;
 
 	/* Adjust for the size diff between gfs2_meta_header and gfs2_rgrp */
-- 
1.7.4.4

