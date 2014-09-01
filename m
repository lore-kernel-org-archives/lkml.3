Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaIALGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:06:48 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39018 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbaIALE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/28] staging: comedi: amplc_pci230: replace `state` member with bitfields
Date: Mon,  1 Sep 2014 12:03:53 +0100
Message-Id: <1409569440-10979-22-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `state` member of `struct pci230_private` is used with the atomic
bit-op functions and has a couple of bits defined, `AI_CMD_STARTED` and
`AO_CMD_STARTED`.  Spin-locks are used to protect the clearing of these
bits and other stuff.  No special protection is used for setting these
bits.  Replace the `state` member with a couple of new, single-bit
bitfield members, `ai_cmd_started` and `ao_cmd_started` to save some
space.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 29e6016..7a8291a 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -443,10 +443,6 @@ enum {
 /* Current CPU.  XXX should this be hard_smp_processor_id()? */
 #define THISCPU		smp_processor_id()
 
-/* State flags for atomic bit operations */
-#define AI_CMD_STARTED	0
-#define AO_CMD_STARTED	1
-
 /*
  * Board descriptions for the two boards supported.
  */
@@ -495,7 +491,6 @@ struct pci230_private {
 	spinlock_t ai_stop_spinlock;	/* Spin lock for stopping AI command */
 	spinlock_t ao_stop_spinlock;	/* Spin lock for stopping AO command */
 	unsigned long daqio;		/* PCI230's DAQ I/O space */
-	unsigned long state;		/* State flags */
 	unsigned int ai_scan_count;	/* Number of AI scans remaining */
 	unsigned int ai_scan_pos;	/* Current position within AI scan */
 	unsigned int ao_scan_count;	/* Number of AO scans remaining.  */
@@ -511,6 +506,8 @@ struct pci230_private {
 	bool intr_running:1;		/* Flag set in interrupt routine */
 	bool ai_bipolar:1;		/* Flag AI range is bipolar */
 	bool ao_bipolar:1;		/* Flag AO range is bipolar */
+	bool ai_cmd_started:1;		/* Flag AI command started */
+	bool ao_cmd_started:1;		/* Flag AO command started */
 };
 
 /* PCI230 clock source periods in ns */
@@ -1060,11 +1057,12 @@ static void pci230_ao_stop(struct comedi_device *dev,
 	struct pci230_private *devpriv = dev->private;
 	unsigned long irqflags;
 	unsigned char intsrc;
-	int started;
+	bool started;
 	struct comedi_cmd *cmd;
 
 	spin_lock_irqsave(&devpriv->ao_stop_spinlock, irqflags);
-	started = test_and_clear_bit(AO_CMD_STARTED, &devpriv->state);
+	started = devpriv->ao_cmd_started;
+	devpriv->ao_cmd_started = false;
 	spin_unlock_irqrestore(&devpriv->ao_stop_spinlock, irqflags);
 	if (!started)
 		return;
@@ -1263,7 +1261,7 @@ static int pci230_ao_inttrig_scan_begin(struct comedi_device *dev,
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ao_stop_spinlock, irqflags);
-	if (test_bit(AO_CMD_STARTED, &devpriv->state)) {
+	if (devpriv->ao_cmd_started) {
 		/* Perform scan. */
 		if (devpriv->hwver < 2) {
 			/* Not using DAC FIFO. */
@@ -1296,7 +1294,7 @@ static void pci230_ao_start(struct comedi_device *dev,
 	struct comedi_cmd *cmd = &async->cmd;
 	unsigned long irqflags;
 
-	set_bit(AO_CMD_STARTED, &devpriv->state);
+	devpriv->ao_cmd_started = true;
 	if (cmd->stop_src == TRIG_COUNT && devpriv->ao_scan_count == 0) {
 		/* An empty acquisition! */
 		async->events |= COMEDI_CB_EOA;
@@ -1852,7 +1850,7 @@ static int pci230_ai_inttrig_convert(struct comedi_device *dev,
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
-	if (test_bit(AI_CMD_STARTED, &devpriv->state)) {
+	if (devpriv->ai_cmd_started) {
 		unsigned int delayus;
 
 		/*
@@ -1899,7 +1897,7 @@ static int pci230_ai_inttrig_scan_begin(struct comedi_device *dev,
 		return -EINVAL;
 
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
-	if (test_bit(AI_CMD_STARTED, &devpriv->state)) {
+	if (devpriv->ai_cmd_started) {
 		/* Trigger scan by waggling CT0 gate source. */
 		zgat = GAT_CONFIG(0, GAT_GND);
 		outb(zgat, dev->iobase + PCI230_ZGAT_SCE);
@@ -1917,10 +1915,11 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	struct pci230_private *devpriv = dev->private;
 	unsigned long irqflags;
 	struct comedi_cmd *cmd;
-	int started;
+	bool started;
 
 	spin_lock_irqsave(&devpriv->ai_stop_spinlock, irqflags);
-	started = test_and_clear_bit(AI_CMD_STARTED, &devpriv->state);
+	started = devpriv->ai_cmd_started;
+	devpriv->ai_cmd_started = false;
 	spin_unlock_irqrestore(&devpriv->ai_stop_spinlock, irqflags);
 	if (!started)
 		return;
@@ -1970,7 +1969,7 @@ static void pci230_ai_start(struct comedi_device *dev,
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 
-	set_bit(AI_CMD_STARTED, &devpriv->state);
+	devpriv->ai_cmd_started = true;
 	if (cmd->stop_src == TRIG_COUNT && devpriv->ai_scan_count == 0) {
 		/* An empty acquisition! */
 		async->events |= COMEDI_CB_EOA;
-- 
2.0.4

