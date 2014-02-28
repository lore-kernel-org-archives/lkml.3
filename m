Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaB1Hfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:35:42 -0500
Received: from nm12-vm10.bullet.mail.gq1.yahoo.com ([98.136.218.139]:22909
	"EHLO nm12-vm10.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbaB1Hfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:35:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=HNTouVz0AgHEs0sGS+616EPd8boAn0qh+TQK3d+MiM1KzUZ+w3ff4edZjjTUR5KrWAfZocvknaJDGu05QOLIi97xdJISCQ5G9SKufjAFZFeEwsqKn8XT62hnq2uu6kY1sco2FjNZQHEruR35grZ5OVVjDUgDDN9sVP1I87ukKb4=;
X-Yahoo-Newman-Id: 184338.70357.bm@smtp234.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _aWdqLIVM1kLWnL0Hhx0p2pJVI23prPqgy6_i22Vv0i6VPi
 O.4gB7OVnylJOxXSLdmCKx7aI7P22IbAit5ZIz5nUZtrGbed5nT6QuDtu57u
 1vMtY41onWt_HzpI.512qgLwM2PJlzIYXAMzKLZwWNEHN8GcMjEA.VrHacmg
 lkYPAFZWwPaR6ZEoxz744BJvTYy8eMO4h7oKZVyPghVEC.zRmiYIkDkPhCDT
 giMljVbSX7fxbL6WMkh6m3iTjpNF61U9kADhK_z0spgewEXCzl8RT8QOG360
 ImFgSwH2YOplnU3wahxv59UH0z.2pWtt6GoDJ7iM0c2Z4i0B8fodDbefKQOP
 CdZvCtyqCBp_deBRuk7wdLicFB80NbA2Y2Hpzw8jScZXWA3x79c6vhZM9UhN
 uhVkKMZBWtvF5BTSTpAjGGaFfsMN0fSwUdy.5Ugg5hTW0wpZJ9lFcnFPJWcG
 UkyNPIDYBX_ZsegRPl0e1rSekMuCH1NlU1Xe0cd7ZHSkB59A9_imh9_Jmiam
 kMLQS34zEXpfCH1668Lkl9.qleNLf09O5zapO
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp234.mail.gq1.yahoo.com with SMTP; 28 Feb 2014 07:35:40 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: add timeouts to while loops in s626.c
Date: Fri, 28 Feb 2014 01:35:36 -0600
Message-Id: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch located a handful of while loops testing readl calls in s626.c.
Since these while loops depend on readl succeeding, it's safer to make
sure they time out eventually.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
Ian and/or Hartley, I'd love your comments on this.  It seems to me that
we want these kinds of while loops properly timed out, but I want to make
sure I'm doing everything properly.  First off, s626_debi_transfer() says
directly that it is called from within critical sections, so I assume
that means that the new comedi_timeout() function is no good here, and
s626_send_dac() looked equally suspicious, so I opted for iterative
timeouts.  Is this correct?  Also, for these timeouts, I used a very
conservative 10000 iterations, would it be better to decrease that?
Also, do my error strings appear acceptable?

And finally, are timeouts here even necessary or helpful, or are there
any better ways to do it?

Thanks,
Chase

 drivers/staging/comedi/drivers/s626.c | 49 ++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 5ba4b4a..282636b 100644
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
@@ -221,8 +223,13 @@ static void s626_debi_transfer(struct comedi_device *dev)
 		;
 
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
@@ -359,6 +366,8 @@ static const uint8_t s626_trimadrs[] = {
 static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
+	static const int timeout = 10000;
+	int i;
 
 	/* START THE SERIAL CLOCK RUNNING ------------- */
 
@@ -404,8 +413,13 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * Done by polling the DMAC enable flag; this flag is automatically
 	 * cleared when the transfer has finished.
 	 */
-	while (readl(devpriv->mmio + S626_P_MC1) & S626_MC1_A2OUT)
-		;
+	for  (i = 0; i < timeout; i++) {
+		if (!(readl(devpriv->mmio + S626_P_MC1) & S626_MC1_A2OUT))
+			break;
+		udelay(1);
+	}
+	if (i == timeout)
+		comedi_error(dev, "DMA transfer timeout.");
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -425,8 +439,13 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * finished transferring the DAC's data DWORD from the output FIFO
 	 * to the output buffer register.
 	 */
-	while (!(readl(devpriv->mmio + S626_P_SSR) & S626_SSR_AF2_OUT))
-		;
+	for (i = 0; i < timeout; i++) {
+		if (readl(devpriv->mmio + S626_P_SSR) & S626_SSR_AF2_OUT)
+			break;
+		udelay(1);
+	}
+	if (i == timeout)
+		comedi_error(dev, "TSL timeout waiting for slot 1 to execute.");
 
 	/*
 	 * Set up to trap execution at slot 0 when the TSL sequencer cycles
@@ -466,8 +485,13 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 		 * from 0xFF to 0x00, which slot 0 causes to happen by shifting
 		 * out/in on SD2 the 0x00 that is always referenced by slot 5.
 		 */
-		while (readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000)
-			;
+		for (i = 0; i < timeout; i++) {
+			if (!(readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000))
+				break;
+			udelay(1);
+		}
+		if (i == timeout)
+			comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
 	}
 	/*
 	 * Either (1) we were too late setting the slot 0 trap; the TSL
@@ -486,8 +510,13 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * the next DAC write.  This is detected when FB_BUFFER2 MSB changes
 	 * from 0x00 to 0xFF.
 	 */
-	while (!(readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000))
-		;
+	for (i = 0; i < timeout; i++) {
+		if (readl(devpriv->mmio + S626_P_FB_BUFFER2) & 0xff000000)
+			break;
+		udelay(1);
+	}
+	if (i == timeout)
+		comedi_error(dev, "TLS timeout waiting for slot 0 to execute.");
 }
 
 /*
-- 
1.8.5.3

