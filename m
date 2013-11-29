Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3K2IRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:17:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28303 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3K2IRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:17:18 -0500
Date: Fri, 29 Nov 2013 11:16:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Akhil Bhansali <bhansaliakhil@gmail.com>,
        rchinthekindi <rchinthekindi@stec-inc.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] skd: wrong limiter in skd_acquire_msix()
Message-ID: <20131129081646.GB3490@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some paths, there can be fewer than SKD_MAX_MSIX_COUNT (13) elements
in the skdev->msix_entries[] array so we would be going past the end of
the array.

Fixes: e67f86b31ae5 ('Add support for sTec's pci-e flash card Kronos')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  Compile tested only.

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 9199c93be926..d0f3e4e81cc5 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3989,7 +3989,7 @@ static int skd_acquire_msix(struct skd_device *skdev)
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++) {
+	for (i = 0; i < skdev->msix_count; i++) {
 		qentry = &skdev->msix_entries[i];
 		snprintf(qentry->isr_name, sizeof(qentry->isr_name),
 			 "%s%d-msix %s", DRV_NAME, skdev->devno,
