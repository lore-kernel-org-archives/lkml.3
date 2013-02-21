Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3BURQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:03 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:61540 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3BURP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:15:59 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net
Subject: [PATCHv2 01/10] remoteproc: Bugfix: Deallocate firmware image on shutdown
Date: Thu, 21 Feb 2013 18:15:31 +0100
Message-Id: <1361466940-6813-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>

Fixes coherent memory leakage, caused by non-deallocated
firmware image chunk.

Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
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

