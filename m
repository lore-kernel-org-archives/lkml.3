Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967150AbaFTLxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:53:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:49716 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966096AbaFTLxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:53:33 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org,
        Fred Brooks <frederick.brooks@microchip.com>
Subject: [PATCH 2/2 v3] staging: comedi: ni_daq_700: add AI range and input mode switching
Date: Fri, 20 Jun 2014 12:53:15 +0100
Message-Id: <1403265195-32693-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140618213801.GA11436@kroah.com>
References: <20140618213801.GA11436@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred Brooks <frederick.brooks@microchip.com>

Add support for switching the input range and the single-ended/
differential input mode for the AI subdevice.  We needed to clear the
FIFO of data before the conversion to handle card mode switching
glitches.

[ Minor whitespace fixes and driver comment reformatting.  - Ian ]

Signed-off-by: Fred Brooks <frederick.brooks@microchip.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: Set authorship to Fred Brooks and updated patch description as
suggested by Dan Carpenter.
v3: Rebased to fix merge conflict with "staging: comedi: ni_daq_700: add
mux settling delay" patch.  The channel number ('chan') doesn't need
ANDing with 0xf as it will be less than 16.
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 51 ++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 4eedefd..3d841d4 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -24,21 +24,30 @@
  *   based on ni_daq_dio24 by Daniel Vecino Castel <dvecino@able.es>
  * Devices: [National Instruments] PCMCIA DAQ-Card-700 (ni_daq_700)
  * Status: works
- * Updated: Wed, 19 Sep 2012 12:07:20 +0000
+ * Updated: Wed, 21 May 2014 12:07:20 +0000
  *
  * The daqcard-700 appears in Comedi as a  digital I/O subdevice (0) with
- * 16 channels and a analog input subdevice (1) with 16 single-ended channels.
+ * 16 channels and a analog input subdevice (1) with 16 single-ended channels
+ * or 8 differential channels, and three input ranges.
  *
  * Digital:  The channel 0 corresponds to the daqcard-700's output
  * port, bit 0; channel 8 corresponds to the input port, bit 0.
  *
  * Digital direction configuration: channels 0-7 output, 8-15 input.
  *
- * Analog: The input  range is 0 to 4095 for -10 to +10 volts
+ * Analog: The input  range is 0 to 4095 with a default of -10 to +10 volts.
+ * Valid ranges:
+ *       0 for -10 to 10V bipolar
+ *       1 for -5 to 5V bipolar
+ *       2 for -2.5 to 2.5V bipolar
+ *
  * IRQ is assigned but not used.
  *
  * Version 0.1	Original DIO only driver
  * Version 0.2	DIO and basic AI analog input support on 16 se channels
+ * Version 0.3	Add SE or DIFF mode and range switching +-10,+-5,+-2.5
+ *		Clear the FIFO of data before the conversion to handle card
+ *		mode switching glitches.
  *
  * Manuals:	Register level:	http://www.ni.com/pdf/manuals/340698.pdf
  *		User Manual:	http://www.ni.com/pdf/manuals/320676d.pdf
@@ -68,6 +77,17 @@
 #define CDA_R2		0x0A	/* RW 8bit */
 #define CMO_R		0x0B	/* RO 8bit */
 #define TIC_R		0x06	/* WO 8bit */
+/* daqcard700 modes */
+#define CMD_R3_DIFF     0x04    /* diff mode */
+
+static const struct comedi_lrange range_daq700_ai = {
+	3,
+	{
+		BIP_RANGE(10),
+		BIP_RANGE(5),
+		BIP_RANGE(2.5)
+	}
+};
 
 static int daq700_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
@@ -130,11 +150,22 @@ static int daq700_ai_rinsn(struct comedi_device *dev,
 			   struct comedi_subdevice *s,
 			   struct comedi_insn *insn, unsigned int *data)
 {
-	int n, chan;
+	int n;
 	int d;
 	int ret;
+	unsigned int chan	= CR_CHAN(insn->chanspec);
+	unsigned int aref	= CR_AREF(insn->chanspec);
+	unsigned int range	= CR_RANGE(insn->chanspec);
+	unsigned int r3_bits	= 0;
+
+	/* set channel input modes */
+	if (aref == AREF_DIFF)
+		r3_bits |= CMD_R3_DIFF;
+	/* write channel mode/range */
+	if (range >= 1)
+		range++;        /* convert range to hardware value */
+	outb(r3_bits | (range & 0x03), dev->iobase + CMD_R3);
 
-	chan = CR_CHAN(insn->chanspec);
 	/* write channel to multiplexer */
 	/* set mask scan bit high to disable scanning */
 	outb(chan | 0x80, dev->iobase + CMD_R1);
@@ -146,6 +177,9 @@ static int daq700_ai_rinsn(struct comedi_device *dev,
 		/* trigger conversion with out0 L to H */
 		outb(0x00, dev->iobase + CMD_R2); /* enable ADC conversions */
 		outb(0x30, dev->iobase + CMO_R); /* mode 0 out0 L, from H */
+		outb(0x00, dev->iobase + ADCLEAR_R);	/* clear the ADC FIFO */
+		/* read 16bit junk from FIFO to clear */
+		inw(dev->iobase + ADFIFO_R);
 		/* mode 1 out0 H, L to H, start conversion */
 		outb(0x32, dev->iobase + CMO_R);
 
@@ -221,11 +255,10 @@ static int daq700_auto_attach(struct comedi_device *dev,
 	/* DAQCard-700 ai */
 	s = &dev->subdevices[1];
 	s->type = COMEDI_SUBD_AI;
-	/* we support single-ended (ground)  */
-	s->subdev_flags = SDF_READABLE | SDF_GROUND;
+	s->subdev_flags = SDF_READABLE | SDF_GROUND | SDF_DIFF;
 	s->n_chan = 16;
 	s->maxdata = (1 << 12) - 1;
-	s->range_table = &range_bipolar10;
+	s->range_table = &range_daq700_ai;
 	s->insn_read = daq700_ai_rinsn;
 	daq700_ai_config(dev, s);
 
@@ -262,5 +295,5 @@ module_comedi_pcmcia_driver(daq700_driver, daq700_cs_driver);
 MODULE_AUTHOR("Fred Brooks <nsaspook@nsaspook.com>");
 MODULE_DESCRIPTION(
 	"Comedi driver for National Instruments PCMCIA DAQCard-700 DIO/AI");
-MODULE_VERSION("0.2.00");
+MODULE_VERSION("0.3.00");
 MODULE_LICENSE("GPL");
-- 
2.0.0

