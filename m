Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbbAPOkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:40:31 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51752 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbbAPOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:40:23 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-c9-54b922d658da
From: Paul Osmialowski <p.osmialowsk@samsung.com>
To: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 3/3] i2c: s3c2410: Adopt i2c-s3c2410 driver for new enhancement
 of i2c API
Date: Fri, 16 Jan 2015 15:39:54 +0100
Message-id: <1421419194-1849-3-git-send-email-p.osmialowsk@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Zd1rSjtDDDpXiFlMffiEzeLJgXZG
	i+bF69ks+h+/ZrZY2LaExaLj7xdGi8u75rBZzDi/j8liwpsDzBYrT8xiduDy2LSqk81j/9w1
	7B6L+yazevRtWcXocfLUExaPz5vkAtiiuGxSUnMyy1KL9O0SuDIeLPrFXLBaquLCmn+sDYzr
	RbsYOTkkBEwkri3czgxhi0lcuLeerYuRi0NIYCmjxM1nU6GcXiaJHZ//gVWxCRhK3Px/mBEk
	ISKwg0ni4b3DbCAJZgF9iab+p2BFwgJREvuOnweLswioShzdv4S9i5GDg1fAXaJnhxjENjmJ
	k8cms4LYnAIeEkvP/gZrFQIqef64m20CI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GCHh93UH49JjVocYBTgYlXh4HTbtCBFiTSwrrsw9xCjBwawkwpshsDNEiDclsbIqtSg/vqg0
	J7X4ECMTB6dUAyPL+4zQ1arVx8/9uMr/YdMCGfH3F2SLI9f52BybnnBY8W+6zI0lNrYZ7zZ4
	6eQ2GbbMDt8y3XeesYCT941w2UkRM7h512y8Jnd87b9l8zMXvWxi7VrWqshqsfC10Iu3L76u
	SF4sfuvjBaYZhq/PJyQpbFaNuBZWPcFuc/s/gTU/+Jot1pj+ZVFSYinOSDTUYi4qTgQAk6bk
	bR0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adopts i2c-s3c2410 driver for new enhancement of i2c API that
exposes preparation and unpreparation stages of i2c transfer.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 drivers/i2c/busses/i2c-s3c2410.c | 69 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index bff20a5..4af8a9c 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -130,6 +130,8 @@ struct s3c24xx_i2c {
 #endif
 	struct regmap		*sysreg;
 	unsigned int		sys_i2c_cfg;
+
+	int			xfer_prepared;
 };
 
 static struct platform_device_id s3c24xx_driver_ids[] = {
@@ -771,6 +773,58 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
 	return ret;
 }
 
+/* s3c24xx_i2c_prepare_xfer
+ *
+ * prepare for transferring message across the i2c bus (may sleep)
+ *
+ * returns 0 on success
+ */
+
+static int s3c24xx_i2c_prepare_xfer(struct i2c_adapter *adap)
+{
+	struct s3c24xx_i2c *i2c = (struct s3c24xx_i2c *)adap->algo_data;
+
+	if (i2c->xfer_prepared == 0) {
+		int ret;
+
+		pm_runtime_get_sync(&adap->dev);
+
+		ret = clk_prepare_enable(i2c->clk);
+		if (ret) {
+			pm_runtime_put(&adap->dev);
+			return ret;
+		}
+
+	}
+
+	i2c->xfer_prepared++;
+
+	return 0;
+}
+
+/* s3c24xx_i2c_unprepare_xfer
+ *
+ * unprepare after transferring message across the i2c bus (may sleep)
+ */
+
+static void s3c24xx_i2c_unprepare_xfer(struct i2c_adapter *adap)
+{
+	struct s3c24xx_i2c *i2c = (struct s3c24xx_i2c *)adap->algo_data;
+
+	if (i2c->xfer_prepared == 1) {
+		clk_disable_unprepare(i2c->clk);
+		pm_runtime_put(&adap->dev);
+	}
+
+	i2c->xfer_prepared--;
+
+	if (unlikely(i2c->xfer_prepared < 0)) {
+		pr_err("%s: i2c->xfer_prepared = %d < 0\n",
+			__func__, i2c->xfer_prepared);
+		i2c->xfer_prepared = 0;
+	}
+}
+
 /* s3c24xx_i2c_xfer
  *
  * first port of call from the i2c bus code when an message needs
@@ -784,16 +838,16 @@ static int s3c24xx_i2c_xfer(struct i2c_adapter *adap,
 	int retry;
 	int ret;
 
-	pm_runtime_get_sync(&adap->dev);
-	clk_prepare_enable(i2c->clk);
+	ret = s3c24xx_i2c_prepare_xfer(adap);
+	if (ret)
+		return ret;
 
 	for (retry = 0; retry < adap->retries; retry++) {
 
 		ret = s3c24xx_i2c_doxfer(i2c, msgs, num);
 
 		if (ret != -EAGAIN) {
-			clk_disable_unprepare(i2c->clk);
-			pm_runtime_put(&adap->dev);
+			s3c24xx_i2c_unprepare_xfer(adap);
 			return ret;
 		}
 
@@ -802,8 +856,8 @@ static int s3c24xx_i2c_xfer(struct i2c_adapter *adap,
 		udelay(100);
 	}
 
-	clk_disable_unprepare(i2c->clk);
-	pm_runtime_put(&adap->dev);
+	s3c24xx_i2c_unprepare_xfer(adap);
+
 	return -EREMOTEIO;
 }
 
@@ -818,6 +872,8 @@ static u32 s3c24xx_i2c_func(struct i2c_adapter *adap)
 
 static const struct i2c_algorithm s3c24xx_i2c_algorithm = {
 	.master_xfer		= s3c24xx_i2c_xfer,
+	.master_prepare_xfer	= s3c24xx_i2c_prepare_xfer,
+	.master_unprepare_xfer	= s3c24xx_i2c_unprepare_xfer,
 	.functionality		= s3c24xx_i2c_func,
 };
 
@@ -1152,6 +1208,7 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 	i2c->adap.retries = 2;
 	i2c->adap.class = I2C_CLASS_DEPRECATED;
 	i2c->tx_setup = 50;
+	i2c->xfer_prepared = 0;
 
 	init_waitqueue_head(&i2c->wait);
 
-- 
1.9.1

