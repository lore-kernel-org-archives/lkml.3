Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbbAZNZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:25:47 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:44153 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbbAZNZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:25:42 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] staging: comedi: 8255.c: document subdev_8255_init() and _mm_init()
Date: Mon, 26 Jan 2015 13:25:23 +0000
Message-Id: <1422278725-17740-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
References: <1422278725-17740-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kerneldoc comments for the subdev_8255_init() and
subdev_8255_mm_init() functions and remove the other comment about how
to use this module in a comedi driver.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/8255.c | 79 ++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/drivers/8255.c b/drivers/staging/comedi/drivers/8255.c
index fafe40b..1476157 100644
--- a/drivers/staging/comedi/drivers/8255.c
+++ b/drivers/staging/comedi/drivers/8255.c
@@ -48,31 +48,6 @@
  * I/O port base address can be found in the output of 'lspci -v'.
  */
 
-/*
-   This file contains an exported subdevice for driving an 8255.
-
-   To use this subdevice as part of another driver, you need to
-   set up the subdevice in the attach function of the driver by
-   calling:
-
-     subdev_8255_init(device, subdevice, io_function, iobase)
-
-   device and subdevice are pointers to the device and subdevice
-   structures.  io_function will be called to provide the
-   low-level input/output to the device, i.e., actual register
-   access.  io_function will be called with the value of iobase
-   as the last parameter.  If the 8255 device is mapped as 4
-   consecutive I/O ports, you can use NULL for io_function
-   and the I/O port base for iobase, and an internal function will
-   handle the register access.
-
-   In addition, if the main driver handles interrupts, you can
-   enable commands on the subdevice by calling subdev_8255_init_irq()
-   instead.  Then, when you get an interrupt that is likely to be
-   from the 8255, you should call subdev_8255_interrupt(), which
-   will copy the latched value to a Comedi buffer.
- */
-
 #include <linux/module.h>
 #include "../comedidev.h"
 
@@ -218,6 +193,33 @@ static int __subdev_8255_init(struct comedi_device *dev,
 	return 0;
 }
 
+/**
+ * subdev_8255_init - initialize DIO subdevice for driving I/O mapped 8255
+ * @dev: comedi device owning subdevice
+ * @s: comedi subdevice to initialize
+ * @io: (optional) register I/O call-back function
+ * @regbase: offset of 8255 registers from dev->iobase, or call-back context
+ *
+ * Initializes a comedi subdevice as a DIO subdevice driving an 8255 chip.
+ *
+ * If the optional I/O call-back function is provided, its prototype is of
+ * the following form:
+ *
+ *   int my_8255_callback(struct comedi_device *dev,
+ *                        struct comedi_subdevice *s, int dir, int port,
+ *                        int data, unsigned long regbase);
+ *
+ * where 'dev', 's', and 'regbase' match the values passed to this function,
+ * 'port' is the 8255 port number 0 to 3 (including the control port), 'dir'
+ * is the direction (0 for read, 1 for write) and 'data' is the value to be
+ * written.  It should return 0 if writing or the value read if reading.
+ *
+ * If the optional I/O call-back function is not provided, an internal
+ * call-back function is used which uses consecutive I/O port addresses
+ * starting at dev->iobase + regbase.
+ *
+ * Return: -ENOMEM if failed to allocate memory, zero on success.
+ */
 int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 		     int (*io)(struct comedi_device *,
 			       int, int, int, unsigned long),
@@ -227,6 +229,33 @@ int subdev_8255_init(struct comedi_device *dev, struct comedi_subdevice *s,
 }
 EXPORT_SYMBOL_GPL(subdev_8255_init);
 
+/**
+ * subdev_8255_mm_init - initialize DIO subdevice for driving mmio-mapped 8255
+ * @dev: comedi device owning subdevice
+ * @s: comedi subdevice to initialize
+ * @io: (optional) register I/O call-back function
+ * @regbase: offset of 8255 registers from dev->mmio, or call-back context
+ *
+ * Initializes a comedi subdevice as a DIO subdevice driving an 8255 chip.
+ *
+ * If the optional I/O call-back function is provided, its prototype is of
+ * the following form:
+ *
+ *   int my_8255_callback(struct comedi_device *dev,
+ *                        struct comedi_subdevice *s, int dir, int port,
+ *                        int data, unsigned long regbase);
+ *
+ * where 'dev', 's', and 'regbase' match the values passed to this function,
+ * 'port' is the 8255 port number 0 to 3 (including the control port), 'dir'
+ * is the direction (0 for read, 1 for write) and 'data' is the value to be
+ * written.  It should return 0 if writing or the value read if reading.
+ *
+ * If the optional I/O call-back function is not provided, an internal
+ * call-back function is used which uses consecutive MMIO virtual addresses
+ * starting at dev->mmio + regbase.
+ *
+ * Return: -ENOMEM if failed to allocate memory, zero on success.
+ */
 int subdev_8255_mm_init(struct comedi_device *dev, struct comedi_subdevice *s,
 			int (*io)(struct comedi_device *,
 				  int, int, int, unsigned long),
-- 
2.1.4

