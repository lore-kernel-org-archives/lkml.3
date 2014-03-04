Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaCDIny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:43:54 -0500
Received: from nm22-vm7.bullet.mail.gq1.yahoo.com ([98.136.217.70]:38494 "EHLO
	nm22-vm7.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410AbaCDInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:43:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=Uo+nMhUia2fGvu9riH5ZCjv46iiiNv2cBP44zlILQEtyaD6kW+Lf5C1Au9pwOHgPma24y79hYzYs+0JW4LO56/i6tFhOYQAs+n2pV+gN0L10+x5x/WwKVW8RiHDqXE7YJjb2SG340J5nzam4bjQyLG4wxirKrao6DQel7LsXLL0=;
X-Yahoo-Newman-Id: 108349.16064.bm@smtp230.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _9oPLH4VM1lg6iXofjNdmC1tXE8LjXdEyBfsUCAxbZ1Owsf
 15WcBdE51gmeAfP.MVuKIF0snN1vd3ZC.FdB.7pLmSn5Znnv.tM_AOBoTlnX
 D59qyji882DSoY6x8PHnylgygbCuMUzuWbKCWYXaV2fXJz_U1qG59ykC9yjH
 G2x6dj.YyJMPP8EorvHr82mo9Dwe0h070_NIPyvsHD2ceydA87xRx6BhrTGi
 5DBcrpFxqmC9FfPC_bJs1.PsT9kTb2i1tRyJnAW04mwoCXoSrrIdkrJ04vOl
 Gu_hRlIUFqGm_uUvFIXvEfLgiQdMpgdUj0Gphk5C4FMW3oAsvqL8dMSKI8Dz
 p6.dYBVM.nt1TPjPKg89KkZ0pPYepnUzxInLZwWsqtfLJgjuxvnsQQLlmPbI
 V1aCOavRFY8wvFKEFYkVhFxuNcGlzVJpEQRgTpyEyfagERVIIZMXReTEGUGv
 gAmI91B0v3i2UGkYlj2TDAJvAuWdfj4RI2bRB0jjKkNhxWLrqJqtBuGxJ20D
 HHYRc0unlsBByaS.Ar5Wd0eFEymCs1m9QoYy3RQ--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp230.mail.gq1.yahoo.com with SMTP; 04 Mar 2014 08:43:52 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2 1/2] Staging: comedi: convert while loops to timeouts in s626.c
Date: Tue,  4 Mar 2014 02:43:48 -0600
Message-Id: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a handful of while loops to timeouts to prevent
infinite looping on hardware failure.  A couple such loops are in a
function (s626_debi_transfer()) which is called from critical sections,
so comedi_timeout() is unusable for them, and an iterative timeout is
used instead.  For the while loops in a context where comedi_timeout() is
allowed, a new callback function, s626_send_dac_eoc(), has been defined
to evaluate the conditions that the while loops are testing.  The new
callback employs a switch statement based on the register offset values
that the status is to be checked from, as this information is enough to
recreate the entire readl() call, and is passed in the 'context'
parameter.  A couple of additional macros have been defined where this
method is not completely sufficient.  The proper comedi_timeout() calls
are then used.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
Ian, my idea for the callback function here is a bit iffy, I'd love to
hear your feedback.  I've created the ret variable because patch 2/2
propogates all errors upwards.

2: Now using comedi_timeout() where allowable.

 drivers/staging/comedi/drivers/s626.c | 81 +++++++++++++++++++++++++++++------
 1 file changed, 69 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 5ba4b4a..5a7e1c0 100644
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
@@ -351,6 +363,44 @@ static const uint8_t s626_trimadrs[] = {
 	0x40, 0x41, 0x42, 0x50, 0x51, 0x52, 0x53, 0x60, 0x61, 0x62, 0x63
 };
 
+#define S626_P_FB_BUFFER2_MSB_00	0
+#define S626_P_FB_BUFFER2_MSB_FF	1
+
+static int s626_send_dac_eoc(struct comedi_device *dev,
+							struct comedi_subdevice *s,
+							struct comedi_insn *insn,
+							unsigned long context)
+{
+	struct s626_private *devpriv = dev->private;
+	unsigned int status;
+
+	switch (context) {
+	case S626_P_MC1:
+		status = readl(devpriv->mmio + S626_P_MC1);
+		if (!(status & S626_MC1_A2OUT))
+			return 0;
+		break;
+	case S626_P_SSR:
+		status = readl(devpriv->mmio + S626_P_SSR);
+		if (status & S626_SSR_AF2_OUT)
+			return 0;
+		break;
+	case S626_P_FB_BUFFER2_MSB_00:
+		status = readl(devpriv->mmio + S626_P_FB_BUFFER2);
+		if (!(status & 0xff000000))
+			return 0;
+		break;
+	case S626_P_FB_BUFFER2_MSB_FF:
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
@@ -359,6 +409,7 @@ static const uint8_t s626_trimadrs[] = {
 static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
+	int ret;
 
 	/* START THE SERIAL CLOCK RUNNING ------------- */
 
@@ -404,8 +455,9 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * Done by polling the DMAC enable flag; this flag is automatically
 	 * cleared when the transfer has finished.
 	 */
-	while (readl(devpriv->mmio + S626_P_MC1) & S626_MC1_A2OUT)
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc, S626_P_MC1);
+	if (ret)
+		comedi_error(dev, "DMA transfer timeout.");
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -425,8 +477,9 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * finished transferring the DAC's data DWORD from the output FIFO
 	 * to the output buffer register.
 	 */
-	while (!(readl(devpriv->mmio + S626_P_SSR) & S626_SSR_AF2_OUT))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc, S626_P_SSR);
+	if (ret)
+		comedi_error(dev, "TSL timeout waiting for slot 1 to execute.");
 
 	/*
 	 * Set up to trap execution at slot 0 when the TSL sequencer cycles
@@ -466,8 +519,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
 		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
 		 */
-		while (readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000)
-			;
+		ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
+							S626_P_FB_BUFFER2_MSB_00);
+		if (ret)
+			comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
 	}
 	/*
 	 * Either (1) we were too late setting the slot 0 trap; the TSL
@@ -486,8 +541,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
 	 * from 0x00 to 0xFF.
 	 */
-	while (!(readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000))
-		;
+	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
+						S626_P_FB_BUFFER2_MSB_FF);
+	if (ret)
+		comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
 }
 
 /*
-- 
1.8.5.3

