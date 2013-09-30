Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3I3N0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55668 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3I3N0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:44 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-c6-52497c13d80f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 04/14] skd: alloc flush slab only if some devices are present
Date: Mon, 30 Sep 2013 15:25:45 +0200
Message-id: <1380547556-17719-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xgK5wjWeQwZSf+ha9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZfyf94m14IBARfeU9WwNjGt5uxg5OSQETCS+PG9lhbDFJC7cW8/WxcjFISSw
	iFHi8IE7UE4Xk8S3pT9YQKrYBKwkJravYgSxRQSEJfZ3tLKAFDELNDFKbFwyhw0kISzgK/Ho
	yTMmEJtFQFWiq/kFWJxXwEPi9uyN7BDr5CWe3u8Di3MKeEr8v30UbKgQUM23Q5eZJjDyLmBk
	WMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHEzPpHYwrmywOMQowMGoxMM7YblHkBBrYllx
	Ze4hRgkOZiURXvEyzyAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1MLUotg
	skwcnFINjDKNb1Kzo08tqd2mvs35wOcyoSk6eRfCN3RP1zM58PP8s17f7KN1anVRNoxnf6zL
	usI35bfP1EsnNl302T2F5W+sIrtUVNCO39rxs4xVpq2+pOS0JCfCMKNsVuDbyreHHs/h3pS+
	cNOdlSGtM0sX3NJI2vIqa/LCf5On/f91ySadlX3X7ioProdKLMUZiYZazEXFiQCJaDq2IgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate flush slab in skd_pci_probe() instead of in skd_init() so it
is allocated only if some devices are present (currently it is always
allocated when the driver is loaded).

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 04eb9bd..e63a63c 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5203,6 +5203,18 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
+	if (!skd_flush_slab) {
+		skd_flush_slab = kmem_cache_create(SKD_FLUSH_JOB,
+						  sizeof(struct skd_flush_cmd),
+						  0, 0, NULL);
+		if (!skd_flush_slab) {
+			pr_err("(%s): failed to allocate flush slab\n",
+			       pci_name(pdev));
+			rc = -ENOMEM;
+			goto err_out_regions;
+		}
+	}
+
 	skdev = skd_construct(pdev);
 	if (skdev == NULL)
 		goto err_out_regions;
@@ -5714,14 +5726,6 @@ static int __init skd_init(void)
 		skd_isr_type = SKD_IRQ_DEFAULT;
 	}
 
-	skd_flush_slab = kmem_cache_create(SKD_FLUSH_JOB,
-					  sizeof(struct skd_flush_cmd),
-					  0, 0, NULL);
-	if (!skd_flush_slab) {
-		pr_err(PFX "failed to allocate flush slab\n");
-		goto err_kmem_cache_create;
-	}
-
 	if (skd_max_queue_depth < 1 ||
 	    skd_max_queue_depth > SKD_MAX_QUEUE_DEPTH) {
 		pr_err(PFX "skd_max_queue_depth %d invalid, re-set to %d\n",
@@ -5776,9 +5780,6 @@ err_pci_register_driver:
 	unregister_blkdev(skd_major, DRV_NAME);
 
 err_register_blkdev:
-	kmem_cache_destroy(skd_flush_slab);
-
-err_kmem_cache_create:
 	return rc;
 }
 
@@ -5790,7 +5791,8 @@ static void __exit skd_exit(void)
 
 	unregister_blkdev(skd_major, DRV_NAME);
 
-	kmem_cache_destroy(skd_flush_slab);
+	if (skd_flush_slab)
+		kmem_cache_destroy(skd_flush_slab);
 }
 
 static int
-- 
1.8.2.3

