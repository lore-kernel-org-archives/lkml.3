Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab3ICAJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:09:39 -0400
Received: from 219-118-191-131.cust.bit-drive.ne.jp ([219.118.191.131]:55760
	"EHLO mail.omesemicon.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759136Ab3ICAJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:09:30 -0400
From: Nguyen Viet Dung <nv-dung@jinso.co.jp>
To: linux-i2c@vger.kernel.org, wsa@the-dreams.de
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com
Subject: [PATCH v4 1/1 resend] i2c: rcar: modify I2C driver
Date: Tue,  3 Sep 2013 09:09:25 +0900
Message-Id: <1378166965-3343-2-git-send-email-nv-dung@jinso.co.jp>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378166965-3343-1-git-send-email-nv-dung@jinso.co.jp>
References: <1378166965-3343-1-git-send-email-nv-dung@jinso.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modify I2C driver of rcar-H1 to usable on both rcar-H1 and rcar-H2.

Signed-off-by: Nguyen Viet Dung <nv-dung@jinso.co.jp>
---
 drivers/i2c/busses/i2c-rcar.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 0fc5858..32ec693 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -101,6 +101,11 @@ enum {
 #define ID_ARBLOST	(1 << 3)
 #define ID_NACK		(1 << 4)
 
+enum rcar_i2c_type {
+	I2C_RCAR_H1,
+	I2C_RCAR_H2,
+};
+
 struct rcar_i2c_priv {
 	void __iomem *io;
 	struct i2c_adapter adap;
@@ -113,6 +118,7 @@ struct rcar_i2c_priv {
 	int irq;
 	u32 icccr;
 	u32 flags;
+	enum rcar_i2c_type	devtype;
 };
 
 #define rcar_i2c_priv_to_dev(p)		((p)->adap.dev.parent)
@@ -224,12 +230,25 @@ static int rcar_i2c_clock_calculate(struct rcar_i2c_priv *priv,
 	u32 scgd, cdf;
 	u32 round, ick;
 	u32 scl;
+	u32 cdf_width;
 
 	if (!clkp) {
 		dev_err(dev, "there is no peripheral_clk\n");
 		return -EIO;
 	}
 
+	switch (priv->devtype) {
+	case I2C_RCAR_H1:
+		cdf_width = 2;
+		break;
+	case I2C_RCAR_H2:
+		cdf_width = 3;
+		break;
+	default:
+		dev_err(dev, "device type error\n");
+		return -EIO;
+	}
+
 	/*
 	 * calculate SCL clock
 	 * see
@@ -245,7 +264,7 @@ static int rcar_i2c_clock_calculate(struct rcar_i2c_priv *priv,
 	 * clkp : peripheral_clk
 	 * F[]  : integer up-valuation
 	 */
-	for (cdf = 0; cdf < 4; cdf++) {
+	for (cdf = 0; cdf < (1 << cdf_width); cdf++) {
 		ick = clk_get_rate(clkp) / (1 + cdf);
 		if (ick < 20000000)
 			goto ick_find;
@@ -287,7 +306,7 @@ scgd_find:
 	/*
 	 * keep icccr value
 	 */
-	priv->icccr = (scgd << 2 | cdf);
+	priv->icccr = (scgd << (cdf_width) | cdf);
 
 	return 0;
 }
@@ -632,6 +651,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	bus_speed = 100000; /* default 100 kHz */
 	if (pdata && pdata->bus_speed)
 		bus_speed = pdata->bus_speed;
+
+	priv->devtype = platform_get_device_id(pdev)->driver_data;
+
 	ret = rcar_i2c_clock_calculate(priv, bus_speed, dev);
 	if (ret < 0)
 		return ret;
@@ -686,6 +708,14 @@ static int rcar_i2c_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id rcar_i2c_id_table[] = {
+	{ "i2c-rcar",		I2C_RCAR_H1 },
+	{ "i2c-rcar_h1",	I2C_RCAR_H1 },
+	{ "i2c-rcar_h2",	I2C_RCAR_H2 },
+	{},
+};
+MODULE_DEVICE_TABLE(platform, rcar_i2c_id_table);
+
 static struct platform_driver rcar_i2c_driver = {
 	.driver	= {
 		.name	= "i2c-rcar",
@@ -693,6 +723,7 @@ static struct platform_driver rcar_i2c_driver = {
 	},
 	.probe		= rcar_i2c_probe,
 	.remove		= rcar_i2c_remove,
+	.id_table	= rcar_i2c_id_table,
 };
 
 module_platform_driver(rcar_i2c_driver);
-- 
1.7.9.5

