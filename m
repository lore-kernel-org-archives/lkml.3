Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaGaNts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:49:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57892 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaGaNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:14 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] staging: comedi: amplc_pci224: remove options to select output ranges
Date: Thu, 31 Jul 2014 14:47:49 +0100
Message-Id: <1406814475-5923-13-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attaching a PCI224 or PCI234 manually via the `COMEDI_DEVCONFIG`
ioctl, there are several options the user can supply that describe the
state of the hardware jumpers (LK1 for PCI224, LK1 thru LK5 for PCI234).
These options control how the driver sets up the AO range tables for the
device.  Those options are useless when the board is attached
automatically via the PCI driver probe function
`amplc_pci225_pci_probe()`, `comedi_pci_auto_config()`, and the
comedi driver "auto_attach" handler `pci224_auto_attach()`.

Rip out the range table selection options and use a single, static range
table per board type, containing all the software- and
hardware-selectable ranges for that board.  The PCI234 used to have a
per-channel `range_table_list` rather than an all-channel `range_table`,
as the jumpers selected different ranges for all channels.  Now that the
channels are using a unified range table, use an all-channel
`range_table` instead.

When checking the channel list for an asynchronous command in
`pci224_ao_check_chanlist()` make sure the ranges specified in the list
have compatible jumper settings.  We don't know how the jumpers are
actually set, but we can at least avoid conflicting settings.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 243 +++++++++++---------------
 1 file changed, 106 insertions(+), 137 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index b8b86ab..fba0198 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -24,7 +24,7 @@
  * Author: Ian Abbott <abbotti@mev.co.uk>
  * Devices: [Amplicon] PCI224 (amplc_pci224 or pci224),
  *   PCI234 (amplc_pci224 or pci234)
- * Updated: Wed, 22 Oct 2008 12:25:08 +0100
+ * Updated: Wed, 30 Jul 2014 18:08:43 +0000
  * Status: works, but see caveats
  *
  * Supports:
@@ -45,42 +45,48 @@
  *     There is only one external trigger source so only one of start_src,
  *     scan_begin_src or stop_src may use TRIG_EXT.
  *
- * Configuration options - PCI224:
+ * Configuration options:
  *   [0] - PCI bus of device (optional).
  *   [1] - PCI slot of device (optional).
  *           If bus/slot is not specified, the first available PCI device
  *           will be used.
- *   [2] - Select available ranges according to jumper LK1.  All channels
- *         are set to the same range:
- *         0=Jumper position 1-2 (factory default), 4 software-selectable
- *           internal voltage references, giving 4 bipolar and 4 unipolar
- *           ranges:
- *             [-10V,+10V], [-5V,+5V], [-2.5V,+2.5V], [-1.25V,+1.25V],
- *             [0,+10V], [0,+5V], [0,+2.5V], [0,1.25V].
- *         1=Jumper position 2-3, 1 external voltage reference, giving
- *           1 bipolar and 1 unipolar range:
- *             [-Vext,+Vext], [0,+Vext].
- *
- * Configuration options - PCI234:
- *   [0] - PCI bus of device (optional).
- *   [1] - PCI slot of device (optional).
- *           If bus/slot is not specified, the first available PCI device
- *           will be used.
- *   [2] - Select internal or external voltage reference according to
- *         jumper LK1.  This affects all channels:
- *         0=Jumper position 1-2 (factory default), Vref=5V internal.
- *         1=Jumper position 2-3, Vref=Vext external.
- *   [3] - Select channel 0 range according to jumper LK2:
- *         0=Jumper position 2-3 (factory default), range [-2*Vref,+2*Vref]
- *           (10V bipolar when options[2]=0).
- *         1=Jumper position 1-2, range [-Vref,+Vref]
- *           (5V bipolar when options[2]=0).
- *   [4] - Select channel 1 range according to jumper LK3: cf. options[3].
- *   [5] - Select channel 2 range according to jumper LK4: cf. options[3].
- *   [6] - Select channel 3 range according to jumper LK5: cf. options[3].
  *
  * Passing a zero for an option is the same as leaving it unspecified.
  *
+ * Output range selection - PCI224:
+ *
+ *   Output ranges on PCI224 are partly software-selectable and partly
+ *   hardware-selectable according to jumper LK1.  All channels are set
+ *   to the same range:
+ *
+ *   - LK1 position 1-2 (factory default) corresponds to the following
+ *     comedi ranges:
+ *
+ *       0: [-10V,+10V]; 1: [-5V,+5V]; 2: [-2.5V,+2.5V], 3: [-1.25V,+1.25V],
+ *       4: [0,+10V],    5: [0,+5V],   6: [0,+2.5V],     7: [0,+1.25V]
+ *
+ *   - LK1 position 2-3 corresponds to the following Comedi ranges, using
+ *     an external voltage reference:
+ *
+ *       0: [-Vext,+Vext],
+ *       1: [0,+Vext]
+ *
+ * Output range selection - PCI234:
+ *
+ *   Output ranges on PCI234 are hardware-selectable according to jumper
+ *   LK1 which affects all channels, and jumpers LK2, LK3, LK4 and LK5
+ *   which affect channels 0, 1, 2 and 3 individually.  LK1 chooses between
+ *   an internal 5V reference and an external voltage reference (Vext).
+ *   LK2/3/4/5 choose (per channel) to double the reference or not according
+ *   to the following table:
+ *
+ *     LK1 position   LK2/3/4/5 pos  Comedi range
+ *     -------------  -------------  --------------
+ *     2-3 (factory)  1-2 (factory)  0: [-10V,+10V]
+ *     2-3 (factory)  2-3            1: [-5V,+5V]
+ *     1-2            1-2 (factory)  2: [-2*Vext,+2*Vext]
+ *     1-2            2-3            3: [-Vext,+Vext]
+ *
  * Caveats:
  *
  *   1) All channels on the PCI224 share the same range.  Any change to the
@@ -262,9 +268,17 @@
  * Range tables.
  */
 
-/* The software selectable internal ranges for PCI224 (option[2] == 0). */
-static const struct comedi_lrange range_pci224_internal = {
-	8, {
+/*
+ * The ranges for PCI224.
+ *
+ * These are partly hardware-selectable by jumper LK1 and partly
+ * software-selectable.
+ *
+ * All channels share the same hardware range.
+ */
+static const struct comedi_lrange range_pci224 = {
+	10, {
+		/* jumper LK1 in position 1-2 (factory default) */
 		BIP_RANGE(10),
 		BIP_RANGE(5),
 		BIP_RANGE(2.5),
@@ -272,11 +286,15 @@ static const struct comedi_lrange range_pci224_internal = {
 		UNI_RANGE(10),
 		UNI_RANGE(5),
 		UNI_RANGE(2.5),
-		UNI_RANGE(1.25)
+		UNI_RANGE(1.25),
+		/* jumper LK1 in position 2-3 */
+		RANGE_ext(-1, 1),	/* bipolar [-Vext,+Vext] */
+		RANGE_ext(0, 1),	/* unipolar [0,+Vext] */
 	}
 };
 
-static const unsigned short hwrange_pci224_internal[8] = {
+static const unsigned short hwrange_pci224[10] = {
+	/* jumper LK1 in position 1-2 (factory default) */
 	PCI224_DACCON_POLAR_BI | PCI224_DACCON_VREF_10,
 	PCI224_DACCON_POLAR_BI | PCI224_DACCON_VREF_5,
 	PCI224_DACCON_POLAR_BI | PCI224_DACCON_VREF_2_5,
@@ -285,44 +303,47 @@ static const unsigned short hwrange_pci224_internal[8] = {
 	PCI224_DACCON_POLAR_UNI | PCI224_DACCON_VREF_5,
 	PCI224_DACCON_POLAR_UNI | PCI224_DACCON_VREF_2_5,
 	PCI224_DACCON_POLAR_UNI | PCI224_DACCON_VREF_1_25,
-};
-
-/* The software selectable external ranges for PCI224 (option[2] == 1). */
-static const struct comedi_lrange range_pci224_external = {
-	2, {
-		RANGE_ext(-1, 1),	/* bipolar [-Vref,+Vref] */
-		RANGE_ext(0, 1)		/* unipolar [0,+Vref] */
-	}
-};
-
-static const unsigned short hwrange_pci224_external[2] = {
+	/* jumper LK1 in position 2-3 */
 	PCI224_DACCON_POLAR_BI,
 	PCI224_DACCON_POLAR_UNI,
 };
 
-/*
- * The hardware selectable Vref*2 external range for PCI234
- * (option[2] == 1, option[3+n] == 0).
- */
-static const struct comedi_lrange range_pci234_ext2 = {
-	1, {
-		RANGE_ext(-2, 2)
-	}
+/* Used to check all channels set to the same range on PCI224. */
+static const unsigned char range_check_pci224[10] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
 };
 
 /*
- * The hardware selectable Vref external range for PCI234
- * (option[2] == 1, option[3+n] == 1).
+ * The ranges for PCI234.
+ *
+ * These are all hardware-selectable by jumper LK1 affecting all channels,
+ * and jumpers LK2, LK3, LK4 and LK5 affecting channels 0, 1, 2 and 3
+ * individually.
  */
-static const struct comedi_lrange range_pci234_ext = {
-	1, {
-		RANGE_ext(-1, 1)
+static const struct comedi_lrange range_pci234 = {
+	4, {
+		/* LK1: 1-2 (fact def), LK2/3/4/5: 2-3 (fac def) */
+		BIP_RANGE(10),
+		/* LK1: 1-2 (fact def), LK2/3/4/5: 1-2 */
+		BIP_RANGE(5),
+		/* LK1: 2-3, LK2/3/4/5: 2-3 (fac def) */
+		RANGE_ext(-2, 2),	/* bipolar [-2*Vext,+2*Vext] */
+		/* LK1: 2-3, LK2/3/4/5: 1-2 */
+		RANGE_ext(-1, 1),	/* bipolar [-Vext,+Vext] */
 	}
 };
 
-/* This serves for all the PCI234 ranges. */
-static const unsigned short hwrange_pci234[1] = {
-	PCI224_DACCON_POLAR_BI,	/* bipolar - hardware ignores it! */
+/* N.B. PCI234 ignores the polarity bit, but software uses it. */
+static const unsigned short hwrange_pci234[4] = {
+	PCI224_DACCON_POLAR_BI,
+	PCI224_DACCON_POLAR_BI,
+	PCI224_DACCON_POLAR_BI,
+	PCI224_DACCON_POLAR_BI,
+};
+
+/* Used to check all channels use same LK1 setting on PCI234. */
+static const unsigned char range_check_pci234[4] = {
+	0, 0, 1, 1,
 };
 
 /*
@@ -337,6 +358,9 @@ struct pci224_board {
 	enum pci224_model model;
 	unsigned int ao_chans;
 	unsigned int ao_bits;
+	const struct comedi_lrange *ao_range;
+	const unsigned short *ao_hwrange;
+	const unsigned char *ao_range_check;
 };
 
 static const struct pci224_board pci224_boards[] = {
@@ -346,6 +370,9 @@ static const struct pci224_board pci224_boards[] = {
 		.model		= pci224_model,
 		.ao_chans	= 16,
 		.ao_bits	= 12,
+		.ao_range	= &range_pci224,
+		.ao_hwrange	= &hwrange_pci224[0],
+		.ao_range_check	= &range_check_pci224[0],
 	},
 	{
 		.name		= "pci234",
@@ -353,6 +380,9 @@ static const struct pci224_board pci224_boards[] = {
 		.model		= pci234_model,
 		.ao_chans	= 4,
 		.ao_bits	= 16,
+		.ao_range	= &range_pci234,
+		.ao_hwrange	= &hwrange_pci234[0],
+		.ao_range_check	= &range_check_pci234[0],
 	},
 	{
 		.name		= "amplc_pci224",
@@ -362,7 +392,6 @@ static const struct pci224_board pci224_boards[] = {
 };
 
 struct pci224_private {
-	const unsigned short *hwrange;
 	unsigned long iobase1;
 	unsigned long state;
 	spinlock_t ao_spinlock;	/* spinlock for AO command handling */
@@ -395,7 +424,7 @@ pci224_ao_set_data(struct comedi_device *dev, int chan, int range,
 	/* Enable the channel. */
 	outw(1 << chan, dev->iobase + PCI224_DACCEN);
 	/* Set range and reset FIFO. */
-	devpriv->daccon = COMBINE(devpriv->daccon, devpriv->hwrange[range],
+	devpriv->daccon = COMBINE(devpriv->daccon, thisboard->ao_hwrange[range],
 				  PCI224_DACCON_POLAR_MASK |
 				  PCI224_DACCON_VREF_MASK);
 	outw(devpriv->daccon | PCI224_DACCON_FIFORESET,
@@ -670,13 +699,14 @@ static int pci224_ao_check_chanlist(struct comedi_device *dev,
 				    struct comedi_subdevice *s,
 				    struct comedi_cmd *cmd)
 {
-	unsigned int range0 = CR_RANGE(cmd->chanlist[0]);
+	const struct pci224_board *thisboard = comedi_board(dev);
+	unsigned int range_check_0;
 	unsigned int chan_mask = 0;
 	int i;
 
+	range_check_0 = thisboard->ao_range_check[CR_RANGE(cmd->chanlist[0])];
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		unsigned int chan = CR_CHAN(cmd->chanlist[i]);
-		unsigned int range = CR_RANGE(cmd->chanlist[i]);
 
 		if (chan_mask & (1 << chan)) {
 			dev_dbg(dev->class_dev,
@@ -686,9 +716,10 @@ static int pci224_ao_check_chanlist(struct comedi_device *dev,
 		}
 		chan_mask |= 1 << chan;
 
-		if (range != range0) {
+		if (thisboard->ao_range_check[CR_RANGE(cmd->chanlist[i])] !=
+		    range_check_0) {
 			dev_dbg(dev->class_dev,
-				"%s: entries in chanlist must all have the same range index\n",
+				"%s: entries in chanlist have incompatible ranges\n",
 				__func__);
 			return -EINVAL;
 		}
@@ -882,6 +913,7 @@ static void pci224_ao_start_pacer(struct comedi_device *dev,
 
 static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 {
+	const struct pci224_board *thisboard = comedi_board(dev);
 	struct pci224_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	int range;
@@ -925,7 +957,7 @@ static int pci224_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 */
 	devpriv->daccon =
 	    COMBINE(devpriv->daccon,
-		    devpriv->hwrange[range] | PCI224_DACCON_TRIG_NONE |
+		    thisboard->ao_hwrange[range] | PCI224_DACCON_TRIG_NONE |
 		    PCI224_DACCON_FIFOINTR_NHALF,
 		    PCI224_DACCON_POLAR_MASK | PCI224_DACCON_VREF_MASK |
 		    PCI224_DACCON_TRIG_MASK | PCI224_DACCON_FIFOINTR_MASK);
@@ -974,7 +1006,6 @@ pci224_ao_munge(struct comedi_device *dev, struct comedi_subdevice *s,
 		void *data, unsigned int num_bytes, unsigned int chan_index)
 {
 	const struct pci224_board *thisboard = comedi_board(dev);
-	struct pci224_private *devpriv = dev->private;
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned short *array = data;
 	unsigned int length = num_bytes / sizeof(*array);
@@ -985,7 +1016,7 @@ pci224_ao_munge(struct comedi_device *dev, struct comedi_subdevice *s,
 	/* The hardware expects 16-bit numbers. */
 	shift = 16 - thisboard->ao_bits;
 	/* Channels will be all bipolar or all unipolar. */
-	if ((devpriv->hwrange[CR_RANGE(cmd->chanlist[0])] &
+	if ((thisboard->ao_hwrange[CR_RANGE(cmd->chanlist[0])] &
 	     PCI224_DACCON_POLAR_MASK) == PCI224_DACCON_POLAR_UNI) {
 		/* Unipolar */
 		offset = 0;
@@ -1108,13 +1139,12 @@ static struct pci_dev *pci224_find_pci_dev(struct comedi_device *dev,
  * Common part of attach and auto_attach.
  */
 static int pci224_attach_common(struct comedi_device *dev,
-				struct pci_dev *pci_dev, int *options)
+				struct pci_dev *pci_dev)
 {
 	const struct pci224_board *thisboard = comedi_board(dev);
 	struct pci224_private *devpriv = dev->private;
 	struct comedi_subdevice *s;
 	unsigned int irq;
-	unsigned n;
 	int ret;
 
 	comedi_set_hw_dev(dev, &pci_dev->dev);
@@ -1173,6 +1203,7 @@ static int pci224_attach_common(struct comedi_device *dev,
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_CMD_WRITE;
 	s->n_chan = thisboard->ao_chans;
 	s->maxdata = (1 << thisboard->ao_bits) - 1;
+	s->range_table = thisboard->ao_range;
 	s->insn_write = pci224_ao_insn_write;
 	s->insn_read = pci224_ao_insn_read;
 	s->len_chanlist = s->n_chan;
@@ -1182,61 +1213,6 @@ static int pci224_attach_common(struct comedi_device *dev,
 	s->cancel = pci224_ao_cancel;
 	s->munge = pci224_ao_munge;
 
-	/* Sort out channel range options. */
-	if (thisboard->model == pci234_model) {
-		/* PCI234 range options. */
-		const struct comedi_lrange **range_table_list;
-
-		range_table_list =
-		    kmalloc(sizeof(struct comedi_lrange *) * s->n_chan,
-			    GFP_KERNEL);
-		if (!range_table_list)
-			return -ENOMEM;
-		s->range_table_list = range_table_list;
-
-		if (options) {
-			for (n = 2; n < 3 + s->n_chan; n++) {
-				if (options[n] < 0 || options[n] > 1) {
-					dev_warn(dev->class_dev,
-						 "warning! bad options[%u]=%d\n",
-						 n, options[n]);
-				}
-			}
-		}
-		for (n = 0; n < s->n_chan; n++) {
-			if (n < COMEDI_NDEVCONFOPTS - 3 && options &&
-			    options[3 + n] == 1) {
-				if (options[2] == 1)
-					range_table_list[n] = &range_pci234_ext;
-				else
-					range_table_list[n] = &range_bipolar5;
-
-			} else {
-				if (options && options[2] == 1) {
-					range_table_list[n] =
-					    &range_pci234_ext2;
-				} else {
-					range_table_list[n] = &range_bipolar10;
-				}
-			}
-		}
-		devpriv->hwrange = hwrange_pci234;
-	} else {
-		/* PCI224 range options. */
-		if (options && options[2] == 1) {
-			s->range_table = &range_pci224_external;
-			devpriv->hwrange = hwrange_pci224_external;
-		} else {
-			if (options && options[2] != 0) {
-				dev_warn(dev->class_dev,
-					 "warning! bad options[2]=%d\n",
-					 options[2]);
-			}
-			s->range_table = &range_pci224_internal;
-			devpriv->hwrange = hwrange_pci224_internal;
-		}
-	}
-
 	dev->board_name = thisboard->name;
 
 	if (irq) {
@@ -1268,7 +1244,7 @@ static int pci224_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!pci_dev)
 		return -EIO;
 
-	return pci224_attach_common(dev, pci_dev, it->options);
+	return pci224_attach_common(dev, pci_dev);
 }
 
 static int
@@ -1296,7 +1272,7 @@ pci224_auto_attach(struct comedi_device *dev, unsigned long context_unused)
 	 * has been removed.
 	 */
 	pci_dev_get(pci_dev);
-	return pci224_attach_common(dev, pci_dev, NULL);
+	return pci224_attach_common(dev, pci_dev);
 }
 
 static void pci224_detach(struct comedi_device *dev)
@@ -1306,13 +1282,6 @@ static void pci224_detach(struct comedi_device *dev)
 
 	if (dev->irq)
 		free_irq(dev->irq, dev);
-	if (dev->subdevices) {
-		struct comedi_subdevice *s;
-
-		s = &dev->subdevices[0];
-		/* AO subdevice */
-		kfree(s->range_table_list);
-	}
 	if (devpriv) {
 		kfree(devpriv->ao_readback);
 		kfree(devpriv->ao_scan_vals);
-- 
2.0.0

