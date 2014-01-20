Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaATMYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbaATMYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:06 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/24] GFS2: Drop inadequate rgrps from the reservation tree
Date: Mon, 20 Jan 2014 12:23:25 +0000
Message-Id: <1390220627-1571-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is just basically a resend of a patch I posted earlier.
It didn't change from its original, except in diff offsets, etc:

This patch fixes a bug in the GFS2 block allocation code. The problem
starts if a process already has a multi-block reservation, but for
some reason, another process disqualifies it from further allocations.
For example, the other process might set on the GFS2_RDF_ERROR bit.
The process holding the reservation jumps to label skip_rgrp, but
that label comes after the code that removes the reservation from the
tree. Therefore, the no longer usable reservation is not removed from
the rgrp's reservations tree; it's lost. Eventually, the lost reservation
causes the count of reserved blocks to get off, and eventually that
causes a BUG_ON(rs->rs_rbm.rgd->rd_reserved < rs->rs_free) to trigger.
This patch moves the call to after label skip_rgrp so that the
disqualified reservation is properly removed from the tree, thus keeping
the rgrp rd_reserved count sane.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 809fecd..1ccf89a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1944,15 +1944,16 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, const struct gfs2_alloc_parms *a
 			return 0;
 		}
 
-		/* Drop reservation, if we couldn't use reserved rgrp */
-		if (gfs2_rs_active(rs))
-			gfs2_rs_deltree(rs);
 check_rgrp:
 		/* Check for unlinked inodes which can be reclaimed */
 		if (rs->rs_rbm.rgd->rd_flags & GFS2_RDF_CHECK)
 			try_rgrp_unlink(rs->rs_rbm.rgd, &last_unlinked,
 					ip->i_no_addr);
 skip_rgrp:
+		/* Drop reservation, if we couldn't use reserved rgrp */
+		if (gfs2_rs_active(rs))
+			gfs2_rs_deltree(rs);
+
 		/* Unlock rgrp if required */
 		if (!rg_locked)
 			gfs2_glock_dq_uninit(&rs->rs_rgd_gh);
-- 
1.8.3.1

