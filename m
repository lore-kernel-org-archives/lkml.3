Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaE3Ens (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:43:48 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:43247 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaE3Enr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:43:47 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH 5/6] staging: comedi: addi_apci_1564: hook-up the interrupt subdevice
Date: Thu, 29 May 2014 23:43:34 -0500
Message-Id: <1401425014-22548-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The board supported by this driver can generate an interrupt based
on the state of input channels 0-15.

The apci1564_di_config() function is used to configure which
inputs are used to generate the interrupt. Currently this function
is broken since it does not follow the comedi API for insn_config
functions. Fix this function by implementing the config instruction
INSN_CONFIG_DIGITAL_TRIG.

Add the remaining subdevice operations necessary for the interrupt
subdevice to support async commands.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---

The structure of _much_ of this code was taken from/based on the similar
code found in addi_apci_1032.c.  As such, I would appreciate as much
review I can get to make sure what I've done here actually makes sense
for this driver :)

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |  37 +---
 drivers/staging/comedi/drivers/addi_apci_1564.c    | 228 +++++++++++++++++++--
 2 files changed, 210 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 054e731..41aa889 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -95,45 +95,14 @@ static unsigned int ui_InterruptData, ui_Type;
 
 struct apci1564_private {
 	unsigned int amcc_iobase;	/* base of AMCC I/O registers */
+	unsigned int mode1;		/* riding-edge/high level channels */
+	unsigned int mode2;		/* falling-edge/low level channels */
+	unsigned int ctrl;		/* interrupt mode OR (edge) . AND (level) */
 	unsigned char timer_select_mode;
 	unsigned char mode_select_register;
 };
 
 /*
- * Configures the digital input Subdevice
- *
- * data[0] 1 = Enable interrupt, 0 = Disable interrupt
- * data[1] 0 = ADDIDATA Interrupt OR LOGIC, 1 = ADDIDATA Interrupt AND LOGIC
- * data[2] Interrupt mask for the mode 1
- * data[3] Interrupt mask for the mode 2
- */
-static int apci1564_di_config(struct comedi_device *dev,
-			      struct comedi_subdevice *s,
-			      struct comedi_insn *insn,
-			      unsigned int *data)
-{
-	struct apci1564_private *devpriv = dev->private;
-
-	/* Set the digital input logic */
-	if (data[0] == ADDIDATA_ENABLE) {
-		data[2] = data[2] << 4;
-		data[3] = data[3] << 4;
-		outl(data[2], devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
-		outl(data[3], devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
-		if (data[1] == ADDIDATA_OR)
-			outl(0x4, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-		else
-			outl(0x6, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-	} else {
-		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
-		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
-		outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-	}
-
-	return insn->n;
-}
-
-/*
  * Configures The Digital Output Subdevice.
  *
  * data[1] 0 = Disable VCC Interrupt, 1 = Enable VCC Interrupt
diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 183fdc3..cf58f90 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -8,6 +8,42 @@
 
 #include "addi-data/hwdrv_apci1564.c"
 
+#define APCI1564_CTRL_INT_OR		(0 << 1)
+#define APCI1564_CTRL_INT_AND		(1 << 1)
+#define APCI1564_CTRL_INT_ENA		(1 << 2)
+
+static int apci1564_reset(struct comedi_device *dev)
+{
+	struct apci1564_private *devpriv = dev->private;
+
+	ui_Type = 0;
+
+	/* Disable the input interrupts and reset status register */
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
+	inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
+
+	/* Reset the output channels and disable interrupts */
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
+
+	/* Reset the watchdog registers */
+	addi_watchdog_reset(devpriv->amcc_iobase + APCI1564_WDOG_REG);
+
+	/* Reset the timer registers */
+	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
+	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_RELOAD_REG);
+
+	/* Reset the counter registers */
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
+	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+
+	return 0;
+}
+
 static irqreturn_t v_ADDI_Interrupt(int irq, void *d)
 {
 	apci1564_interrupt(irq, d);
@@ -43,38 +79,184 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-static int apci1564_reset(struct comedi_device *dev)
+/*
+ * Change-Of-State (COS) interrupt configuration
+ *
+ * Channels 0 to 15 are interruptible. These channels can be configured
+ * to generate interrupts based on AND/OR logic for the desired channels.
+ *
+ *	OR logic
+ *		- reacts to rising or falling edges
+ *		- interrupt is generated when any enabled channel
+ *		  meet the desired interrupt condition
+ *
+ *	AND logic
+ *		- reacts to changes in level of the selected inputs
+ *		- interrupt is generated when all enabled channels
+ *		  meet the desired interrupt condition
+ *		- after an interrupt, a change in level must occur on
+ *		  the selected inputs to release the IRQ logic
+ *
+ * The COS interrupt must be configured before it can be enabled.
+ *
+ *	data[0] : INSN_CONFIG_DIGITAL_TRIG
+ *	data[1] : trigger number (= 0)
+ *	data[2] : configuration operation:
+ *	          COMEDI_DIGITAL_TRIG_DISABLE = no interrupts
+ *	          COMEDI_DIGITAL_TRIG_ENABLE_EDGES = OR (edge) interrupts
+ *	          COMEDI_DIGITAL_TRIG_ENABLE_LEVELS = AND (level) interrupts
+ *	data[3] : left-shift for data[4] and data[5]
+ *	data[4] : rising-edge/high level channels
+ *	data[5] : falling-edge/low level channels
+ */
+static int apci1564_cos_insn_config(struct comedi_device *dev,
+				    struct comedi_subdevice *s,
+				    struct comedi_insn *insn,
+				    unsigned int *data)
 {
 	struct apci1564_private *devpriv = dev->private;
+	unsigned int shift, oldmask;
+
+	switch (data[0]) {
+	case INSN_CONFIG_DIGITAL_TRIG:
+		if (data[1] != 0)
+			return -EINVAL;
+		shift = data[3];
+		oldmask = (1U << shift) - 1;
+		switch (data[2]) {
+		case COMEDI_DIGITAL_TRIG_DISABLE:
+			devpriv->ctrl = 0;
+			devpriv->mode1 = 0;
+			devpriv->mode2 = 0;
+			apci1564_reset(dev);
+			break;
+		case COMEDI_DIGITAL_TRIG_ENABLE_EDGES:
+			if (devpriv->ctrl != (APCI1564_CTRL_INT_ENA |
+					      APCI1564_CTRL_INT_OR)) {
+				/* switching to 'OR' mode */
+				devpriv->ctrl = APCI1564_CTRL_INT_ENA |
+						APCI1564_CTRL_INT_OR;
+				/* wipe old channels */
+				devpriv->mode1 = 0;
+				devpriv->mode2 = 0;
+			} else {
+				/* preserve unspecified channels */
+				devpriv->mode1 &= oldmask;
+				devpriv->mode2 &= oldmask;
+			}
+			/* configure specified channels */
+			devpriv->mode1 |= data[4] << shift;
+			devpriv->mode2 |= data[5] << shift;
+			break;
+		case COMEDI_DIGITAL_TRIG_ENABLE_LEVELS:
+			if (devpriv->ctrl != (APCI1564_CTRL_INT_ENA |
+					      APCI1564_CTRL_INT_AND)) {
+				/* switching to 'AND' mode */
+				devpriv->ctrl = APCI1564_CTRL_INT_ENA |
+						APCI1564_CTRL_INT_AND;
+				/* wipe old channels */
+				devpriv->mode1 = 0;
+				devpriv->mode2 = 0;
+			} else {
+				/* preserve unspecified channels */
+				devpriv->mode1 &= oldmask;
+				devpriv->mode2 &= oldmask;
+			}
+			/* configure specified channels */
+			devpriv->mode1 |= data[4] << shift;
+			devpriv->mode2 |= data[5] << shift;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return insn->n;
+}
 
-	ui_Type = 0;
+static int apci1564_cos_insn_bits(struct comedi_device *dev,
+				  struct comedi_subdevice *s,
+				  struct comedi_insn *insn,
+				  unsigned int *data)
+{
+	data[1] = s->state;
 
-	/* Disable the input interrupts and reset status register */
-	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
-	inl(devpriv->amcc_iobase + APCI1564_DI_INT_STATUS_REG);
-	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
-	outl(0x0, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
+	return 0;
+}
 
-	/* Reset the output channels and disable interrupts */
-	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_REG);
-	outl(0x0, devpriv->amcc_iobase + APCI1564_DO_INT_CTRL_REG);
+static int apci1564_cos_cmdtest(struct comedi_device *dev,
+				struct comedi_subdevice *s,
+				struct comedi_cmd *cmd)
+{
+	int err = 0;
 
-	/* Reset the watchdog registers */
-	addi_watchdog_reset(devpriv->amcc_iobase + APCI1564_WDOG_REG);
+	/* Step 1 : check if triggers are trivially valid */
 
-	/* Reset the timer registers */
-	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_CTRL_REG);
-	outl(0x0, devpriv->amcc_iobase + APCI1564_TIMER_RELOAD_REG);
+	err |= cfc_check_trigger_src(&cmd->start_src, TRIG_NOW);
+	err |= cfc_check_trigger_src(&cmd->scan_begin_src, TRIG_EXT);
+	err |= cfc_check_trigger_src(&cmd->convert_src, TRIG_FOLLOW);
+	err |= cfc_check_trigger_src(&cmd->scan_end_src, TRIG_COUNT);
+	err |= cfc_check_trigger_src(&cmd->stop_src, TRIG_NONE);
 
-	/* Reset the counter registers */
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER1));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER2));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER3));
-	outl(0x0, dev->iobase + APCI1564_TCW_CTRL_REG(APCI1564_COUNTER4));
+	if (err)
+		return 1;
+
+	/* Step 2a : make sure trigger sources are unique */
+	/* Step 2b : and mutually compatible */
+
+	if (err)
+		return 2;
+
+	/* Step 3: check if arguments are trivially valid */
+
+	err |= cfc_check_trigger_arg_is(&cmd->start_arg, 0);
+	err |= cfc_check_trigger_arg_is(&cmd->scan_begin_arg, 0);
+	err |= cfc_check_trigger_arg_is(&cmd->convert_arg, 0);
+	err |= cfc_check_trigger_arg_is(&cmd->scan_end_arg, cmd->chanlist_len);
+	err |= cfc_check_trigger_arg_is(&cmd->stop_arg, 0);
+
+	if (err)
+		return 3;
+
+	/* step 4: ignored */
+
+	if (err)
+		return 4;
+
+	return 0;
+}
+
+/*
+ * Change-Of-State (COS) 'do_cmd' operation
+ *
+ * Enable the COS interrupt as configured by apci1564_cos_insn_config().
+ */
+static int apci1564_cos_cmd(struct comedi_device *dev,
+			    struct comedi_subdevice *s)
+{
+	struct apci1564_private *devpriv = dev->private;
+
+	if (!devpriv->ctrl) {
+		dev_warn(dev->class_dev,
+			"Interrupts disabled due to mode configuration!\n");
+		return -EINVAL;
+	}
+
+	outl(devpriv->mode1, devpriv->amcc_iobase + APCI1564_DI_INT_MODE1_REG);
+	outl(devpriv->mode2, devpriv->amcc_iobase + APCI1564_DI_INT_MODE2_REG);
+	outl(devpriv->ctrl, devpriv->amcc_iobase + APCI1564_DI_IRQ_REG);
 
 	return 0;
 }
 
+static int apci1564_cos_cancel(struct comedi_device *dev,
+			       struct comedi_subdevice *s)
+{
+	return apci1564_reset(dev);
+}
+
 static int apci1564_auto_attach(struct comedi_device *dev,
 				      unsigned long context_unused)
 {
@@ -117,7 +299,6 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 	s->maxdata = 1;
 	s->len_chanlist = 32;
 	s->range_table = &range_digital;
-	s->insn_config = apci1564_di_config;
 	s->insn_bits = apci1564_di_insn_bits;
 
 	/*  Allocate and Initialise DO Subdevice Structures */
@@ -154,6 +335,11 @@ static int apci1564_auto_attach(struct comedi_device *dev,
 		s->maxdata = 1;
 		s->range_table = &range_digital;
 		s->len_chanlist = 1;
+		s->insn_config = apci1564_cos_insn_config;
+		s->insn_bits = apci1564_cos_insn_bits;
+		s->do_cmdtest = apci1564_cos_cmdtest;
+		s->do_cmd = apci1564_cos_cmd;
+		s->cancel = apci1564_cos_cancel;
 	} else {
 		s->type = COMEDI_SUBD_UNUSED;
 	}
-- 
1.9.3

