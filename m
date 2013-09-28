Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab3I1UCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:02:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3I1UCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:02:02 -0400
Date: Sat, 28 Sep 2013 13:01:59 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] serial: 8250_pci: clean up printk() calls
Message-ID: <20130928200159.GA19968@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the printk() calls to to dev_*() instead, to tie into the dynamic
debugging infrastructure.

Also change some "raw" printk() calls to dev_err() to provide a better
error message to userspace so it can properly identify the device and
not just have to guess.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |   40 +++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -9,6 +9,7 @@
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License.
  */
+#undef DEBUG
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
@@ -27,8 +28,6 @@
 
 #include "8250.h"
 
-#undef SERIAL_DEBUG_PCI
-
 /*
  * init function returns:
  *  > 0 - number of ports
@@ -63,7 +62,7 @@ static int pci_default_setup(struct seri
 
 static void moan_device(const char *str, struct pci_dev *dev)
 {
-	printk(KERN_WARNING
+	dev_err(&dev->dev,
 	       "%s: %s\n"
 	       "Please send the output of lspci -vv, this\n"
 	       "message (0x%04x,0x%04x,0x%04x,0x%04x), the\n"
@@ -233,7 +232,7 @@ static int pci_inteli960ni_init(struct p
 	/* is firmware started? */
 	pci_read_config_dword(dev, 0x44, (void *)&oldval);
 	if (oldval == 0x00001000L) { /* RESET value */
-		printk(KERN_DEBUG "Local i960 firmware missing");
+		dev_dbg(&dev->dev, "Local i960 firmware missing\n");
 		return -ENODEV;
 	}
 	return 0;
@@ -827,7 +826,7 @@ static int pci_netmos_9900_numports(stru
 		if (sub_serports > 0) {
 			return sub_serports;
 		} else {
-			printk(KERN_NOTICE "NetMos/Mostech serial driver ignoring port on ambiguous config.\n");
+			dev_err(&dev->dev, "NetMos/Mostech serial driver ignoring port on ambiguous config.\n");
 			return 0;
 		}
 	}
@@ -931,7 +930,7 @@ static int pci_ite887x_init(struct pci_d
 	}
 
 	if (!inta_addr[i]) {
-		printk(KERN_ERR "ite887x: could not find iobase\n");
+		dev_err(&dev->dev, "ite887x: could not find iobase\n");
 		return -ENODEV;
 	}
 
@@ -1024,9 +1023,9 @@ static int pci_oxsemi_tornado_init(struc
 	/* Tornado device */
 	if (deviceID == 0x07000200) {
 		number_uarts = ioread8(p + 4);
-		printk(KERN_DEBUG
+		dev_dbg(&dev->dev,
 			"%d ports detected on Oxford PCI Express device\n",
-								number_uarts);
+			number_uarts);
 	}
 	pci_iounmap(dev, p);
 	return number_uarts;
@@ -1349,12 +1348,10 @@ static int skip_tx_en_setup(struct seria
 			struct uart_8250_port *port, int idx)
 {
 	port->port.flags |= UPF_NO_TXEN_TEST;
-	printk(KERN_DEBUG "serial8250: skipping TxEn test for device "
-			  "[%04x:%04x] subsystem [%04x:%04x]\n",
-			  priv->dev->vendor,
-			  priv->dev->device,
-			  priv->dev->subsystem_vendor,
-			  priv->dev->subsystem_device);
+	dev_dbg(&priv->dev->dev,
+		"serial8250: skipping TxEn test for device [%04x:%04x] subsystem [%04x:%04x]\n",
+		priv->dev->vendor, priv->dev->device,
+		priv->dev->subsystem_vendor, priv->dev->subsystem_device);
 
 	return pci_default_setup(priv, board, port, idx);
 }
@@ -3361,14 +3358,15 @@ pciserial_init_ports(struct pci_dev *dev
 		if (quirk->setup(priv, board, &uart, i))
 			break;
 
-#ifdef SERIAL_DEBUG_PCI
-		printk(KERN_DEBUG "Setup PCI port: port %lx, irq %d, type %d\n",
-		       uart.port.iobase, uart.port.irq, uart.port.iotype);
-#endif
+		dev_dbg(&dev->dev, "Setup PCI port: port %lx, irq %d, type %d\n",
+			uart.port.iobase, uart.port.irq, uart.port.iotype);
 
 		priv->line[i] = serial8250_register_8250_port(&uart);
 		if (priv->line[i] < 0) {
-			printk(KERN_WARNING "Couldn't register serial port %s: %d\n", pci_name(dev), priv->line[i]);
+			dev_err(&dev->dev,
+				"Couldn't register serial port %lx, irq %d, type %d, error %d\n",
+				uart.port.iobase, uart.port.irq,
+				uart.port.iotype, priv->line[i]);
 			break;
 		}
 	}
@@ -3461,7 +3459,7 @@ pciserial_init_one(struct pci_dev *dev,
 	}
 
 	if (ent->driver_data >= ARRAY_SIZE(pci_boards)) {
-		printk(KERN_ERR "pci_init_one: invalid driver_data: %ld\n",
+		dev_err(&dev->dev, "invalid driver_data: %ld\n",
 			ent->driver_data);
 		return -EINVAL;
 	}
@@ -3554,7 +3552,7 @@ static int pciserial_resume_one(struct p
 		err = pci_enable_device(dev);
 		/* FIXME: We cannot simply error out here */
 		if (err)
-			printk(KERN_ERR "pciserial: Unable to re-enable ports, trying to continue.\n");
+			dev_err(&dev->dev, "Unable to re-enable ports, trying to continue.\n");
 		pciserial_resume_ports(priv);
 	}
 	return 0;
