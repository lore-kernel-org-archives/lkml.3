Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaCZDoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:44:22 -0400
Received: from nm9-vm1.bullet.mail.gq1.yahoo.com ([98.136.218.240]:54007 "EHLO
	nm9-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbaCZDoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:44:20 -0400
X-Yahoo-Newman-Id: 92353.18755.bm@smtp234.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0jMtd0IVM1maCetIBetuoZMt7F.UX.ajGYx0M12mjVLTxNr
 drTyDcfm3Gdfk8vOBV8C8mYmq.NKHDz9T3Eb.pIF8c1J_JZZFTICIsYgVhxe
 0rxPJ3E6LVYpMfdDZQu3XHSNSe5ZoCXLGiPwLLzWV_RyHDkjCRvoTEtPDrkY
 ENbIzVXI8MUWfUawhPQ5VaL0n0mZsl9E25v_VdjkqJSCHa1MvCw4FxblmW8_
 MQaL6O.IlF8OfQR7ZeD9UAvgQRMubP4BEhSGEwLKYbjGErEAEtHYsNEnWl38
 M.CyfaJ09WTYejmmbBSc448l7aChLXDlA1AXKxBBC2siPZu3bkkwCa9knzG3
 MKy6q9K4Bl5sEYAAMOIVomGmMdcdnhDYM1g._cPs7jGT5vfuV4o3EVCAvUhj
 3Aa7YIthaGLy7inkuGxbmXNY1rcer_e.I9IMTbMOKE8oYo8xyE84phI4MMcR
 Tu.wYbe_N16oO1emj83tqcXBrkL.yqeqRe1A.qRm1m6.ukNkLsMlOL1M0w0u
 NPUoS7otZ
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.hotspot (chase.southwood@72.152.71.177 with plain [63.250.193.228])
        by smtp234.mail.gq1.yahoo.com with SMTP; 26 Mar 2014 03:44:20 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2] staging: comedi: s626: use comedi_timeout() on remaining loops
Date: Tue, 25 Mar 2014 22:43:58 -0500
Message-Id: <1395805438-12259-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were just a handful of more while loops in this file that needed
timeouts, and this patch takes care of them.  One new callback is
introduced, and all of the proper comedi_timeout() calls are then used.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
2: s626_i2c_handshake_eoc() can be used in s626_initialize() as noted by
Ian.  So, s626_initialize_eoc() has been removed, and its uses swapped
for s626_i2c_handshake_eoc().

 drivers/staging/comedi/drivers/s626.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 95fadf3..865cf93 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -295,10 +295,24 @@ static void s626_debi_replace(struct comedi_device *dev, unsigned int addr,
 
 /* **************  EEPROM ACCESS FUNCTIONS  ************** */
 
+static int s626_i2c_handshake_eoc(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn,
+				 unsigned long context)
+{
+	unsigned int status;
+
+	status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
+	if (status)
+		return 0;
+	return -EBUSY;
+}
+
 static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
 	unsigned int ctrl;
+	uint32_t ret;
 
 	/* Write I2C command to I2C Transfer Control shadow register */
 	writel(val, devpriv->mmio + S626_P_I2CCTRL);
@@ -308,8 +322,9 @@ static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
 	 * wait for upload confirmation.
 	 */
 	s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
-	while (!s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
+	if (ret)
+		return ret;
 
 	/* Wait until I2C bus transfer is finished or an error occurs */
 	do {
@@ -2029,8 +2044,9 @@ static int s626_ai_insn_read(struct comedi_device *dev,
 	/* Wait for the data to arrive in FB BUFFER 1 register. */
 
 	/* Wait for ADC done */
-	while (!(readl(devpriv->mmio + S626_P_PSR) & S626_PSR_GPIO2))
-		;
+	ret = comedi_timeout(dev, s, insn, s626_ai_eoc, 0);
+	if (ret)
+		return ret;
 
 	/* Fetch ADC data from audio interface's input shift register. */
 
@@ -2681,8 +2697,9 @@ static int s626_initialize(struct comedi_device *dev)
 	writel(S626_I2C_CLKSEL | S626_I2C_ABORT,
 	       devpriv->mmio + S626_P_I2CSTAT);
 	s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
-	while (!(readl(devpriv->mmio + S626_P_MC2) & S626_MC2_UPLD_IIC))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
+	if (ret)
+		return ret;
 
 	/*
 	 * Per SAA7146 data sheet, write to STATUS
@@ -2691,8 +2708,9 @@ static int s626_initialize(struct comedi_device *dev)
 	for (i = 0; i < 2; i++) {
 		writel(S626_I2C_CLKSEL, devpriv->mmio + S626_P_I2CSTAT);
 		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
-		while (!s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2))
-			;
+		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
+		if (ret)
+			return ret;
 	}
 
 	/*
-- 
1.8.5.3

