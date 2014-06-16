Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaFPNGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:06:22 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36424 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaFPNGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:06:20 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Mark A. Greer" <mgreer@animalcreek.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] NFC: trf7970a: Move trf7970a_init inside #ifdef CONFIG_PM_RUNTIME
Date: Mon, 16 Jun 2014 15:06:13 +0200
Message-Id: <1402923973-24316-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_RUNTIME=n:

drivers/nfc/trf7970a.c:755: warning: ‘trf7970a_init’ defined but not used

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/nfc/trf7970a.c | 80 +++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 3b78b031e617..41a153ecc6ed 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -751,45 +751,6 @@ static void trf7970a_timeout_work_handler(struct work_struct *work)
 	mutex_unlock(&trf->lock);
 }
 
-static int trf7970a_init(struct trf7970a *trf)
-{
-	int ret;
-
-	dev_dbg(trf->dev, "Initializing device - state: %d\n", trf->state);
-
-	ret = trf7970a_cmd(trf, TRF7970A_CMD_SOFT_INIT);
-	if (ret)
-		goto err_out;
-
-	ret = trf7970a_cmd(trf, TRF7970A_CMD_IDLE);
-	if (ret)
-		goto err_out;
-
-	/* Must clear NFC Target Detection Level reg due to erratum */
-	ret = trf7970a_write(trf, TRF7970A_NFC_TARGET_LEVEL, 0);
-	if (ret)
-		goto err_out;
-
-	ret = trf7970a_write(trf, TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS,
-			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLH_96 |
-			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLL_32);
-	if (ret)
-		goto err_out;
-
-	ret = trf7970a_write(trf, TRF7970A_SPECIAL_FCN_REG1, 0);
-	if (ret)
-		goto err_out;
-
-	trf->special_fcn_reg1 = 0;
-
-	trf->iso_ctrl = 0xff;
-	return 0;
-
-err_out:
-	dev_dbg(trf->dev, "Couldn't init device: %d\n", ret);
-	return ret;
-}
-
 static void trf7970a_switch_rf_off(struct trf7970a *trf)
 {
 	dev_dbg(trf->dev, "Switching rf off\n");
@@ -1430,6 +1391,45 @@ static int trf7970a_pm_runtime_suspend(struct device *dev)
 	return ret;
 }
 
+static int trf7970a_init(struct trf7970a *trf)
+{
+	int ret;
+
+	dev_dbg(trf->dev, "Initializing device - state: %d\n", trf->state);
+
+	ret = trf7970a_cmd(trf, TRF7970A_CMD_SOFT_INIT);
+	if (ret)
+		goto err_out;
+
+	ret = trf7970a_cmd(trf, TRF7970A_CMD_IDLE);
+	if (ret)
+		goto err_out;
+
+	/* Must clear NFC Target Detection Level reg due to erratum */
+	ret = trf7970a_write(trf, TRF7970A_NFC_TARGET_LEVEL, 0);
+	if (ret)
+		goto err_out;
+
+	ret = trf7970a_write(trf, TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS,
+			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLH_96 |
+			TRF7970A_ADJUTABLE_FIFO_IRQ_LEVELS_WLL_32);
+	if (ret)
+		goto err_out;
+
+	ret = trf7970a_write(trf, TRF7970A_SPECIAL_FCN_REG1, 0);
+	if (ret)
+		goto err_out;
+
+	trf->special_fcn_reg1 = 0;
+
+	trf->iso_ctrl = 0xff;
+	return 0;
+
+err_out:
+	dev_dbg(trf->dev, "Couldn't init device: %d\n", ret);
+	return ret;
+}
+
 static int trf7970a_pm_runtime_resume(struct device *dev)
 {
 	struct spi_device *spi = container_of(dev, struct spi_device, dev);
@@ -1462,7 +1462,7 @@ static int trf7970a_pm_runtime_resume(struct device *dev)
 
 	return 0;
 }
-#endif
+#endif /* CONFIG_PM_RUNTIME */
 
 static const struct dev_pm_ops trf7970a_pm_ops = {
 	SET_RUNTIME_PM_OPS(trf7970a_pm_runtime_suspend,
-- 
1.9.1

