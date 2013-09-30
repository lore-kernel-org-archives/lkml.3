Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3I3N3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:29:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55673 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab3I3N0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:47 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-ca-52497c16197d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 05/14] skd: register block device only if some devices are
 present
Date: Mon, 30 Sep 2013 15:25:46 +0200
Message-id: <1380547556-17719-6-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgK5YjWeQQediYYvenpPsFqvv9rNZ
	bJyxntXi7K+rLBZnm96wW1zeNYfNgc3j8tlSj/f7rrJ59G1Zxehx59wHJo/Pm+QCWKO4bFJS
	czLLUov07RK4MvYfW8JWsFiwYuXxw8wNjJP5uhg5OCQETCSu36/tYuQEMsUkLtxbzwZiCwks
	YpSY+8aoi5ELyO5ikvjadJ4FJMEmYCUxsX0VI4gtIiAssb+jlQWkiFmgiVFi45I5YN3CAiES
	Kw79YAexWQRUJc5f2QLWwCvgIdGx8R0rxDZ5iaf3+8DqOQU8Jf7fPsoIsdlD4tuhy0wTGHkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgOpGdSOxhXNlgcYhTgYFTi4Z2w3CNIiDWx
	rLgy9xCjBAezkgiveJlnkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWp
	RTBZJg5OqQZGPvaIzTmyaxcu3yHjG63FfPN36j3rtrgCo6dm1YmTjY4+v3o0f1+mafQV1/y/
	u9RzMx1ey2rMZF8vbJUbYHVn37SA6BOcshvPpoXfF7uZmjC79sNKI89wzeDyZVx+fb92Lj50
	bYdlfNObD/tVnfK+X4rtTdBb8Vptmf6reZ36xfYzs6u5ZHSUWIozEg21mIuKEwHlutFRIAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register block device in skd_pci_probe() instead of in skd_init() so it
is registered only if some devices are present (currently it is always
registered when the driver is loaded). Please note that this change
depends on the fact that register_blkdev(0, ...) never returns 0.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index e63a63c..738f847 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5215,6 +5215,14 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
+	if (!skd_major) {
+		rc = register_blkdev(0, DRV_NAME);
+		if (rc < 0)
+			goto err_out_regions;
+		BUG_ON(!rc);
+		skd_major = rc;
+	}
+
 	skdev = skd_construct(pdev);
 	if (skdev == NULL)
 		goto err_out_regions;
@@ -5711,8 +5719,6 @@ static void skd_log_skreq(struct skd_device *skdev,
 
 static int __init skd_init(void)
 {
-	int rc = -ENOMEM;
-
 	pr_info(PFX " v%s-b%s loaded\n", DRV_VERSION, DRV_BUILD_ID);
 
 	switch (skd_isr_type) {
@@ -5763,24 +5769,7 @@ static int __init skd_init(void)
 		skd_max_pass_thru = SKD_N_SPECIAL_CONTEXT;
 	}
 
-	/* Obtain major device number. */
-	rc = register_blkdev(0, DRV_NAME);
-	if (rc < 0)
-		goto err_register_blkdev;
-
-	skd_major = rc;
-
-	rc = pci_register_driver(&skd_driver);
-	if (rc < 0)
-		goto err_pci_register_driver;
-
-	return rc;
-
-err_pci_register_driver:
-	unregister_blkdev(skd_major, DRV_NAME);
-
-err_register_blkdev:
-	return rc;
+	return pci_register_driver(&skd_driver);
 }
 
 static void __exit skd_exit(void)
@@ -5789,7 +5778,8 @@ static void __exit skd_exit(void)
 
 	pci_unregister_driver(&skd_driver);
 
-	unregister_blkdev(skd_major, DRV_NAME);
+	if (skd_major)
+		unregister_blkdev(skd_major, DRV_NAME);
 
 	if (skd_flush_slab)
 		kmem_cache_destroy(skd_flush_slab);
-- 
1.8.2.3

