Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaDAJQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaDAJQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/29] GFS2: replace kmalloc - __vmalloc / memset 0
Date: Tue,  1 Apr 2014 10:15:25 +0100
Message-Id: <1396343741-1524-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Use kzalloc and __vmalloc __GFP_ZERO for clean sd_quota_bitmap allocation.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 8bec0e31..a5cccf6 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1242,14 +1242,13 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 	bm_size = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * sizeof(unsigned long));
 	bm_size *= sizeof(unsigned long);
 	error = -ENOMEM;
-	sdp->sd_quota_bitmap = kmalloc(bm_size, GFP_NOFS|__GFP_NOWARN);
+	sdp->sd_quota_bitmap = kzalloc(bm_size, GFP_NOFS | __GFP_NOWARN);
 	if (sdp->sd_quota_bitmap == NULL)
-		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
+		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS |
+						 __GFP_ZERO, PAGE_KERNEL);
 	if (!sdp->sd_quota_bitmap)
 		return error;
 
-	memset(sdp->sd_quota_bitmap, 0, bm_size);
-
 	for (x = 0; x < blocks; x++) {
 		struct buffer_head *bh;
 		const struct gfs2_quota_change *qc;
-- 
1.8.3.1

