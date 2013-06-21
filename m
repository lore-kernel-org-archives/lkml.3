Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161132Ab3FUK7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:59:22 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:9405 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab3FUK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="5916354"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/4] xen-blkback: workaround compiler bug in gcc 4.1
Date: Fri, 21 Jun 2013 12:56:53 +0200
Message-ID: <1371812216-17093-2-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
References: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code generat with gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-54)
creates an unbound loop for the second foreach_grant_safe loop in
purge_persistent_gnt.

The workaround is to avoid having this second loop and instead
perform all the work inside the first loop by adding a new variable,
clean_used, that will be set when all the desired persistent grants
have been removed and we need to iterate over the remaining ones to
remove the WAS_ACTIVE flag.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-by: Tom O'Neill <toneill@vmem.com>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/xen-blkback/blkback.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4119bcd..d622d86 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -341,7 +341,7 @@ static void purge_persistent_gnt(struct xen_blkif *blkif)
 	struct persistent_gnt *persistent_gnt;
 	struct rb_node *n;
 	unsigned int num_clean, total;
-	bool scan_used = false;
+	bool scan_used = false, clean_used = false;
 	struct rb_root *root;
 
 	if (blkif->persistent_gnt_c < xen_blkif_max_pgrants ||
@@ -358,9 +358,8 @@ static void purge_persistent_gnt(struct xen_blkif *blkif)
 	num_clean = (xen_blkif_max_pgrants / 100) * LRU_PERCENT_CLEAN;
 	num_clean = blkif->persistent_gnt_c - xen_blkif_max_pgrants + num_clean;
 	num_clean = min(blkif->persistent_gnt_c, num_clean);
-	if (num_clean >
-	    (blkif->persistent_gnt_c -
-	    atomic_read(&blkif->persistent_gnt_in_use)))
+	if ((num_clean == 0) ||
+	    (num_clean > (blkif->persistent_gnt_c - atomic_read(&blkif->persistent_gnt_in_use))))
 		return;
 
 	/*
@@ -383,6 +382,11 @@ purge_list:
 		BUG_ON(persistent_gnt->handle ==
 			BLKBACK_INVALID_HANDLE);
 
+		if (clean_used) {
+			clear_bit(PERSISTENT_GNT_WAS_ACTIVE, persistent_gnt->flags);
+			continue;
+		}
+
 		if (test_bit(PERSISTENT_GNT_ACTIVE, persistent_gnt->flags))
 			continue;
 		if (!scan_used &&
@@ -400,18 +404,18 @@ purge_list:
 	 * grants that were used since last purge in order to cope
 	 * with the requested num
 	 */
-	if (!scan_used) {
+	if (!scan_used && !clean_used) {
 		pr_debug(DRV_PFX "Still missing %u purged frames\n", num_clean);
 		scan_used = true;
 		goto purge_list;
 	}
 finished:
-	/* Remove the "used" flag from all the persistent grants */
-	foreach_grant_safe(persistent_gnt, n, root, node) {
-		BUG_ON(persistent_gnt->handle ==
-			BLKBACK_INVALID_HANDLE);
-		clear_bit(PERSISTENT_GNT_WAS_ACTIVE, persistent_gnt->flags);
+	if (!clean_used) {
+		pr_debug(DRV_PFX "Finished scanning for grants to clean, removing used flag\n");
+		clean_used = true;
+		goto purge_list;
 	}
+
 	blkif->persistent_gnt_c -= (total - num_clean);
 	blkif->vbd.overflow_max_grants = 0;
 
-- 
1.7.7.5 (Apple Git-26)

