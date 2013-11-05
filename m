Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3KELhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28667 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3KELho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:44 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-40-5278d8870571
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 04/11] skd: register block device only if some devices are
 present
Date: Tue, 05 Nov 2013 12:37:02 +0100
Message-id: <1383651429-4322-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xoG7HjYogg6UHmSx6e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgytg/6z9jwX7Big/PzrE3MK7k62Lk5JAQMJE4sqmJBcIWk7hwbz1bFyMXh5DA
	dEaJLRu2M0I4XUwSS74+ZgKpYhOwkpjYvooRxBYREJbY39HKAlLELLCAUWLyjjnsIAlhgXCJ
	920bwYpYBFQlTl89xAZi8wq4S3R3HWGEWCcv8fR+H1icU8BD4sqlN2C9QkA12z7uZZ3AyLuA
	kWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAwPZPawbiyweIQowAHoxIP74Oz5UFCrIll
	xZW5hxglOJiVRHjbjlQECfGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBa
	BJNl4uCUamDcd/Xvv7bPxc6m5bzdTkLGzQdD9+teZZLvU3ZZ7tzxfv3j8HP3Fy4StFv7xu38
	99P5hY41Alxzvz883nHpq3nGnT6uyrQwT1OFBc/U5sTUJ8TXG3Dbnj6a+NVFiXHC8e+e36sv
	h3WkqtdmZ3f9Vp1uXX0zTjJ7/rr6lmKBSSy/0lMaU+8nZCmxFGckGmoxFxUnAgD9GyWlIgIA	AA==
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
 drivers/block/skd_main.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 99d5d12..9ff34be 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4899,6 +4899,14 @@ static int skd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
 	if (skdev == NULL) {
 		rc = -ENOMEM;
@@ -5396,8 +5404,6 @@ static void skd_log_skreq(struct skd_device *skdev,
 
 static int __init skd_init(void)
 {
-	int rc = -ENOMEM;
-
 	pr_info(PFX " v%s-b%s loaded\n", DRV_VERSION, DRV_BUILD_ID);
 
 	switch (skd_isr_type) {
@@ -5448,24 +5454,7 @@ static int __init skd_init(void)
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
@@ -5473,7 +5462,9 @@ static void __exit skd_exit(void)
 	pr_info(PFX " v%s-b%s unloading\n", DRV_VERSION, DRV_BUILD_ID);
 
 	pci_unregister_driver(&skd_driver);
-	unregister_blkdev(skd_major, DRV_NAME);
+
+	if (skd_major)
+		unregister_blkdev(skd_major, DRV_NAME);
 }
 
 module_init(skd_init);
-- 
1.8.2.3

