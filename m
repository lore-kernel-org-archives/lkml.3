Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaGNVYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:24:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:6399 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbaGNVYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:24:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,660,1400050800"; 
   d="scan'208";a="543266378"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Himangi Saraogi <himangi774@gmail.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next 1/2] misc: mic: Introduce the managed version of ioremap
Date: Mon, 14 Jul 2014 14:23:51 -0700
Message-Id: <6e5bccd7e442687715bf1faf6a7c7a2dcb8ce75f.1405370827.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1405370827.git.sudeep.dutt@intel.com>
References: <cover.1405370827.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1405370827.git.sudeep.dutt@intel.com>
References: <cover.1405370827.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>

This patch moves data allocated using ioremap to managed data
allocated using devm_ioremap and cleans now unnecessary
iounmaps in probe and remove functions. Also the unnecessary
label iounmap is done away with.

Link: https://lkml.org/lkml/2014/6/1/191
Tested-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
 drivers/misc/mic/card/mic_x100.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index 55c9465..9d57545 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -200,7 +200,8 @@ static int __init mic_probe(struct platform_device *pdev)
 
 	mdev->mmio.pa = MIC_X100_MMIO_BASE;
 	mdev->mmio.len = MIC_X100_MMIO_LEN;
-	mdev->mmio.va = ioremap(MIC_X100_MMIO_BASE, MIC_X100_MMIO_LEN);
+	mdev->mmio.va = devm_ioremap(&pdev->dev, MIC_X100_MMIO_BASE,
+				     MIC_X100_MMIO_LEN);
 	if (!mdev->mmio.va) {
 		dev_err(&pdev->dev, "Cannot remap MMIO BAR\n");
 		rc = -EIO;
@@ -214,7 +215,7 @@ static int __init mic_probe(struct platform_device *pdev)
 	if (IS_ERR(mdrv->dma_mbdev)) {
 		rc = PTR_ERR(mdrv->dma_mbdev);
 		dev_err(&pdev->dev, "mbus_add_device failed rc %d\n", rc);
-		goto iounmap;
+		goto done;
 	}
 	rc = mic_driver_init(mdrv);
 	if (rc) {
@@ -225,19 +226,15 @@ done:
 	return rc;
 remove_dma:
 	mbus_unregister_device(mdrv->dma_mbdev);
-iounmap:
-	iounmap(mdev->mmio.va);
 	return rc;
 }
 
 static int mic_remove(struct platform_device *pdev)
 {
 	struct mic_driver *mdrv = &g_drv;
-	struct mic_device *mdev = &mdrv->mdev;
 
 	mic_driver_uninit(mdrv);
 	mbus_unregister_device(mdrv->dma_mbdev);
-	iounmap(mdev->mmio.va);
 	return 0;
 }
 
-- 
1.8.2.1

