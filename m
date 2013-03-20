Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab3CTQ3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:29:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab3CTQ3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:29:39 -0400
Date: Wed, 20 Mar 2013 17:29:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Greg KH <greg@kroah.com>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Imre Deak <imre.deak@intel.com>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re:
 [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1]
 irq 16: nobody cared (was [3.9-rc1] very poor interrupt respo
In-Reply-To: <Pine.LNX.4.44L0.1303191417440.1302-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1303201728070.17295@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303191417440.1302-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Alan Stern wrote:

> > > That might be misleading.  It's possible that the erroneous IRQs _are_
> > > being issued but you're simply not aware of them.  If the kernel thinks
> > > that no device is using IRQ 16 then it will leave that IRQ disabled.
> > 
> > I guess I should have phrased it more precisely, but that's exactly
> > what I expect is happening on my machine: I don't have anything on
> > irq16 (i.e. in non-msi mode the gfx interrupt isn't shared) and hence
> > the irq is completely disabled. Which obviously makes it impossible
> > for me to reproduce the issue. To test that theory, is there a quick
> > way to force-enable a given interrupt, short of just hacking up a 2nd
> > dummy irq handler in my driver?
> 
> I don't know of any way.  In fact, I have been thinking of writing a 
> test driver module, with a module parameter telling it which IRQ number 
> to register for.  It seems like the sort of thing that would be useful 
> to have, from time to time.

Ok, so how about this?
Daniel, is it enough to make the problem appear on your system (by 
building this into the kernel and booting with dummy-irq.irq=16)?

Thanks.





From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] dummy-irq: introduce a dummy IRQ handler driver

This module accepts a single 'irq' parameter, which it should register for.

Its sole purpose is to help with debugging of IRQ sharing problems, by
force-enabling IRQ that would otherwise be disabled.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/misc/Kconfig     |    8 ++++++
 drivers/misc/Makefile    |    1 +
 drivers/misc/dummy-irq.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/dummy-irq.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e83fdfe..db24b79 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -93,6 +93,14 @@ config ATMEL_TCB_CLKSRC_BLOCK
 	  TC can be used for other purposes, such as PWM generation and
 	  interval timing.
 
+config DUMMY_IRQ
+	tristate "Dummy IRQ handler"
+	default n
+	---help---
+	  This module accepts a single 'irq' parameter, which it should register for.
+	  Its sole purpose is to help with debugging of IRQ sharing problems, by
+	  force-enabling IRQ that would otherwise be disabled.
+
 config IBM_ASM
 	tristate "Device driver for IBM RSA service processor"
 	depends on X86 && PCI && INPUT
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 35a1463..28ff261 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_ATMEL_TCLIB)	+= atmel_tclib.o
 obj-$(CONFIG_BMP085)		+= bmp085.o
 obj-$(CONFIG_BMP085_I2C)	+= bmp085-i2c.o
 obj-$(CONFIG_BMP085_SPI)	+= bmp085-spi.o
+obj-$(CONFIG_DUMMY_IRQ)		+= dummy-irq.o
 obj-$(CONFIG_ICS932S401)	+= ics932s401.o
 obj-$(CONFIG_LKDTM)		+= lkdtm.o
 obj-$(CONFIG_TIFM_CORE)       	+= tifm_core.o
diff --git a/drivers/misc/dummy-irq.c b/drivers/misc/dummy-irq.c
new file mode 100644
index 0000000..4fc13e0
--- /dev/null
+++ b/drivers/misc/dummy-irq.c
@@ -0,0 +1,59 @@
+/*
+ * Dummy IRQ handler driver.
+ *
+ * This module only registers itself as a handler that is specified to it
+ * by the 'irq' parameter.
+ *
+ * The sole purpose of this module is to help with debugging of systems on
+ * which spurious IRQs cause the IRQ to be disabled.
+ *
+ * Copyright (C) 2013 Jiri Kosina
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+
+static int irq;
+
+static irqreturn_t dummy_interrupt(int irq, void *dev_id)
+{
+	static int count = 0;
+
+	if (count == 0) {
+		printk("dummy-irq: interrupt occured on IRQ %d\n", irq);
+		count++;
+	}
+
+	return IRQ_NONE;
+}
+
+static int __init dummy_irq_init(void)
+{
+	if (request_irq(irq, &dummy_interrupt, IRQF_SHARED, "dummy_irq", &irq)) {
+		printk(KERN_ERR "dummy-irq: cannot register IRQ %d\n", irq);
+		return -EIO;
+	}
+	printk(KERN_INFO "dummy-irq: registered for IRQ %d\n", irq);
+	return 0;
+}
+
+static void __exit dummy_irq_exit(void)
+{
+	printk(KERN_INFO "dummy-irq unloaded\n");
+	free_irq(irq, &irq);
+	return;
+}
+
+module_init(dummy_irq_init);
+module_exit(dummy_irq_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jiri Kosina");
+module_param_named(irq, irq, uint, 0444);
+MODULE_PARM_DESC(irq, "The IRQ to register for");

-- 
Jiri Kosina
SUSE Labs
