Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3AQMZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:25:18 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64712 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3AQMZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:25:16 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Subject: [PATCH] remoteproc: Deallocate firmware image on shutdown
Date: Thu, 17 Jan 2013 13:25:00 +0100
Message-Id: <1358425500-4720-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>

Fixes coherent memory leakage, caused by non-deallocated
firmware image chunk.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---

This fix is intended for v3.8.

Thanks,
Sjur

 drivers/remoteproc/ste_modem_rproc.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
index a7743c0..fb95c42 100644
--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -240,6 +240,8 @@ static int sproc_drv_remove(struct platform_device *pdev)
 
 	/* Unregister as remoteproc device */
 	rproc_del(sproc->rproc);
+	dma_free_coherent(sproc->rproc->dev.parent, SPROC_FW_SIZE,
+			  sproc->fw_addr, sproc->fw_dma_addr);
 	rproc_put(sproc->rproc);
 
 	mdev->drv_data = NULL;
@@ -297,10 +299,13 @@ static int sproc_probe(struct platform_device *pdev)
 	/* Register as a remoteproc device */
 	err = rproc_add(rproc);
 	if (err)
-		goto free_rproc;
+		goto free_mem;
 
 	return 0;
 
+free_mem:
+	dma_free_coherent(rproc->dev.parent, SPROC_FW_SIZE,
+			  sproc->fw_addr, sproc->fw_dma_addr);
 free_rproc:
 	/* Reset device data upon error */
 	mdev->drv_data = NULL;
-- 
1.7.5.4

