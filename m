Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaDOQ6l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:58:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36368 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaDOQ6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:58:38 -0400
From: Nishanth Menon <nm@ti.com>
To: Joel Fernandes <joelf@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Joachim Eastwood <manabian@gmail.com>,
        <balbi@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2] crypto: omap-des - handle error of pm_runtime_get_sync
Date: Tue, 15 Apr 2014 11:58:31 -0500
Message-ID: <1397581111-21148-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <534D61DF.9090203@ti.com>
References: <534D61DF.9090203@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_runtime_get_sync may not always succeed depending on SoC involved.
So handle the error appropriately ensuring usage_count is accurate in
case of failure.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
V2:
	- review fixes, print function names in error log as well.

V1: https://patchwork.kernel.org/patch/3993861/
 drivers/crypto/omap-des.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index ec5f131..1d570c4 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -223,12 +223,19 @@ static void omap_des_write_n(struct omap_des_dev *dd, u32 offset,
 
 static int omap_des_hw_init(struct omap_des_dev *dd)
 {
+	int err;
+
 	/*
 	 * clocks are enabled when request starts and disabled when finished.
 	 * It may be long delays between requests.
 	 * Device might go to off mode to save power.
 	 */
-	pm_runtime_get_sync(dd->dev);
+	err = pm_runtime_get_sync(dd->dev);
+	if (err < 0) {
+		pm_runtime_put_noidle(dd->dev);
+		dev_err(dd->dev, "%s: failed to get_sync(%d)\n", __func__, err);
+		return err;
+	}
 
 	if (!(dd->flags & FLAGS_INIT)) {
 		dd->flags |= FLAGS_INIT;
@@ -1083,7 +1090,12 @@ static int omap_des_probe(struct platform_device *pdev)
 	dd->phys_base = res->start;
 
 	pm_runtime_enable(dev);
-	pm_runtime_get_sync(dev);
+	err = pm_runtime_get_sync(dev);
+	if (err < 0) {
+		pm_runtime_put_noidle(dev);
+		dev_err(dd->dev, "%s: failed to get_sync(%d)\n", __func__, err);
+		goto err_get;
+	}
 
 	omap_des_dma_stop(dd);
 
@@ -1148,6 +1160,7 @@ err_algs:
 err_irq:
 	tasklet_kill(&dd->done_task);
 	tasklet_kill(&dd->queue_task);
+err_get:
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
@@ -1191,7 +1204,14 @@ static int omap_des_suspend(struct device *dev)
 
 static int omap_des_resume(struct device *dev)
 {
-	pm_runtime_get_sync(dev);
+	int err;
+
+	err = pm_runtime_get_sync(dev);
+	if (err < 0) {
+		pm_runtime_put_noidle(dev);
+		dev_err(dev, "%s: failed to get_sync(%d)\n", __func__, err);
+		return err;
+	}
 	return 0;
 }
 #endif
-- 
1.7.9.5

