Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaCYFKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 01:10:05 -0400
Received: from nm20-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.35]:21447 "EHLO
	nm20-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbaCYFKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 01:10:02 -0400
X-Yahoo-Newman-Id: 217232.89032.bm@smtp222.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3VCAYpMVM1mKuUifFNgnvapqlgjD46Up9BLIoZ5wsJgtzah
 ZhndfWj3rXL2IKZTx88kbOBPezlTRdG1H3ROERWxc1oWhqE069slMryE8apO
 3xYfdBQzNPsPmx0fn8OI8GQH_gVNMGO5dFr1SXSIdAEBFAgmK8vETs.TAMBf
 DJageYzECWDRd__S5frFirT7GHFZsRAl4uw12IHxdPiyCaIg_lb76OrnNIpq
 TKg46h7yEFyLqYxFxNiZatQkMFkudz451V64sogAMjMSu.Fjxx6o2BauDfi0
 S616HFN2WDCelzH6jJckftO7FguUIelE.6X8ykGaj9HKzMRtiY9L84xiY53w
 Ym2Qtso36xW_AD5rxjr_MW7DHjvgYRZwwCPx6jx6cjJ_rjxlRx7d3kHPmHBq
 hHdz5YD3zY3HwnrDHFqmyyFolBNjF36u.dRdLdtaaxLD.AW5lz1ItT5jh5t5
 6ZpAfnTb_BNi_PHS5wXxIWpyafdW5DW4miwtqXIG0MSPfrwIrGoDEo77XzxT
 JBfOpqj1DSZs1MvlrVgQ-
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.hotspot (chase.southwood@72.152.71.177 with plain [63.250.193.228])
        by smtp222.mail.gq1.yahoo.com with SMTP; 25 Mar 2014 05:10:01 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] staging: comedi: s626: use comedi_timeout() on remaining loops
Date: Tue, 25 Mar 2014 00:09:32 -0500
Message-Id: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were just a handful of more while loops in this file that need timeouts,
and this patch takes care of them, using comedi_timeout().  A couple of new
callbacks are introduced, but there was one case where the appropriate callback
function was already defined; in this case I have just used that.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
 drivers/staging/comedi/drivers/s626.c | 66 ++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 95fadf3..4dc5659 100644
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
 
@@ -2641,6 +2657,36 @@ static int s626_allocate_dma_buffers(struct comedi_device *dev)
 	return 0;
 }
 
+enum {
+	s626_initialize_wait_i2c_abort,
+	s626_initialize_wait_i2c_err_reset
+};
+
+static int s626_initialize_eoc(struct comedi_device *dev,
+			      struct comedi_subdevice *s,
+			      struct comedi_insn *insn,
+			      unsigned long context)
+{
+	struct s626_private *devpriv = dev->private;
+	unsigned int status;
+
+	switch (context) {
+	case s626_initialize_wait_i2c_abort:
+		status = readl(devpriv->mmio + S626_P_MC2);
+		if (status & S626_MC2_UPLD_IIC)
+			return 0;
+		break;
+	case s626_initialize_wait_i2c_err_reset:
+		status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
+		if (status)
+			return 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return -EBUSY;
+}
+
 static int s626_initialize(struct comedi_device *dev)
 {
 	struct s626_private *devpriv = dev->private;
@@ -2681,8 +2727,10 @@ static int s626_initialize(struct comedi_device *dev)
 	writel(S626_I2C_CLKSEL | S626_I2C_ABORT,
 	       devpriv->mmio + S626_P_I2CSTAT);
 	s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
-	while (!(readl(devpriv->mmio + S626_P_MC2) & S626_MC2_UPLD_IIC))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_initialize_eoc,
+			     s626_initialize_wait_i2c_abort);
+	if (ret)
+		return ret;
 
 	/*
 	 * Per SAA7146 data sheet, write to STATUS
@@ -2691,8 +2739,10 @@ static int s626_initialize(struct comedi_device *dev)
 	for (i = 0; i < 2; i++) {
 		writel(S626_I2C_CLKSEL, devpriv->mmio + S626_P_I2CSTAT);
 		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
-		while (!s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2))
-			;
+		ret = comedi_timeout(dev, NULL, NULL, s626_initialize_eoc,
+				     s626_initialize_wait_i2c_err_reset);
+		if (ret)
+			return ret;
 	}
 
 	/*
-- 
1.8.5.3

