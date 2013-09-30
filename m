Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3I3N0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55655 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3I3N0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:36 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-83-52497c0ba398
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 03/14] skd: fix error messages in skd_init()
Date: Mon, 30 Sep 2013 15:25:44 +0200
Message-id: <1380547556-17719-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgC53jWeQwZOtgha9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZbStPc5WsE6iYtvWfpYGxrXCXYycHBICJhJL38xhgrDFJC7cW8/WxcjFISSw
	iFGidXs7O4TTxSTx/PYxFpAqNgEriYntqxhBbBEBYYn9Ha0sIEXMAk2MEhuXzAFq5+AQFrCR
	uNqbAlLDIqAqsXvdd7BeXgEPiU9LjjNCbJOXeHq/jw3E5hTwlPh/+yhYXAio5tuhy0wTGHkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgOpWdSOxhXNlgcYhTgYFTi4Z2w3CNIiDWx
	rLgy9xCjBAezkgiveJlnkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWp
	RTBZJg5OqQbGfQZGnNaZa6x5dvleON90Vn9ay+mvz2bFl35wDorVE+6UZTXoeNRpunGGlcrD
	dN2osH03+z+evpuwjO3hxFB1M7ZardeHWu7G3J0+4dXSXtt4jdnnTnFNF/tbtbdl9R3LuBVa
	WbJdHCfF/qUfbUnd6GT76uscHwUJg5MW69M/JJvYX+qXtHqvxFKckWioxVxUnAgA/SJ+wCEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* change priority level from KERN_INFO to KERN_ERR
* add "skd: " prefix
* fix flush slab allocation failure message
* do minor CodingStyle fixes

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index a4eb480..04eb9bd 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5709,56 +5709,52 @@ static int __init skd_init(void)
 	case SKD_IRQ_MSIX:
 		break;
 	default:
-		pr_info("skd_isr_type %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_isr_type %d invalid, re-set to %d\n",
 		       skd_isr_type, SKD_IRQ_DEFAULT);
 		skd_isr_type = SKD_IRQ_DEFAULT;
 	}
 
 	skd_flush_slab = kmem_cache_create(SKD_FLUSH_JOB,
-						sizeof(struct skd_flush_cmd),
-						0, 0, NULL);
-
+					  sizeof(struct skd_flush_cmd),
+					  0, 0, NULL);
 	if (!skd_flush_slab) {
-		pr_err("failed to allocated flush slab.\n");
+		pr_err(PFX "failed to allocate flush slab\n");
 		goto err_kmem_cache_create;
 	}
 
-	if (skd_max_queue_depth < 1
-	    || skd_max_queue_depth > SKD_MAX_QUEUE_DEPTH) {
-		pr_info(
-		       "skd_max_queue_depth %d invalid, re-set to %d\n",
+	if (skd_max_queue_depth < 1 ||
+	    skd_max_queue_depth > SKD_MAX_QUEUE_DEPTH) {
+		pr_err(PFX "skd_max_queue_depth %d invalid, re-set to %d\n",
 		       skd_max_queue_depth, SKD_MAX_QUEUE_DEPTH_DEFAULT);
 		skd_max_queue_depth = SKD_MAX_QUEUE_DEPTH_DEFAULT;
 	}
 
 	if (skd_max_req_per_msg < 1 || skd_max_req_per_msg > 14) {
-		pr_info(
-		       "skd_max_req_per_msg %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_max_req_per_msg %d invalid, re-set to %d\n",
 		       skd_max_req_per_msg, SKD_MAX_REQ_PER_MSG_DEFAULT);
 		skd_max_req_per_msg = SKD_MAX_REQ_PER_MSG_DEFAULT;
 	}
 
 	if (skd_sgs_per_request < 1 || skd_sgs_per_request > 4096) {
-		pr_info(
-		       "skd_sg_per_request %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_sg_per_request %d invalid, re-set to %d\n",
 		       skd_sgs_per_request, SKD_N_SG_PER_REQ_DEFAULT);
 		skd_sgs_per_request = SKD_N_SG_PER_REQ_DEFAULT;
 	}
 
 	if (skd_dbg_level < 0 || skd_dbg_level > 2) {
-		pr_info("skd_dbg_level %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_dbg_level %d invalid, re-set to %d\n",
 		       skd_dbg_level, 0);
 		skd_dbg_level = 0;
 	}
 
 	if (skd_isr_comp_limit < 0) {
-		pr_info("skd_isr_comp_limit %d invalid, set to %d\n",
+		pr_err(PFX "skd_isr_comp_limit %d invalid, set to %d\n",
 		       skd_isr_comp_limit, 0);
 		skd_isr_comp_limit = 0;
 	}
 
 	if (skd_max_pass_thru < 1 || skd_max_pass_thru > 50) {
-		pr_info("skd_max_pass_thru %d invalid, re-set to %d\n",
+		pr_err(PFX "skd_max_pass_thru %d invalid, re-set to %d\n",
 		       skd_max_pass_thru, SKD_N_SPECIAL_CONTEXT);
 		skd_max_pass_thru = SKD_N_SPECIAL_CONTEXT;
 	}
-- 
1.8.2.3

