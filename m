Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaFASzD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:55:03 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47314 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbaFASzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:55:00 -0400
Date: Mon, 2 Jun 2014 00:24:53 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] misc: mic: Introduce the managed version of ioremap
Message-ID: <20140601185452.GA21438@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using ioremap to managed data allocated
using devm_ioremap and cleans now unnecessary iounmaps in probe and remove
functions. Also the unnecessary label iounmap is done away with.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
I wonder if mic_card_map and mic_card_unmap can be used on the same data
as the devm_ioremap in the probe function. If yes, can I devmify them as well,
in which case mic_card_unmap will not be required.

 drivers/misc/mic/card/mic_x100.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index 2868945..5f26b17 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -159,7 +159,8 @@ static int __init mic_probe(struct platform_device *pdev)
 
 	mdev->mmio.pa = MIC_X100_MMIO_BASE;
 	mdev->mmio.len = MIC_X100_MMIO_LEN;
-	mdev->mmio.va = ioremap(MIC_X100_MMIO_BASE, MIC_X100_MMIO_LEN);
+	mdev->mmio.va = devm_ioremap(&pdev->dev, MIC_X100_MMIO_BASE,
+				     MIC_X100_MMIO_LEN);
 	if (!mdev->mmio.va) {
 		dev_err(&pdev->dev, "Cannot remap MMIO BAR\n");
 		rc = -EIO;
@@ -169,22 +170,17 @@ static int __init mic_probe(struct platform_device *pdev)
 	rc = mic_driver_init(mdrv);
 	if (rc) {
 		dev_err(&pdev->dev, "mic_driver_init failed rc %d\n", rc);
-		goto iounmap;
+		goto done;
 	}
 done:
 	return rc;
-iounmap:
-	iounmap(mdev->mmio.va);
-	return rc;
 }
 
 static int mic_remove(struct platform_device *pdev)
 {
 	struct mic_driver *mdrv = &g_drv;
-	struct mic_device *mdev = &mdrv->mdev;
 
 	mic_driver_uninit(mdrv);
-	iounmap(mdev->mmio.va);
 	return 0;
 }
 
-- 
1.9.1

