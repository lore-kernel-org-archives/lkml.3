Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCCCwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:52:40 -0500
Received: from nm18-vm5.bullet.mail.gq1.yahoo.com ([98.136.217.220]:34155 "EHLO
	nm18-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbaCCCwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:52:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=gcom1024; d=yahoo.com;
	b=VMDtcV6nxn6ZEAx2Kg/m0M0gUs7fzejKKQenLmcd5HNYMI25/E104vewVcaY8e2F7C1BKZN/RVetlbUoE7JGt1ld0rL+yqaDtKPXdTvBKyI3zXqgfbaaOdjiU16azqxsvc8BcgWV3l2rzDQHOXPz8c3caZ+jftQMQuuWvaG7Vbs=;
X-Yahoo-Newman-Id: 622769.11735.bm@smtp210.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: YSf.BSQVM1llpQ1V72PCZwtDI_.a_tDF2VEHS6iNOToyzCf
 QAGp7NPw0BZrB53XiFMzrMnOAM1.5y1s5PwFiTai_K8KPvr9FNkYYIi6pNNW
 yNgPVeDVS8ch2M5lvF4UoT1K1xha9VuRtpEV7RE1ZoIR5BSfWTjE.Mn8rg9r
 v2zIzxVIFqPsz5wkMjUAoGnB0BCSkuWPqvo6nNMTPyGBKsHpOPeZeUssN1hF
 gFKtC4x2b.rf7FcZzLxIRgqBXmVrgW4UBSGEirSZu5d6xo5glA3UBeUV1uJL
 DIwLf794_rmJSV_zee3oeCDLfTfUZbWQuBY9a4YJDX.K.eXyp6fE1SVLxJA9
 o0FpFvLq5_Moydf9wdnLs.nt.n5jX_lHDWxa6Hsgtn29tifFp3ST9lnygRVo
 8_SXFubQwJqSguDQ9u_oBntrAg0Ctn2b3c2WojJn3xjpg6sbEAMyAaKg1Ovb
 8.0BYkZvUxmyxw7Oa6fppczbVgEDl9ZPG5ls_HHLMr5_drTN2.f4ADpOatLe
 TBqt8XVXb0EvVve7dWUaXmaEsDec2wMMirUG0
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [98.138.105.21])
        by smtp210.mail.gq1.yahoo.com with SMTP; 02 Mar 2014 18:52:37 -0800 PST
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH v2 2/2] Staging: comedi: use inl() and outl() helper functions
Date: Sun,  2 Mar 2014 20:52:33 -0600
Message-Id: <1393815153-10708-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
References: <1393669707-20107-1-git-send-email-chase.southwood@yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly created helper functions to improve code readability and shorten
several lines to under the character limit.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---

I've reviewed this as best as I can, but I know it's a bear to review.
If there is some logical way that you'd like me to split this up into separate
patches to make it easier to review, please let me know.

Also, Dan, as best as I can possibly tell, i_APCI1564_Reset() is absolutely
buggy.  When making up this patch, I made the changes that seem correct (and
somewhat obvious) from looking at the other addi-data drivers, the other
functions in this file, and the hardware specs that I could find, but
unfortunately I have no way to test the code.

This patch is version 2 of [PATCH 2/2] Staging: comedi: use outl_1564_* and
inl_1564_* helper functions in hwdrv_apci1564.c

2: Helper functions changed.

Comments are welcome!

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 366 ++++++++-------------
 1 file changed, 137 insertions(+), 229 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 58e301d..4b4a4bb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -165,31 +165,17 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 	if (data[0] == ADDIDATA_ENABLE) {
 		data[2] = data[2] << 4;
 		data[3] = data[3] << 4;
-		outl(data[2],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+		outl_amcc(devpriv, data[2], APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
+		outl_amcc(devpriv, data[3], APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
 		if (data[1] == ADDIDATA_OR) {
-			outl(0x4,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl_amcc(devpriv, 0x4, APCI1564_DIGITAL_IP_IRQ);
 		} else {
-			outl(0x6,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
+			outl_amcc(devpriv, 0x6, APCI1564_DIGITAL_IP_IRQ);
 		}
 	} else {
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
+		outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
+		outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+		outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
 	}
 
 	return insn->n;
@@ -202,7 +188,7 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP);
+	data[1] = inl_amcc(devpriv, APCI1564_DIGITAL_IP);
 
 	return insn->n;
 }
@@ -261,12 +247,8 @@ static int i_APCI1564_ConfigDigitalOutput(struct comedi_device *dev,
 	else
 		ul_Command = ul_Command & 0xFFFFFFFD;
 
-	outl(ul_Command,
-		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_INTERRUPT);
-	ui_InterruptData =
-		inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_INTERRUPT);
+	outl_amcc(devpriv, ul_Command, APCI1564_DIGITAL_OP_INTERRUPT);
+	ui_InterruptData = inl_amcc(devpriv, APCI1564_DIGITAL_OP_INTERRUPT);
 	devpriv->tsk_Current = current;
 	return insn->n;
 }
@@ -278,12 +260,10 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 {
 	struct addi_private *devpriv = dev->private;
 
-	s->state = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_RW);
+	s->state = inl_amcc(devpriv, APCI1564_DIGITAL_OP_RW);
 
 	if (comedi_dio_update_state(s, data))
-		outl(s->state, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_RW);
+		outl_amcc(devpriv, s->state, APCI1564_DIGITAL_OP_RW);
 
 	data[1] = s->state;
 
@@ -333,81 +313,61 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		devpriv->b_TimerSelectMode = ADDIDATA_WATCHDOG;
 
 		/* Disable the watchdog */
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_PROG);
+		outl_amcc(devpriv, 0x0,
+				  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);
 		/* Loading the Reload value */
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl_amcc(devpriv, data[3],
+				  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_RELOAD_VALUE);
 	} else if (data[0] == ADDIDATA_TIMER) {
 		/* First Stop The Timer */
-		ul_Command1 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_PROG);
+		ul_Command1 = inl_amcc(devpriv, APCI1564_TIMER + APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl_amcc(devpriv, ul_Command1, APCI1564_TIMER + APCI1564_TCW_PROG);
 
 		devpriv->b_TimerSelectMode = ADDIDATA_TIMER;
 		if (data[1] == 1) {
-			outl(0x02, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
-			outl(0x0,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-				APCI1564_DIGITAL_IP_IRQ);
-			outl(0x0,
-				devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-				APCI1564_DIGITAL_OP_IRQ);
-			outl(0x0,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_IRQ);
-			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER1 +
-				APCI1564_TCW_IRQ);
-			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER2 +
-				APCI1564_TCW_IRQ);
-			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER3 +
-				APCI1564_TCW_IRQ);
-			outl(0x0,
-				devpriv->iobase + APCI1564_COUNTER4 +
-				APCI1564_TCW_IRQ);
+			/* Enable TIMER int & DISABLE ALL THE OTHER int SOURCES */
+			outl_amcc(devpriv, 0x02, APCI1564_TIMER + APCI1564_TCW_PROG);
+			outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
+			outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_OP_IRQ);
+			outl_amcc(devpriv, 0x0,
+					  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_IRQ);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER1 + APCI1564_TCW_IRQ);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER2 + APCI1564_TCW_IRQ);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER3 + APCI1564_TCW_IRQ);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER4 + APCI1564_TCW_IRQ);
 		} else {
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* disable Timer interrupt */
+			/* disable Timer interrupt */
+			outl_amcc(devpriv, 0x0, APCI1564_TIMER + APCI1564_TCW_PROG);
 		}
 
 		/*  Loading Timebase */
-		outl(data[2],
-			devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_TIMEBASE);
+		outl_amcc(devpriv, data[2], APCI1564_TIMER + APCI1564_TCW_TIMEBASE);
 
 		/* Loading the Reload value */
-		outl(data[3],
-			devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl_amcc(devpriv, data[3], APCI1564_TIMER + APCI1564_TCW_RELOAD_VALUE);
 
-		ul_Command1 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_PROG);
+		ul_Command1 = inl_amcc(devpriv, APCI1564_TIMER + APCI1564_TCW_PROG);
 		ul_Command1 =
 			(ul_Command1 & 0xFFF719E2UL) | 2UL << 13UL | 0x10UL;
-		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* mode 2 */
+		/* mode 2 */
+		outl_amcc(devpriv, ul_Command1, APCI1564_TIMER + APCI1564_TCW_PROG);
 	} else if (data[0] == ADDIDATA_COUNTER) {
 		devpriv->b_TimerSelectMode = ADDIDATA_COUNTER;
 		devpriv->b_ModeSelectRegister = data[5];
 
 		/* First Stop The Counter */
-		ul_Command1 =
-			inl(devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		ul_Command1 = inl_iobase(devpriv,
+								 ((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);
 		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-		outl(ul_Command1, devpriv->iobase + ((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);	/* Stop The Timer */
+		/* Stop The Timer */
+		outl_iobase(devpriv, ul_Command1,
+					((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);
 
 		/* Set the reload value */
-		outl(data[3],
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_RELOAD_VALUE);
+		outl_iobase(devpriv, data[3],
+					((data[5] - 1) * 0x20) + APCI1564_TCW_RELOAD_VALUE);
 
 		/* Set the mode :             */
 		/* - Disable the hardware     */
@@ -420,21 +380,18 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
 		ul_Command1 =
 			(ul_Command1 & 0xFFFC19E2UL) | 0x80000UL |
 			(unsigned int) ((unsigned int) data[4] << 16UL);
-		outl(ul_Command1,
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		outl_iobase(devpriv, ul_Command1,
+					((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);
 
 		/*  Enable or Disable Interrupt */
 		ul_Command1 = (ul_Command1 & 0xFFFFF9FD) | (data[1] << 1);
-		outl(ul_Command1,
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		outl_iobase(devpriv, ul_Command1,
+					((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);
 
 		/* Set the Up/Down selection */
 		ul_Command1 = (ul_Command1 & 0xFFFBF9FFUL) | (data[6] << 18);
-		outl(ul_Command1,
-			devpriv->iobase + ((data[5] - 1) * 0x20) +
-			APCI1564_TCW_PROG);
+		outl_iobase(devpriv, ul_Command1,
+					((data[5] - 1) * 0x20) + APCI1564_TCW_PROG);
 	} else {
 		dev_err(dev->class_dev, "Invalid subdevice.\n");
 	}
@@ -479,19 +436,17 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		switch (data[1]) {
 		case 0:	/* stop the watchdog */
-			outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);	/* disable the watchdog */
+			/* disable the watchdog */
+			outl_amcc(devpriv, 0x0,
+					  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);
 			break;
 		case 1:	/* start the watchdog */
-			outl(0x0001,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_PROG);
+			outl_amcc(devpriv, 0x0001,
+					  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);
 			break;
 		case 2:	/* Software trigger */
-			outl(0x0201,
-				devpriv->i_IobaseAmcc +
-				APCI1564_DIGITAL_OP_WATCHDOG +
-				APCI1564_TCW_PROG);
+			outl_amcc(devpriv, 0x0201,
+					  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_PROG);
 			break;
 		default:
 			dev_err(dev->class_dev, "Specified functionality does not exist.\n");
@@ -500,31 +455,23 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		if (data[1] == 1) {
-			ul_Command1 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			ul_Command1 = inl_amcc(devpriv, APCI1564_TIMER + APCI1564_TCW_PROG);
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
 
 			/* Enable the Timer */
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl_amcc(devpriv, ul_Command1, APCI1564_TIMER + APCI1564_TCW_PROG);
 		} else if (data[1] == 0) {
 			/* Stop The Timer */
 
-			ul_Command1 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			ul_Command1 = inl_amcc(devpriv, APCI1564_TIMER + APCI1564_TCW_PROG);
 			ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
-			outl(ul_Command1,
-				devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				APCI1564_TCW_PROG);
+			outl_amcc(devpriv, ul_Command1, APCI1564_TIMER + APCI1564_TCW_PROG);
 		}
 	}
 	if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
-		ul_Command1 =
-			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) + APCI1564_TCW_PROG);
+		ul_Command1 = inl_iobase(devpriv,
+								 ((devpriv->b_ModeSelectRegister - 1) * 0x20) +
+								 APCI1564_TCW_PROG);
 		if (data[1] == 1) {
 			/* Start the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x1UL;
@@ -536,10 +483,10 @@ static int i_APCI1564_StartStopWriteTimerCounterWatchdog(struct comedi_device *d
 			/*  Clears the Counter subdevice */
 			ul_Command1 = (ul_Command1 & 0xFFFFF9FFUL) | 0x400;
 		}
-		outl(ul_Command1,
-			devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) + APCI1564_TCW_PROG);
-	}			/*  if (devpriv->b_TimerSelectMode==ADDIDATA_COUNTER) */
+		outl_iobase(devpriv, ul_Command1,
+					((devpriv->b_ModeSelectRegister - 1) * 0x20) +
+					APCI1564_TCW_PROG);
+	}
 	return insn->n;
 }
 
@@ -574,30 +521,24 @@ static int i_APCI1564_ReadTimerCounterWatchdog(struct comedi_device *dev,
 
 	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
 		/*  Stores the status of the Watchdog */
-		data[0] =
-			inl(devpriv->i_IobaseAmcc +
-			APCI1564_DIGITAL_OP_WATCHDOG +
-			APCI1564_TCW_TRIG_STATUS) & 0x1;
-		data[1] =
-			inl(devpriv->i_IobaseAmcc +
-			APCI1564_DIGITAL_OP_WATCHDOG);
+		data[0] = inl_amcc(devpriv,
+						   APCI1564_DIGITAL_OP_WATCHDOG +
+						   APCI1564_TCW_TRIG_STATUS) & 0x1;
+		data[1] = inl_amcc(devpriv, APCI1564_DIGITAL_OP_WATCHDOG);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
 		/*  Stores the status of the Timer */
-		data[0] =
-			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			APCI1564_TCW_TRIG_STATUS) & 0x1;
-
+		data[0] = inl_amcc(devpriv,
+						   APCI1564_TIMER + APCI1564_TCW_TRIG_STATUS) & 0x1;
 		/*  Stores the Actual value of the Timer */
-		data[1] = inl(devpriv->i_IobaseAmcc + APCI1564_TIMER);
+		data[1] = inl_amcc(devpriv, APCI1564_TIMER);
 	} else if (devpriv->b_TimerSelectMode == ADDIDATA_COUNTER) {
 		/*  Read the Counter Actual Value. */
-		data[0] =
-			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) +
-			APCI1564_TCW_SYNC_ENABLEDISABLE);
-		ul_Command1 =
-			inl(devpriv->iobase + ((devpriv->b_ModeSelectRegister -
-					1) * 0x20) + APCI1564_TCW_TRIG_STATUS);
+		data[0] = inl_iobase(devpriv,
+							 ((devpriv->b_ModeSelectRegister - 1) * 0x20) +
+							 APCI1564_TCW_SYNC_ENABLEDISABLE);
+		ul_Command1 = inl_iobase(devpriv,
+								 ((devpriv->b_ModeSelectRegister - 1) * 0x20) +
+								 APCI1564_TCW_TRIG_STATUS);
 
 		/* Get the software trigger status */
 		data[1] = (unsigned char) ((ul_Command1 >> 1) & 1);
@@ -670,50 +611,35 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 	unsigned int ui_C1, ui_C2, ui_C3, ui_C4;
 	unsigned int ul_Command2 = 0;
 
-	ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-		APCI1564_DIGITAL_IP_IRQ) & 0x01;
-	ui_DO = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-		APCI1564_DIGITAL_OP_IRQ) & 0x01;
-	ui_Timer =
-		inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-		APCI1564_TCW_IRQ) & 0x01;
-	ui_C1 = inl(devpriv->iobase + APCI1564_COUNTER1 +
-		APCI1564_TCW_IRQ) & 0x1;
-	ui_C2 = inl(devpriv->iobase + APCI1564_COUNTER2 +
-		APCI1564_TCW_IRQ) & 0x1;
-	ui_C3 = inl(devpriv->iobase + APCI1564_COUNTER3 +
-		APCI1564_TCW_IRQ) & 0x1;
-	ui_C4 = inl(devpriv->iobase + APCI1564_COUNTER4 +
-		APCI1564_TCW_IRQ) & 0x1;
+	ui_DI = inl_amcc(devpriv, APCI1564_DIGITAL_IP_IRQ) & 0x01;
+	ui_DO = inl_amcc(devpriv, APCI1564_DIGITAL_OP_IRQ) & 0x01;
+	ui_Timer = inl_amcc(devpriv, APCI1564_TIMER + APCI1564_TCW_IRQ) & 0x01;
+	ui_C1 = inl_iobase(devpriv, APCI1564_COUNTER1 + APCI1564_TCW_IRQ) & 0x1;
+	ui_C2 = inl_iobase(devpriv, APCI1564_COUNTER2 + APCI1564_TCW_IRQ) & 0x1;
+	ui_C3 = inl_iobase(devpriv, APCI1564_COUNTER3 + APCI1564_TCW_IRQ) & 0x1;
+	ui_C4 = inl_iobase(devpriv, APCI1564_COUNTER4 + APCI1564_TCW_IRQ) & 0x1;
 	if (ui_DI == 0 && ui_DO == 0 && ui_Timer == 0 && ui_C1 == 0
 		&& ui_C2 == 0 && ui_C3 == 0 && ui_C4 == 0) {
 		dev_err(dev->class_dev, "Interrupt from unknown source.\n");
 	}
 
 	if (ui_DI == 1) {
-		ui_DI = inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_IRQ);
+		ui_DI = inl_amcc(devpriv, APCI1564_DIGITAL_IP_IRQ);
+		outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
 		ui_InterruptStatus_1564 =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP +
-			APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
+			inl_amcc(devpriv, APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + APCI1564_DIGITAL_IP_IRQ);	/* enable the interrupt */
+		/* enable the interrupt */
+		outl_amcc(devpriv, ui_DI, APCI1564_DIGITAL_IP_IRQ);
 		return;
 	}
 
 	if (ui_DO == 1) {
 		/*  Check for Digital Output interrupt Type - 1: Vcc interrupt 2: CC interrupt. */
-		ui_Type =
-			inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_INTERRUPT_STATUS) & 0x3;
+		ui_Type = inl_amcc(devpriv, APCI1564_DIGITAL_OP_INTERRUPT_STATUS) & 0x3;
 		/* Disable the  Interrupt */
-		outl(0x0,
-			devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP +
-			APCI1564_DIGITAL_OP_INTERRUPT);
+		outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_OP_INTERRUPT);
 
 		/* Sends signal to user space */
 		send_sig(SIGIO, devpriv->tsk_Current, 0);
@@ -724,21 +650,15 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		if (devpriv->b_TimerSelectMode) {
 
 			/*  Disable Timer Interrupt */
-			ul_Command2 =
-				inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+			ul_Command2 = inl_amcc(devpriv, APCI1564_TIMER + APCI1564_TCW_PROG);
+			outl_amcc(devpriv, 0x0, APCI1564_TIMER + APCI1564_TCW_PROG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Timer Interrupt */
 
-			outl(ul_Command2,
-			     devpriv->i_IobaseAmcc + APCI1564_TIMER +
-			     APCI1564_TCW_PROG);
+			outl_amcc(devpriv, ul_Command2, APCI1564_TIMER + APCI1564_TCW_PROG);
 		}
 	}
 
@@ -747,20 +667,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		if (devpriv->b_TimerSelectMode) {
 
 			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER1 +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER1 +
-			     APCI1564_TCW_PROG);
+			ul_Command2 = inl_iobase(devpriv,
+									 APCI1564_COUNTER1 + APCI1564_TCW_PROG);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER1 + APCI1564_TCW_PROG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER1 +
-			     APCI1564_TCW_PROG);
+			outl_iobase(devpriv, ul_Command2,
+						APCI1564_COUNTER1 + APCI1564_TCW_PROG);
 		}
 	}
 
@@ -769,20 +685,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		if (devpriv->b_TimerSelectMode) {
 
 			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER2 +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER2 +
-			     APCI1564_TCW_PROG);
+			ul_Command2 = inl_iobase(devpriv,
+									 APCI1564_COUNTER2 + APCI1564_TCW_PROG);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER2 + APCI1564_TCW_PROG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER2 +
-			     APCI1564_TCW_PROG);
+			outl_iobase(devpriv, ul_Command2,
+						APCI1564_COUNTER2 + APCI1564_TCW_PROG);
 		}
 	}
 
@@ -791,20 +703,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		if (devpriv->b_TimerSelectMode) {
 
 			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER3 +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER3 +
-			     APCI1564_TCW_PROG);
+			ul_Command2 = inl_iobase(devpriv,
+									 APCI1564_COUNTER3 + APCI1564_TCW_PROG);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER3 + APCI1564_TCW_PROG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER3 +
-			     APCI1564_TCW_PROG);
+			outl_iobase(devpriv, ul_Command2,
+						APCI1564_COUNTER3 + APCI1564_TCW_PROG);
 		}
 	}
 
@@ -813,20 +721,16 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		if (devpriv->b_TimerSelectMode) {
 
 			/*  Disable Counter Interrupt */
-			ul_Command2 =
-				inl(devpriv->iobase + APCI1564_COUNTER4 +
-				    APCI1564_TCW_PROG);
-			outl(0x0,
-			     devpriv->iobase + APCI1564_COUNTER4 +
-			     APCI1564_TCW_PROG);
+			ul_Command2 = inl_iobase(devpriv,
+									 APCI1564_COUNTER4 + APCI1564_TCW_PROG);
+			outl_iobase(devpriv, 0x0, APCI1564_COUNTER4 + APCI1564_TCW_PROG);
 
 			/* Send a signal to from kernel to user space */
 			send_sig(SIGIO, devpriv->tsk_Current, 0);
 
 			/*  Enable Counter Interrupt */
-			outl(ul_Command2,
-			     devpriv->iobase + APCI1564_COUNTER4 +
-			     APCI1564_TCW_PROG);
+			outl_iobase(devpriv, ul_Command2,
+						APCI1564_COUNTER4 + APCI1564_TCW_PROG);
 		}
 	}
 	return;
@@ -851,23 +755,27 @@ static int i_APCI1564_Reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_IRQ);	/* disable the interrupts */
-	inl(devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_STATUS);	/* Reset the interrupt status register */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1);	/* Disable the and/or interrupt */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
+	/* disable the interrupts */
+	outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_IRQ);
+	/* Reset the interrupt status register */
+	inl_amcc(devpriv, APCI1564_DIGITAL_IP_INTERRUPT_STATUS);
+	/* Disable the and/or interrupt */
+	outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
+	outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_IP_INTERRUPT_MODE2);
 	devpriv->b_DigitalOutputRegister = 0;
 	ui_Type = 0;
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP);	/* Resets the output channels */
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_INTERRUPT);	/* Disables the interrupt. */
-	outl(0x0,
-		devpriv->i_IobaseAmcc + APCI1564_DIGITAL_OP_WATCHDOG +
-		APCI1564_TCW_RELOAD_VALUE);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER);
-	outl(0x0, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);
-
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER1 + APCI1564_TCW_PROG);
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER2 + APCI1564_TCW_PROG);
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER3 + APCI1564_TCW_PROG);
-	outl(0x0, devpriv->iobase + APCI1564_COUNTER4 + APCI1564_TCW_PROG);
+	/* Resets the output channels */
+	outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_OP);
+	/* Disables the interrupt. */
+	outl_amcc(devpriv, 0x0, APCI1564_DIGITAL_OP_INTERRUPT);
+	outl_amcc(devpriv, 0x0,
+			  APCI1564_DIGITAL_OP_WATCHDOG + APCI1564_TCW_RELOAD_VALUE);
+	outl_amcc(devpriv, 0x0, APCI1564_TIMER);
+	outl_amcc(devpriv, 0x0, APCI1564_TIMER + APCI1564_TCW_PROG);
+
+	outl_iobase(devpriv, 0x0, APCI1564_COUNTER1 + APCI1564_TCW_PROG);
+	outl_iobase(devpriv, 0x0, APCI1564_COUNTER2 + APCI1564_TCW_PROG);
+	outl_iobase(devpriv, 0x0, APCI1564_COUNTER3 + APCI1564_TCW_PROG);
+	outl_iobase(devpriv, 0x0, APCI1564_COUNTER4 + APCI1564_TCW_PROG);
 	return 0;
 }
-- 
1.8.5.3

