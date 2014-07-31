Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaGaO5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:57:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58138 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbaGaO5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:57:43 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: ii_pci20kc: request and ioremap memory
Date: Thu, 31 Jul 2014 15:57:27 +0100
Message-Id: <1406818647-10107-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "ii_pci20kc" module is a comedi driver for Intelligent Instruments
PCI-20001C carrier board and modules.  Despite the name, this is
actually an ISA board and uses 1K of ISA memory space (below 1M) for the
main board plus up to three modules.  The address is set by hardware
jumpers.

When the board is attached to Comedi via the `COMEDI_DEVCONFIG` ioctl
and the driver's legacy "attach" handler, the base address is passed in.
The driver currently uses that address as-is, which is a bad idea.  It
doesn't even reserve the memory region.

Fix that by sanity checking the passed in address, reserving the memory
region and ioremapping it.

Replace the current "detach" handler `comedi_legacy_detach()` with a new
handler `ii20k_detach()` which unmaps the memory and releases the
region.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ii_pci20kc.c | 32 ++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index b1f44b3..687db43 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -33,6 +33,7 @@
 /*
  * Register I/O map
  */
+#define II20K_SIZE			0x400
 #define II20K_MOD_OFFSET		0x100
 #define II20K_ID_REG			0x00
 #define II20K_ID_MOD1_EMPTY		(1 << 7)
@@ -439,12 +440,29 @@ static int ii20k_attach(struct comedi_device *dev,
 			struct comedi_devconfig *it)
 {
 	struct comedi_subdevice *s;
+	unsigned int membase;
 	unsigned char id;
 	bool has_dio;
 	int ret;
 
-	/* FIXME: this doesn't seem right, should 'mmio' be ioremap'ed? */
-	dev->mmio = (void __iomem *)(unsigned long)it->options[0];
+	membase = it->options[0];
+	if (!membase || (membase & ~(0x100000 - II20K_SIZE))) {
+		dev_warn(dev->class_dev,
+			 "%s: invalid memory address specified\n",
+			 dev->board_name);
+		return -EINVAL;
+	}
+
+	if (!request_mem_region(membase, II20K_SIZE, dev->board_name)) {
+		dev_warn(dev->class_dev, "%s: I/O mem conflict (%#x,%u)\n",
+			 dev->board_name, membase, II20K_SIZE);
+		return -EIO;
+	}
+	dev->iobase = membase;	/* actually, a memory address */
+
+	dev->mmio = ioremap(membase, II20K_SIZE);
+	if (!dev->mmio)
+		return -ENOMEM;
 
 	id = readb(dev->mmio + II20K_ID_REG);
 	switch (id & II20K_ID_MASK) {
@@ -509,11 +527,19 @@ static int ii20k_attach(struct comedi_device *dev,
 	return 0;
 }
 
+static void ii20k_detach(struct comedi_device *dev)
+{
+	if (dev->mmio)
+		iounmap(dev->mmio);
+	if (dev->iobase)	/* actually, a memory address */
+		release_mem_region(dev->iobase, II20K_SIZE);
+}
+
 static struct comedi_driver ii20k_driver = {
 	.driver_name	= "ii_pci20kc",
 	.module		= THIS_MODULE,
 	.attach		= ii20k_attach,
-	.detach		= comedi_legacy_detach,
+	.detach		= ii20k_detach,
 };
 module_comedi_driver(ii20k_driver);
 
-- 
2.0.0

