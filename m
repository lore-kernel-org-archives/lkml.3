Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3GAKBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:01:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3GAKAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:00:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/12] GFS2: Fix fstrim boundary conditions
Date: Mon,  1 Jul 2013 10:33:14 +0100
Message-Id: <1372671195-3472-12-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch correctly distinguishes two boundary conditions:

1. When the given range is entire within the unaccounted space between
   two rgrps, and
2. The range begins beyond the end of the filesystem

Also fix the unit of the returned value r.len (total trimming) to be in bytes
instead of the (incorrect) 512 byte blocks

With this patch, GFS2 passes multiple iterations of all the relevant xfstests
(251, 260, 288) with different fs block sizes.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 9809156..6931743 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1288,13 +1288,15 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	minlen = max_t(u64, r.minlen,
 		       q->limits.discard_granularity) >> bs_shift;
 
+	if (end <= start || minlen > sdp->sd_max_rg_data)
+		return -EINVAL;
+
 	rgd = gfs2_blk2rgrpd(sdp, start, 0);
-	rgd_end = gfs2_blk2rgrpd(sdp, end - 1, 0);
+	rgd_end = gfs2_blk2rgrpd(sdp, end, 0);
 
-	if (end <= start ||
-	    minlen > sdp->sd_max_rg_data ||
-	    start > rgd_end->rd_data0 + rgd_end->rd_data)
-		return -EINVAL;
+	if ((gfs2_rgrpd_get_first(sdp) == gfs2_rgrpd_get_next(rgd_end))
+	    && (start > rgd_end->rd_data0 + rgd_end->rd_data))
+		return -EINVAL; /* start is beyond the end of the fs */
 
 	while (1) {
 
@@ -1336,7 +1338,7 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 	}
 
 out:
-	r.len = trimmed << 9;
+	r.len = trimmed << bs_shift;
 	if (copy_to_user(argp, &r, sizeof(r)))
 		return -EFAULT;
 
-- 
1.7.4

