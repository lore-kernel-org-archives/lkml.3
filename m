Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbbAIR0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:26:40 -0500
Received: from sauhun.de ([89.238.76.85]:49552 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbbAIRWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:22:20 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Subject: [RFC 03/11] i2c: at91: make use of the new infrastructure for quirks
Date: Fri,  9 Jan 2015 18:21:33 +0100
Message-Id: <1420824103-24169-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/i2c-at91.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 636fd2efad88..8be7cf6e2747 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -487,30 +487,10 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * The hardware can handle at most two messages concatenated by a
-	 * repeated start via it's internal address feature.
-	 */
-	if (num > 2) {
-		dev_err(dev->dev,
-			"cannot handle more than two concatenated messages.\n");
-		ret = 0;
-		goto out;
-	} else if (num == 2) {
+	if (num == 2) {
 		int internal_address = 0;
 		int i;
 
-		if (msg->flags & I2C_M_RD) {
-			dev_err(dev->dev, "first transfer must be write.\n");
-			ret = -EINVAL;
-			goto out;
-		}
-		if (msg->len > 3) {
-			dev_err(dev->dev, "first message size must be <= 3.\n");
-			ret = -EINVAL;
-			goto out;
-		}
-
 		/* 1st msg is put into the internal address, start with 2nd */
 		m_start = &msg[1];
 		for (i = 0; i < msg->len; ++i) {
@@ -540,6 +520,15 @@ out:
 	return ret;
 }
 
+/*
+ * The hardware can handle at most two messages concatenated by a
+ * repeated start via it's internal address feature.
+ */
+static struct i2c_adapter_quirks at91_twi_quirks = {
+	.flags = I2C_ADAPTER_QUIRK_COMB_WRITE_FIRST,
+	.max_comb_write_len = 3,
+};
+
 static u32 at91_twi_func(struct i2c_adapter *adapter)
 {
 	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
@@ -777,6 +766,7 @@ static int at91_twi_probe(struct platform_device *pdev)
 	dev->adapter.owner = THIS_MODULE;
 	dev->adapter.class = I2C_CLASS_DEPRECATED;
 	dev->adapter.algo = &at91_twi_algorithm;
+	dev->adapter.quirks = &at91_twi_quirks;
 	dev->adapter.dev.parent = dev->dev;
 	dev->adapter.nr = pdev->id;
 	dev->adapter.timeout = AT91_I2C_TIMEOUT;
-- 
2.1.3

