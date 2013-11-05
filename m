Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3KELhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:37:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28655 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3KELhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:37:37 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-36-5278d880bcca
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 02/11] skd: fix error paths in skd_init()
Date: Tue, 05 Nov 2013 12:37:00 +0100
Message-id: <1383651429-4322-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoG7DjYogg903+Sx6e06yW6y+289m
	sXHGelaLs7+uslicbXrDbnF51xw2BzaPy2dLPd7vu8rm0bdlFaPHnXMfmDw+b5ILYI3isklJ
	zcksSy3St0vgyjjdupOt4CZnxfPdO9gbGP+zdzFyckgImEjMn/mHFcIWk7hwbz1bFyMXh5DA
	dEaJJZ/uMkI4XUwS819NYwGpYhOwkpjYvooRxBYREJbY39HKAlLELLCAUWLyjjlgY4UFbCTe
	bLsFNpZFQFVi5vG5QDYHB6+Au8Sxtd4Q2+Qlnt7vYwOxOQU8JK5cegPWKgRUsu3jXtYJjLwL
	GBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH0jOpHYwrGywOMQpwMCrx8D44Wx4kxJpY
	VlyZe4hRgoNZSYS37UhFkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWp
	RTBZJg5OqQZG8xLOLK6/l71rlF+tF7Gcb/dVoeHpGpslq02W7eoTjpCekhZ88fIkpstP9nZ/
	uMRa+DhN7Vdr1N/t345eNFTdYckh4H7ORILh/NP1fctX7XFi+TQ5jusy41Ft8WU3Pi78fu6z
	XMWB4+xsS3l8DnsaeGTtKZA5rxnM36r6Pza8uCdCTSjdsKRBiaU4I9FQi7moOBEADAnc8yEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 6f09bca..8c96d18 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -5396,7 +5396,7 @@ static void skd_log_skreq(struct skd_device *skdev,
 
 static int __init skd_init(void)
 {
-	int rc = 0;
+	int rc = -ENOMEM;
 
 	pr_info(PFX " v%s-b%s loaded\n", DRV_VERSION, DRV_BUILD_ID);
 
@@ -5454,11 +5454,21 @@ static int __init skd_init(void)
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
+
+err_pci_register_driver:
+	unregister_blkdev(skd_major, DRV_NAME);
+
+err_register_blkdev:
+	return rc;
 }
 
 static void __exit skd_exit(void)
-- 
1.8.2.3

