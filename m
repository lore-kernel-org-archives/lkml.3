Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3KDLgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab3KDLgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:21 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/19] GFS2: Do not reset flags on active reservations
Date: Mon,  4 Nov 2013 11:09:27 +0000
Message-Id: <1383563382-8535-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

When we used try locks for rgrps on block allocations, it was important
to clear the flags field so that we used a blocking hold on the glock.
Now that we're not doing try locks, clearing flags is unnecessary, and
a waste of time. In fact, it's probably doing the wrong thing because
it clears the GL_SKIP bit that was set for the lvb tracking purposes.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7d64a27..8e50038 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1825,7 +1825,6 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
 		return -EINVAL;
 	if (gfs2_rs_active(rs)) {
 		begin = rs->rs_rbm.rgd;
-		flags = 0; /* Yoda: Do or do not. There is no try */
 	} else if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal)) {
 		rs->rs_rbm.rgd = begin = ip->i_rgd;
 	} else {
-- 
1.7.4.4

