Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaDCXnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:43:45 -0400
Received: from nm21-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.51]:58439 "EHLO
	nm21-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbaDCXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:43:34 -0400
X-Yahoo-Newman-Id: 305243.74400.bm@smtp231.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Xp3uf5AVM1n7Mr0rU77Z9yyoeutuD47lkOZZUk_IPtTkAIh
 agpOK3XNjrBHAzX8.3GKMhDnY2IUsD1l_EWCnAw82TUmv52yb3S2rG8h7Glj
 AqQJmlyqvZ8DTXLJd7VM.LFf2EiGi7rqZlhWG5BGW9hmP_wy_pMdT6kIZ5lc
 7Gfx.NbULqmCuKHwhtLTgwE4Y4f8eRk1r3dTxwy7TxWIKa0Ozg_CuMb4JMKV
 VQQopAAkmBR9jjXvexJnFEPVegPMHnBlw_qhNOJyE3Yl6ycoMD8ApcEsfsAx
 q489UTujrEJSlZkBNRNZ.QdKQfbpr3jaApKDOJ.JVOnpa51yu5l4f1HgL5TR
 1JIYXD75O.Mew8SPGIC7Sowgr04clEMr0b8_yfJZe_z.KWXDZOfe9NzkjeJv
 _jG_DGG_Ph9eEYj.nD7GBLUo567b43E.T3BRdlRJjQOauVxlUTejMSKmZ_BC
 WRo5zGcFichxOiFu4hFJf_s02ETMnnVV0q7russduHp6dY3KTT_.1jRefzy1
 WXE_wi5Lf
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp231.mail.gq1.yahoo.com with SMTP; 03 Apr 2014 23:43:33 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3] staging: comedi: s626: use comedi_timeout() on remaining loops
Date: Thu,  3 Apr 2014 18:43:27 -0500
Message-Id: <1396568607-23447-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were just a handful of more while loops in this file that needed
timeouts, and this patch takes care of them.  One new callback is
introduced, and all of the proper comedi_timeout() calls are then used.
The return type of s626_i2c_handshake() has been changed from uint32_t to
int so that a negative error code from comedi_timeout() can be propagated
if necessary.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
2: s626_i2c_handshake_eoc() can be used in s626_initialize() as noted by
Ian. So, s626_initialize_eoc() has been removed, and its uses swapped
for s626_i2c_handshake_eoc().

3: *Type of 'status' variable in s626_i2c_handshake_eoc() has been
corrected to bool (the return type of s626_mc_test()).
*Return type of s626_i2c_handshake() has been changed to int to allow
returning negative error codes. 
*Type of 'ret' variable in the same function has been changed to int for
the same reason.
 drivers/staging/comedi/drivers/s626.c | 36 ++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 95fadf3..6da43de 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -295,10 +295,24 @@ static void s626_debi_replace(struct comedi_device *dev, unsigned int addr,
 
 /* **************  EEPROM ACCESS FUNCTIONS  ************** */
 
-static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
+static int s626_i2c_handshake_eoc(struct comedi_device *dev,
+				 struct comedi_subdevice *s,
+				 struct comedi_insn *insn,
+				 unsigned long context)
+{
+	bool status;
+
+	status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
+	if (status)
+		return 0;
+	return -EBUSY;
+}
+
+static int s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
 	unsigned int ctrl;
+	int ret;
 
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
1.9.0

