Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3KDLgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3KDLgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:25 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/19] GFS2: new function gfs2_rbm_incr
Date: Mon,  4 Nov 2013 11:09:29 +0000
Message-Id: <1383563382-8535-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Since the previous patch eliminated bi in favor of bii, this follow-on
patch needed to be adjusted accordingly. Here is the revised version.

This patch adds a new function, gfs2_rbm_incr, which increments
an rbm structure. This is more efficient than calling gfs2_rbm_to_block,
incrementing, then calling gfs2_rbm_from_block.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index dd3c4d3..285dd36 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -274,6 +274,32 @@ static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 }
 
 /**
+ * gfs2_rbm_incr - increment an rbm structure
+ * @rbm: The rbm with rgd already set correctly
+ *
+ * This function takes an existing rbm structure and increments it to the next
+ * viable block offset.
+ *
+ * Returns: If incrementing the offset would cause the rbm to go past the
+ *          end of the rgrp, true is returned, otherwise false.
+ *
+ */
+
+static bool gfs2_rbm_incr(struct gfs2_rbm *rbm)
+{
+	if (rbm->offset + 1 < rbm_bi(rbm)->bi_blocks) { /* in the same bitmap */
+		rbm->offset++;
+		return false;
+	}
+	if (rbm->bii == rbm->rgd->rd_length - 1) /* at the last bitmap */
+		return true;
+
+	rbm->offset = 0;
+	rbm->bii++;
+	return false;
+}
+
+/**
  * gfs2_unaligned_extlen - Look for free blocks which are not byte aligned
  * @rbm: Position to search (value/result)
  * @n_unaligned: Number of unaligned blocks to check
@@ -284,7 +310,6 @@ static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 
 static bool gfs2_unaligned_extlen(struct gfs2_rbm *rbm, u32 n_unaligned, u32 *len)
 {
-	u64 block;
 	u32 n;
 	u8 res;
 
@@ -295,8 +320,7 @@ static bool gfs2_unaligned_extlen(struct gfs2_rbm *rbm, u32 n_unaligned, u32 *le
 		(*len)--;
 		if (*len == 0)
 			return true;
-		block = gfs2_rbm_to_block(rbm);
-		if (gfs2_rbm_from_block(rbm, block + 1))
+		if (gfs2_rbm_incr(rbm))
 			return true;
 	}
 
-- 
1.7.4.4

