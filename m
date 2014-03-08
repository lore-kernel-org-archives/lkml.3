Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaCHBn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:43:27 -0500
Received: from nm27-vm4.bullet.mail.gq1.yahoo.com ([98.136.216.147]:27801 "EHLO
	nm27-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbaCHBnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:43:25 -0500
X-Yahoo-Newman-Id: 111235.94853.bm@smtp212.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: b3svKoAVM1nDMfVkIgjW1sMxBVqhFtwni6hOhQc_ztcykBz
 LAuAoElHdaulBCvNRXlELfY1iVKuFuMm2FClOk8FjF1S5e_KWnhwxlbEOTPe
 rCgv43P89FTSMAsxjMmsq6yhkdt90hvIcH11BUii_OufUB.j7erNxFPqTdAC
 NA_BtVOb2mK9v.uurViHalSpKpIcPbGTeyAmU7xcoyej_k_9iHuxlOKiW6Lz
 H7nVeBbGUyvq0MIM0HH25jz.ubr7Wy7x.IOukYdvmKzvFWfzUgLygFxxvqa.
 lT22CB6Xs7jFGkdnI3zXirJu_Nj0IZOaQJInKW6ZDvSDy65WuQVn4wfFoWD.
 21MKLtMbWyzWebtJkOkpKlpVZZermBid1Idd4Q6qBcP92uQg194F8rns8vE6
 kLR5BwWpliltJaK_TZMCY5jXLeiwmMtgSN0I6kRsmW2kfN4k_m3H8Fw5ohpm
 B8YcK5Hf53cn1yfPBK.6ktb.AUcP2juxoxBTImcecv3RE_kE_Il3vjASDlyy
 YXEFXAz9uIcxCBBANhy27dy_jhQkWtyWwsI4EoQ--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.139.211.125])
        by smtp212.mail.gq1.yahoo.com with SMTP; 07 Mar 2014 17:43:25 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v3 2/2] Staging: comedi: propagate timeout errors in s626.c
Date: Fri,  7 Mar 2014 19:43:17 -0600
Message-Id: <1394242997-32612-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com>
References: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for s626.c propagates the errors from the newly introduced
calls to comedi_timeout() as far as possible.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
Compile tested.

2: This patch was introduced in v2 of this set.

3: Rebased on top of PATCH 1/2 edits.

 drivers/staging/comedi/drivers/s626.c | 63 +++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index fab8ccf..6518a4c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -410,7 +410,7 @@ static int s626_send_dac_eoc(struct comedi_device *dev,
  * channel 2.  Assumes: (1) TSL2 slot records initialized, and (2)
  * dacpol contains valid target image.
  */
-static void s626_send_dac(struct comedi_device *dev, uint32_t val)
+static int s626_send_dac(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
 	int ret;
@@ -461,8 +461,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 */
 	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
 			     s626_send_dac_wait_not_mc1_a2out);
-	if (ret)
+	if (ret) {
 		comedi_error(dev, "DMA transfer timeout.");
+		return ret;
+	}
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -484,8 +486,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 */
 	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
 			     s626_send_dac_wait_ssr_af2_out);
-	if (ret)
+	if (ret) {
 		comedi_error(dev, "TSL timeout waiting for slot 1 to execute.");
+		return ret;
+	}
 
 	/*
 	 * Set up to trap execution at slot 0 when the TSL sequencer cycles
@@ -527,8 +531,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 		 */
 		ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
 				     s626_send_dac_wait_fb_buffer2_msb_00);
-		if (ret)
+		if (ret) {
 			comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
+			return ret;
+		}
 	}
 	/*
 	 * Either (1) we were too late setting the slot 0 trap; the TSL
@@ -549,14 +555,17 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 */
 	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
 			     s626_send_dac_wait_fb_buffer2_msb_ff);
-	if (ret)
+	if (ret) {
 		comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
+		return ret;
+	}
+	return 0;
 }
 
 /*
  * Private helper function: Write setpoint to an application DAC channel.
  */
-static void s626_set_dac(struct comedi_device *dev, uint16_t chan,
+static int s626_set_dac(struct comedi_device *dev, uint16_t chan,
 			 int16_t dacdata)
 {
 	struct s626_private *devpriv = dev->private;
@@ -619,10 +628,10 @@ static void s626_set_dac(struct comedi_device *dev, uint16_t chan,
 	val |= ((uint32_t)(chan & 1) << 15);	/* Address the DAC channel
 						 * within the device. */
 	val |= (uint32_t)dacdata;	/* Include DAC setpoint data. */
-	s626_send_dac(dev, val);
+	return s626_send_dac(dev, val);
 }
 
-static void s626_write_trim_dac(struct comedi_device *dev, uint8_t logical_chan,
+static int s626_write_trim_dac(struct comedi_device *dev, uint8_t logical_chan,
 				uint8_t dac_data)
 {
 	struct s626_private *devpriv = dev->private;
@@ -669,17 +678,22 @@ static void s626_write_trim_dac(struct comedi_device *dev, uint8_t logical_chan,
 	 * Address the DAC channel within the trimdac device.
 	 * Include DAC setpoint data.
 	 */
-	s626_send_dac(dev, (chan << 8) | dac_data);
+	return s626_send_dac(dev, (chan << 8) | dac_data);
 }
 
-static void s626_load_trim_dacs(struct comedi_device *dev)
+static int s626_load_trim_dacs(struct comedi_device *dev)
 {
 	uint8_t i;
+	int ret;
 
 	/* Copy TrimDac setpoint values from EEPROM to TrimDacs. */
-	for (i = 0; i < ARRAY_SIZE(s626_trimchan); i++)
-		s626_write_trim_dac(dev, i,
+	for (i = 0; i < ARRAY_SIZE(s626_trimchan); i++) {
+		ret = s626_write_trim_dac(dev, i,
 				    s626_i2c_read(dev, s626_trimadrs[i]));
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
 /* ******  COUNTER FUNCTIONS  ******* */
@@ -2378,6 +2392,7 @@ static int s626_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 {
 	struct s626_private *devpriv = dev->private;
 	int i;
+	int ret;
 	uint16_t chan = CR_CHAN(insn->chanspec);
 	int16_t dacdata;
 
@@ -2386,7 +2401,9 @@ static int s626_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->ao_readback[CR_CHAN(insn->chanspec)] = data[i];
 		dacdata -= (0x1fff);
 
-		s626_set_dac(dev, chan, dacdata);
+		ret = s626_set_dac(dev, chan, dacdata);
+		if (ret)
+			return ret;
 	}
 
 	return i;
@@ -2622,12 +2639,13 @@ static int s626_allocate_dma_buffers(struct comedi_device *dev)
 	return 0;
 }
 
-static void s626_initialize(struct comedi_device *dev)
+static int s626_initialize(struct comedi_device *dev)
 {
 	struct s626_private *devpriv = dev->private;
 	dma_addr_t phys_buf;
 	uint16_t chan;
 	int i;
+	int ret;
 
 	/* Enable DEBI and audio pins, enable I2C interface */
 	s626_mc_enable(dev, S626_MC1_DEBI | S626_MC1_AUDIO | S626_MC1_I2C,
@@ -2828,7 +2846,9 @@ static void s626_initialize(struct comedi_device *dev)
 	 * sometimes causes the first few TrimDAC writes to malfunction.
 	 */
 	s626_load_trim_dacs(dev);
-	s626_load_trim_dacs(dev);
+	ret = s626_load_trim_dacs(dev);
+	if (ret)
+		return ret;
 
 	/*
 	 * Manually init all gate array hardware in case this is a soft
@@ -2842,8 +2862,11 @@ static void s626_initialize(struct comedi_device *dev)
 	 * Init all DAC outputs to 0V and init all DAC setpoint and
 	 * polarity images.
 	 */
-	for (chan = 0; chan < S626_DAC_CHANNELS; chan++)
-		s626_set_dac(dev, chan, 0);
+	for (chan = 0; chan < S626_DAC_CHANNELS; chan++) {
+		ret = s626_set_dac(dev, chan, 0);
+		if (ret)
+			return ret;
+	}
 
 	/* Init counters */
 	s626_counters_init(dev);
@@ -2859,6 +2882,8 @@ static void s626_initialize(struct comedi_device *dev)
 
 	/* Initialize the digital I/O subsystem */
 	s626_dio_init(dev);
+
+	return 0;
 }
 
 static int s626_auto_attach(struct comedi_device *dev,
@@ -2979,7 +3004,9 @@ static int s626_auto_attach(struct comedi_device *dev,
 	s->insn_read	= s626_enc_insn_read;
 	s->insn_write	= s626_enc_insn_write;
 
-	s626_initialize(dev);
+	ret = s626_initialize(dev);
+	if (ret)
+		return ret;
 
 	return 0;
 }
-- 
1.8.5.3

