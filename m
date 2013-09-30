Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3I3N0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14041 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3I3N03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:29 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-c5-52497c043a34
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 02/14] skd: fix error paths in skd_init()
Date: Mon, 30 Sep 2013 15:25:43 +0200
Message-id: <1380547556-17719-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgC5LjWeQwfYTPBa9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZWxqv81S0MhTcXCvQAPjG84uRk4OCQETictP9zBD2GISF+6tZ+ti5OIQEljE
	KPHz/ikmCKeLSeLCjB9MIFVsAlYSE9tXMYLYIgLCEvs7WllAipgFmhglNi6ZwwaSEBawlOjc
	sBbMZhFQlXjzs4sdxOYV8JC4vWs5E8Q6eYmn9/vAajgFPCX+3z4KNlQIqObboctMExh5FzAy
	rGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDqVn0jsYVzVYHGIU4GBU4uG1WOoRJMSaWFZc
	mXuIUYKDWUmEV7zMM0iINyWxsiq1KD++qDQntfgQozQHi5I478FW60AhgfTEktTs1NSC1CKY
	LBMHp1QDo2FWZuAjjVlt/5b/8F+6cX3KqhvL2D+2P427Ml9NetrKz5cv7uP76v2mdr3GnZrZ
	HFvS6l6mCvMkp2xNECv9XmTMdVDhdPJSH+PvRi1e1yf3rVnApnSXTUciPErmjs9v5wBuo/7p
	LWx/M8uEPWU+73zlYvjy7F/pwxwdubcjF/YsXnJjtsvvZiWW4oxEQy3mouJEAHaRFEkhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index a98d1bc..a4eb480 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5699,7 +5699,7 @@ static void skd_log_skreq(struct skd_device *skdev,
 
 static int __init skd_init(void)
 {
-	int rc = 0;
+	int rc = -ENOMEM;
 
 	pr_info(PFX " v%s-b%s loaded\n", DRV_VERSION, DRV_BUILD_ID);
 
@@ -5720,7 +5720,7 @@ static int __init skd_init(void)
 
 	if (!skd_flush_slab) {
 		pr_err("failed to allocated flush slab.\n");
-		return -ENOMEM;
+		goto err_kmem_cache_create;
 	}
 
 	if (skd_max_queue_depth < 1
@@ -5766,12 +5766,24 @@ static int __init skd_init(void)
 	/* Obtain major device number. */
 	rc = register_blkdev(0, DRV_NAME);
 	if (rc < 0)
-		return rc;
+		goto err_register_blkdev;
 
 	skd_major = rc;
 
-	return pci_register_driver(&skd_driver);
+	rc = pci_register_driver(&skd_driver);
+	if (rc < 0)
+		goto err_pci_register_driver;
+
+	return rc;
 
+err_pci_register_driver:
+	unregister_blkdev(skd_major, DRV_NAME);
+
+err_register_blkdev:
+	kmem_cache_destroy(skd_flush_slab);
+
+err_kmem_cache_create:
+	return rc;
 }
 
 static void __exit skd_exit(void)
-- 
1.8.2.3

