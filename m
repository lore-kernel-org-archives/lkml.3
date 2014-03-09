Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaCIEBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 23:01:11 -0500
Received: from nm1-vm1.bullet.mail.gq1.yahoo.com ([98.136.218.80]:26902 "EHLO
	nm1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbaCIEBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 23:01:09 -0500
X-Yahoo-Newman-Id: 602372.73419.bm@smtp234.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GtsVLuAVM1lL8WnhUGGiNzINa_CLUj4bCyQbXF8kiGtaQNS
 8woTLDckWADF8hLUIJBqaPNxct.aI0fgg42KFrhqvQED559Z0btQmZTkq0hh
 gUpZ3yVObSeM.dBlTjoZ0rSob_6pV.IzD4SmL8kWNdVDdSW31skthO7fPMtA
 SphDvs0.Dl_mIGbv6MpIpy.YyUUxtuWtQy2DLZQ9Mt_BI47Crxm2pyphA67o
 j_d07h4PQS6BAdcgsuYMuWY7YV4WrBP2wWFqBIhHQyInd5JuybnDYr61Z15c
 U0zB9Ha5DPW571GpBWNKv61MuChRSjvrOukXBX6PjAquHwY4IdDSH8lEtjWR
 0ZiJWaqI9ghUcgmzA5R4QtdDKuXLpb2Z9HnkufvqVOyxA5y6fyr9kUkA9MZX
 p3OBZA2bDJ_jzANW3VMdH6EhYBichNTdefXEbeQUrV6xWGHOXDiuiZHvcNux
 G0v1Y.6LCB72BCYjGMn_lIhIPpAZid7A0hFpyXOuVJIibN6TLOMVgM5qyye0
 8h5P75rZ5yJ0dPlMJgzMxK4Zff.FtztZCGRaRBg--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp234.mail.gq1.yahoo.com with SMTP; 09 Mar 2014 04:01:08 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts in s626.c
Date: Sat,  8 Mar 2014 22:00:54 -0600
Message-Id: <1394337654-27379-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140309030056.GA10867@kroah.com>
References: <20140309030056.GA10867@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a handful of while loops to timeouts to prevent
infinite looping on hardware failure. A couple such loops are in a
function (s626_debi_transfer()) which is called from critical sections,
so comedi_timeout() is unusable for them, and an iterative timeout is
used instead. For the while loops in a context where comedi_timeout() is
allowed, a new callback function, s626_send_dac_eoc(), has been defined
to evaluate the conditions that the while loops are testing.  The new
callback employs a switch statement based on a simple new enum so that
it is usable for all of the different conditions tested in while loops
in s626_send_dac().  The proper comedi_timeout() calls are then used.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
Ian, here is a version of this patchset employing the enum you recommended.
The second patch has been rebased on top of this one.

2: Used comedi_timeout() where appropriate, introduce callback function

3: Updated callback to switch on new enum.

 drivers/staging/comedi/drivers/s626.c | 87 ++++++++++++++++++++++++++++++-----
 1 file changed, 75 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 5ba4b4a..ff9dde1 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -209,6 +209,8 @@ static const struct comedi_lrange s626_range_table = {
 static void s626_debi_transfer(struct comedi_device *dev)
 {
 	struct s626_private *devpriv = dev->private;
+	static const int timeout = 10000;
+	int i;
 
 	/* Initiate upload of shadow RAM to DEBI control register */
 	s626_mc_enable(dev, S626_MC2_UPLD_DEBI, S626_P_MC2);
@@ -217,12 +219,22 @@ static void s626_debi_transfer(struct comedi_device *dev)
 	 * Wait for completion of upload from shadow RAM to
 	 * DEBI control register.
 	 */
-	while (!s626_mc_test(dev, S626_MC2_UPLD_DEBI, S626_P_MC2))
-		;
+	for (i = 0; i < timeout; i++) {
+		if (s626_mc_test(dev, S626_MC2_UPLD_DEBI, S626_P_MC2))
+			break;
+		udelay(1);
+	}
+	if (i == timeout)
+		comedi_error(dev, "Timeout while uploading to DEBI control register.");
 
 	/* Wait until DEBI transfer is done */
-	while (readl(devpriv->mmio + S626_P_PSR) & S626_PSR_DEBI_S)
-		;
+	for (i = 0; i < timeout; i++) {
+		if (!(readl(devpriv->mmio + S626_P_PSR) & S626_PSR_DEBI_S))
+			break;
+		udelay(1);
+	}
+	if (i == timeout)
+		comedi_error(dev, "DEBI transfer timeout.");
 }
 
 /*
@@ -351,6 +363,48 @@ static const uint8_t s626_trimadrs[] = {
 	0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63
 };
 
+enum {
+	s626_send_dac_wait_not_mc1_a2out,
+	s626_send_dac_wait_ssr_af2_out,
+	s626_send_dac_wait_fb_buffer2_msb_00,
+	s626_send_dac_wait_fb_buffer2_msb_ff
+};
+
+static int s626_send_dac_eoc(struct comedi_device *dev,
+			     struct comedi_subdevice *s,
+			     struct comedi_insn *insn,
+			     unsigned long context)
+{
+	struct s626_private *devpriv = dev->private;
+	unsigned int status;
+
+	switch (context) {
+	case s626_send_dac_wait_not_mc1_a2out:
+		status = readl(devpriv->mmio + S626_P_MC1);
+		if (!(status & S626_MC1_A2OUT))
+			return 0;
+		break;
+	case s626_send_dac_wait_ssr_af2_out:
+		status = readl(devpriv->mmio + S626_P_SSR);
+		if (status & S626_SSR_AF2_OUT)
+			return 0;
+		break;
+	case s626_send_dac_wait_fb_buffer2_msb_00:
+		status = readl(devpriv->mmio + S626_P_FB_BUFFER2);
+		if (!(status & 0xff000000))
+			return 0;
+		break;
+	case s626_send_dac_wait_fb_buffer2_msb_ff:
+		status = readl(devpriv->mmio + S626_P_FB_BUFFER2);
+		if (status & 0xff000000)
+			return 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return -EBUSY;
+}
+
 /*
  * Private helper function: Transmit serial data to DAC via Audio
  * channel 2.  Assumes: (1) TSL2 slot records initialized, and (2)
@@ -359,6 +413,7 @@ static const uint8_t s626_trimadrs[] = {
 static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
+	int ret;
 
 	/* START THE SERIAL CLOCK RUNNING ------------- */
 
@@ -404,8 +459,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * Done by polling the DMAC enable flag; this flag is automatically
 	 * cleared when the transfer has finished.
 	 */
-	while (readl(devpriv->mmio + S626_P_MC1) & S626_MC1_A2OUT)
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
+			     s626_send_dac_wait_not_mc1_a2out);
+	if (ret)
+		comedi_error(dev, "DMA transfer timeout.");
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -425,8 +482,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * finished transferring the DAC's data DWORD from the output FIFO
 	 * to the output buffer register.
 	 */
-	while (!(readl(devpriv->mmio + S626_P_SSR) & S626_SSR_AF2_OUT))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
+			     s626_send_dac_wait_ssr_af2_out);
+	if (ret)
+		comedi_error(dev, "TSL timeout waiting for slot 1 to execute.");
 
 	/*
 	 * Set up to trap execution at slot 0 when the TSL sequencer cycles
@@ -466,8 +525,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
 		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
 		 */
-		while (readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000)
-			;
+		ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
+				     s626_send_dac_wait_fb_buffer2_msb_00);
+		if (ret)
+			comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
 	}
 	/*
 	 * Either (1) we were too late setting the slot 0 trap; the TSL
@@ -486,8 +547,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
 	 * from 0x00 to 0xFF.
 	 */
-	while (!(readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
+			     s626_send_dac_wait_fb_buffer2_msb_ff);
+	if (ret)
+		comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
 }
 
 /*
-- 
1.8.5.3

