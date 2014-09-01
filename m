Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaIALEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:04:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39059 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaIALEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:04:31 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/28] staging: comedi: amplc_pci230: rewrite shared resource handling
Date: Mon,  1 Sep 2014 12:03:54 +0100
Message-Id: <1409569440-10979-23-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
References: <1409569440-10979-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some counter channels may be required for AI commands and AO commands.
Depending on how the commands are set up, it may not be possible to run
both at the same time, so we keep some state and code to find out if the
required resources are busy or not.

The existing code is a bit unwieldy - the code for claiming resources
involves two `for` loops for example.  Rewrite it to make it simpler.

The new code just has a bit-mask value for each shared resource (counter
channels), and an array indexed by resource "owners" (AI and AO
commands), so the code for claiming resources now just has a single loop
that checks that none of the other owners have claimed the wanted
resources.

Rename the functions involved, because the old names involving 'put' and
'get' suggested some sort of usage counting.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 99 +++++++++------------------
 1 file changed, 32 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 7a8291a..727de3d 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -421,16 +421,15 @@
  * (Potentially) shared resources and their owners
  */
 enum {
-	RES_Z2CT0,		/* Z2-CT0 */
-	RES_Z2CT1,		/* Z2-CT1 */
-	RES_Z2CT2,		/* Z2-CT2 */
-	NUM_RESOURCES		/* Number of (potentially) shared resources. */
+	RES_Z2CT0 = (1U << 0),	/* Z2-CT0 */
+	RES_Z2CT1 = (1U << 1),	/* Z2-CT1 */
+	RES_Z2CT2 = (1U << 2)	/* Z2-CT2 */
 };
 
 enum {
-	OWNER_NONE,		/* Not owned */
 	OWNER_AICMD,		/* Owned by AI command */
-	OWNER_AOCMD		/* Owned by AO command */
+	OWNER_AOCMD,		/* Owned by AO command */
+	NUM_OWNERS		/* Number of owners */
 };
 
 /*
@@ -502,7 +501,7 @@ struct pci230_private {
 	unsigned short adcg;		/* ADCG register value */
 	unsigned char int_en;		/* Interrupt enable bits */
 	unsigned char ier;		/* Copy of interrupt enable register */
-	unsigned char res_owner[NUM_RESOURCES]; /* Shared resource owners */
+	unsigned char res_owned[NUM_OWNERS]; /* Owned resources */
 	bool intr_running:1;		/* Flag set in interrupt routine */
 	bool ai_bipolar:1;		/* Flag AI range is bipolar */
 	bool ao_bipolar:1;		/* Flag AO range is bipolar */
@@ -604,77 +603,43 @@ static void pci230_ao_write_fifo(struct comedi_device *dev,
 	     devpriv->daqio + PCI230P2_DACDATA);
 }
 
-static int pci230_get_resources(struct comedi_device *dev,
-				unsigned int res_mask, unsigned char owner)
+static bool pci230_claim_shared(struct comedi_device *dev,
+				unsigned char res_mask, unsigned int owner)
 {
 	struct pci230_private *devpriv = dev->private;
-	int ok;
-	unsigned int i;
-	unsigned int b;
-	unsigned int claimed;
+	unsigned int o;
 	unsigned long irqflags;
 
-	ok = 1;
-	claimed = 0;
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; i < NUM_RESOURCES && res_mask; b <<= 1, i++) {
-		if (res_mask & b) {
-			res_mask &= ~b;
-			if (devpriv->res_owner[i] == OWNER_NONE) {
-				devpriv->res_owner[i] = owner;
-				claimed |= b;
-			} else if (devpriv->res_owner[i] != owner) {
-				for (b = 1, i = 0; claimed; b <<= 1, i++) {
-					if (claimed & b) {
-						devpriv->res_owner[i] =
-						    OWNER_NONE;
-						claimed &= ~b;
-					}
-				}
-				ok = 0;
-				break;
-			}
+	for (o = 0; o < NUM_OWNERS; o++) {
+		if (o == owner)
+			continue;
+		if (devpriv->res_owned[o] & res_mask) {
+			spin_unlock_irqrestore(&devpriv->res_spinlock,
+					       irqflags);
+			return false;
 		}
 	}
+	devpriv->res_owned[owner] |= res_mask;
 	spin_unlock_irqrestore(&devpriv->res_spinlock, irqflags);
-	return ok;
-}
-
-static int pci230_get_one_resource(struct comedi_device *dev,
-				   unsigned int resource, unsigned char owner)
-{
-	return pci230_get_resources(dev, 1U << resource, owner);
+	return true;
 }
 
-static void pci230_put_resources(struct comedi_device *dev,
-				 unsigned int res_mask, unsigned char owner)
+static void pci230_release_shared(struct comedi_device *dev,
+				  unsigned char res_mask, unsigned int owner)
 {
 	struct pci230_private *devpriv = dev->private;
-	unsigned int i;
-	unsigned int b;
 	unsigned long irqflags;
 
 	spin_lock_irqsave(&devpriv->res_spinlock, irqflags);
-	for (b = 1, i = 0; i < NUM_RESOURCES && res_mask; b <<= 1, i++) {
-		if (res_mask & b) {
-			res_mask &= ~b;
-			if (devpriv->res_owner[i] == owner)
-				devpriv->res_owner[i] = OWNER_NONE;
-		}
-	}
+	devpriv->res_owned[owner] &= ~res_mask;
 	spin_unlock_irqrestore(&devpriv->res_spinlock, irqflags);
 }
 
-static void pci230_put_one_resource(struct comedi_device *dev,
-				    unsigned int resource, unsigned char owner)
-{
-	pci230_put_resources(dev, 1U << resource, owner);
-}
-
-static void pci230_put_all_resources(struct comedi_device *dev,
-				     unsigned char owner)
+static void pci230_release_all_resources(struct comedi_device *dev,
+					 unsigned int owner)
 {
-	pci230_put_resources(dev, (1U << NUM_RESOURCES) - 1, owner);
+	pci230_release_shared(dev, (unsigned char)~0, owner);
 }
 
 static unsigned int pci230_divide_ns(uint64_t ns, unsigned int timebase,
@@ -1105,7 +1070,7 @@ static void pci230_ao_stop(struct comedi_device *dev,
 		     devpriv->daqio + PCI230_DACCON);
 	}
 	/* Release resources. */
-	pci230_put_all_resources(dev, OWNER_AOCMD);
+	pci230_release_all_resources(dev, OWNER_AOCMD);
 }
 
 static void pci230_handle_ao_nofifo(struct comedi_device *dev,
@@ -1401,7 +1366,7 @@ static int pci230_ao_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 
 	if (cmd->scan_begin_src == TRIG_TIMER) {
 		/* Claim Z2-CT1. */
-		if (!pci230_get_one_resource(dev, RES_Z2CT1, OWNER_AOCMD))
+		if (!pci230_claim_shared(dev, RES_Z2CT1, OWNER_AOCMD))
 			return -EBUSY;
 	}
 
@@ -1957,7 +1922,7 @@ static void pci230_ai_stop(struct comedi_device *dev,
 	outw(devpriv->adccon | PCI230_ADC_FIFO_RESET,
 	     devpriv->daqio + PCI230_ADCCON);
 	/* Release resources. */
-	pci230_put_all_resources(dev, OWNER_AICMD);
+	pci230_release_all_resources(dev, OWNER_AICMD);
 }
 
 static void pci230_ai_start(struct comedi_device *dev,
@@ -2106,7 +2071,7 @@ static void pci230_ai_start(struct comedi_device *dev,
 			}
 		} else if (cmd->convert_src != TRIG_INT) {
 			/* No longer need Z2-CT2. */
-			pci230_put_one_resource(dev, RES_Z2CT2, OWNER_AICMD);
+			pci230_release_shared(dev, RES_Z2CT2, OWNER_AICMD);
 		}
 	}
 }
@@ -2237,17 +2202,17 @@ static int pci230_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	 * Need Z2-CT2 to supply a conversion trigger source at a high
 	 * logic level, even if not doing timed conversions.
 	 */
-	res_mask |= 1U << RES_Z2CT2;
+	res_mask |= RES_Z2CT2;
 	if (cmd->scan_begin_src != TRIG_FOLLOW) {
 		/* Using Z2-CT0 monostable to gate Z2-CT2 conversion timer */
-		res_mask |= 1U << RES_Z2CT0;
+		res_mask |= RES_Z2CT0;
 		if (cmd->scan_begin_src == TRIG_TIMER) {
 			/* Using Z2-CT1 for scan frequency */
-			res_mask |= 1U << RES_Z2CT1;
+			res_mask |= RES_Z2CT1;
 		}
 	}
 	/* Claim resources. */
-	if (!pci230_get_resources(dev, res_mask, OWNER_AICMD))
+	if (!pci230_claim_shared(dev, res_mask, OWNER_AICMD))
 		return -EBUSY;
 
 	/* Get number of scans required. */
-- 
2.0.4

