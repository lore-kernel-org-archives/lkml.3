Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaCDIoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:44:09 -0500
Received: from nm2-vm1.bullet.mail.gq1.yahoo.com ([98.136.218.128]:43455 "EHLO
	nm2-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756625AbaCDIoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:44:07 -0500
X-Yahoo-Newman-Id: 117097.80517.bm@smtp203.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MkjnKEoVM1nsm40mCQGzkXn8rvER7BaGb4KvHP7MWcu2EWG
 Wpcc36dAE.h49cLqYuv.dC.Sc0z1.kxt7EPzncjJoBjvQ5G6ZoOy5S6q1veF
 X8hfubOjgxDxBGlf1qo6USaRwvb2wYqONB7R3k20aoEIDcvlecoOqAUIOrzS
 fOCItfu.yBJoqPAM0MNKwXEVWXA1TP04R1rrXg0hyv.v2bNrG5BHrWmQINpf
 ygqgo4REEyG352Kvm2_GQx8H9PV9hNwA0MmL1GwVLFXKpIzRjzFNU4aEbEde
 bIu13qfWp9oT7TRYkZn7W4r7e9mEs7oe3EtCCyF4l3HCXX_qhiRuuNjwG.h2
 rRbeOub.4gri69RSNxtpYyXVI.F0ORxW6bcpOVHOt6G_4L8KHnRuFsRehRrD
 lZEdFHvfMRpX6277db7DlLT46QXsTRkcteRXuX0uLwXx9T_6PJpK5V92nODE
 3xAhk3cU05XuRJLE4ttpki0tOpV8eEmAkKWNt0hcDHxc5lTcC2QNy1k6X5Bd
 .lXRGzf51Ap9vhksaSYl.eXFYljEyo9.H.8A89g--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp203.mail.gq1.yahoo.com with SMTP; 04 Mar 2014 00:44:07 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2 2/2] Staging: comedi: propagate timeout errors in s626.c
Date: Tue,  4 Mar 2014 02:44:02 -0600
Message-Id: <1393922642-27948-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch for s626.c propagates the errors from the newly introduced
calls to comedi_timeout() as far as possible.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
Compile tested only.

 drivers/staging/comedi/drivers/s626.c | 63 +++++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 5a7e1c0..c6486b0 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -406,7 +406,7 @@ static int s626_send_dac_eoc(struct comedi_device *dev,
  * channel 2.  Assumes: (1) TSL2 slot records initialized, and (2)
  * dacpol contains valid target image.
  */
-static void s626_send_dac(struct comedi_device *dev, uint32_t val)
+static int s626_send_dac(struct comedi_device *dev, uint32_t val)
 {
 	struct s626_private *devpriv = dev->private;
 	int ret;
@@ -456,8 +456,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * cleared when the transfer has finished.
 	 */
 	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc, S626_P_MC1);
-	if (ret)
+	if (ret) {
 		comedi_error(dev, "DMA transfer timeout.");
+		return ret;
+	}
 
 	/* START THE OUTPUT STREAM TO THE TARGET DAC -------------------- */
 
@@ -478,8 +480,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 * to the output buffer register.
 	 */
 	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc, S626_P_SSR);
-	if (ret)
+	if (ret) {
 		comedi_error(dev, "TSL timeout waiting for slot 1 to execute.");
+		return ret;
+	}
 
 	/*
 	 * Set up to trap execution at slot 0 when the TSL sequencer cycles
@@ -521,8 +525,10 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 		 */
 		ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
 							S626_P_FB_BUFFER2_MSB_00);
-		if (ret)
+		if (ret) {
 			comedi_error(dev, "TSL timeout waiting for slot 0 to execute.");
+			return ret;
+		}
 	}
 	/*
 	 * Either (1) we were too late setting the slot 0 trap; the TSL
@@ -543,14 +549,17 @@ static void s626_send_dac(struct comedi_device *dev, uint32_t val)
 	 */
 	ret = comedi_timeout(dev, NULL, NULL, s626_send_dac_eoc,
 						S626_P_FB_BUFFER2_MSB_FF);
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
@@ -613,10 +622,10 @@ static void s626_set_dac(struct comedi_device *dev, uint16_t chan,
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
@@ -663,17 +672,22 @@ static void s626_write_trim_dac(struct comedi_device *dev, uint8_t logical_chan,
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
@@ -2372,6 +2386,7 @@ static int s626_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 {
 	struct s626_private *devpriv = dev->private;
 	int i;
+	int ret;
 	uint16_t chan = CR_CHAN(insn->chanspec);
 	int16_t dacdata;
 
@@ -2380,7 +2395,9 @@ static int s626_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
 		devpriv->ao_readback[CR_CHAN(insn->chanspec)] = data[i];
 		dacdata -= (0x1fff);
 
-		s626_set_dac(dev, chan, dacdata);
+		ret = s626_set_dac(dev, chan, dacdata);
+		if (ret)
+			return ret;
 	}
 
 	return i;
@@ -2616,12 +2633,13 @@ static int s626_allocate_dma_buffers(struct comedi_device *dev)
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
@@ -2822,7 +2840,9 @@ static void s626_initialize(struct comedi_device *dev)
 	 * sometimes causes the first few TrimDAC writes to malfunction.
 	 */
 	s626_load_trim_dacs(dev);
-	s626_load_trim_dacs(dev);
+	ret = s626_load_trim_dacs(dev);
+	if (ret)
+		return ret;
 
 	/*
 	 * Manually init all gate array hardware in case this is a soft
@@ -2836,8 +2856,11 @@ static void s626_initialize(struct comedi_device *dev)
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
@@ -2853,6 +2876,8 @@ static void s626_initialize(struct comedi_device *dev)
 
 	/* Initialize the digital I/O subsystem */
 	s626_dio_init(dev);
+
+	return 0;
 }
 
 static int s626_auto_attach(struct comedi_device *dev,
@@ -2973,7 +2998,9 @@ static int s626_auto_attach(struct comedi_device *dev,
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

