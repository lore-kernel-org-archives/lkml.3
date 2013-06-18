Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3FRV2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:28:15 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38154 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933056Ab3FRV2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:28:12 -0400
Date: Tue, 18 Jun 2013 23:27:25 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V2 2/2] FMC: add a software mezzanine driver
Message-ID: <6e672540520470bea159deb9eaf7ef8d268a765d.1371589927.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371589927.git.rubini@gnudd.com>
In-Reply-To: <cover.1371589927.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple do-nothing mezzanine driver shows how to write a mezzanine
driver, that can also handle interrupts reported by the carrier.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 Documentation/fmc/00-INDEX        |    3 +
 Documentation/fmc/fmc-trivial.txt |   17 ++++++
 drivers/fmc/Kconfig               |    7 +++
 drivers/fmc/Makefile              |    1 +
 drivers/fmc/fmc-trivial.c         |  107 +++++++++++++++++++++++++++++++++++++
 5 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fmc/fmc-trivial.txt
 create mode 100644 drivers/fmc/fmc-trivial.c

diff --git a/Documentation/fmc/00-INDEX b/Documentation/fmc/00-INDEX
index 34df5cf..c22d687 100644
--- a/Documentation/fmc/00-INDEX
+++ b/Documentation/fmc/00-INDEX
@@ -27,3 +27,6 @@ identifiers.txt
 
 fmc-fakedev.txt
 	- about drivers/fmc/fmc-fakedev.ko
+
+fmc-trivial.txt
+	- about drivers/fmc/fmc-trivial.ko
diff --git a/Documentation/fmc/fmc-trivial.txt b/Documentation/fmc/fmc-trivial.txt
new file mode 100644
index 0000000..d1910bc
--- /dev/null
+++ b/Documentation/fmc/fmc-trivial.txt
@@ -0,0 +1,17 @@
+fmc-trivial
+===========
+
+The simple module fmc-trivial is just a simple client that registers an
+interrupt handler. I used it to verify the basic mechanism of the FMC
+bus and how interrupts worked.
+
+The module implements the generic FMC parameters, so it can program a
+different gateware file in each card. The whole list of parameters it
+accepts are:
+
+`busid='
+`gateware='
+     Generic parameters. See mezzanine.txt
+
+
+This driver is worth reading, in my opinion.
diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
index 505e96b..7eacef9 100644
--- a/drivers/fmc/Kconfig
+++ b/drivers/fmc/Kconfig
@@ -25,4 +25,11 @@ config FMC_FAKEDEV
 	  that can be rewritten at run time and usef for matching
 	  mezzanines.
 
+config FMC_TRIVIAL
+	tristate "FMC trivial mezzanine driver (software testing)"
+	help
+	  This is a fake mezzanine driver, to show how FMC works and test it.
+	  The driver also handles interrupts (we used it with a real carrier
+	  before the mezzanines were produced)
+
 endif # FMC
diff --git a/drivers/fmc/Makefile b/drivers/fmc/Makefile
index 9832b79..52624e6 100644
--- a/drivers/fmc/Makefile
+++ b/drivers/fmc/Makefile
@@ -8,3 +8,4 @@ fmc-y += fru-parse.o
 fmc-y += fmc-dump.o
 
 obj-$(CONFIG_FMC_FAKEDEV) += fmc-fakedev.o
+obj-$(CONFIG_FMC_TRIVIAL) += fmc-trivial.o
diff --git a/drivers/fmc/fmc-trivial.c b/drivers/fmc/fmc-trivial.c
new file mode 100644
index 0000000..6c590f5
--- /dev/null
+++ b/drivers/fmc/fmc-trivial.c
@@ -0,0 +1,107 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * The software is provided "as is"; the copyright holders disclaim
+ * all warranties and liabilities, to the extent permitted by
+ * applicable law.
+ */
+
+/* A trivial fmc driver that can load a gateware file and reports interrupts */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/fmc.h>
+
+static struct fmc_driver t_drv; /* initialized later */
+
+static irqreturn_t t_handler(int irq, void *dev_id)
+{
+	struct fmc_device *fmc = dev_id;
+
+	fmc->op->irq_ack(fmc);
+	dev_info(&fmc->dev, "received irq %i\n", irq);
+	return IRQ_HANDLED;
+}
+
+static struct fmc_gpio t_gpio[] = {
+	{
+		.gpio = FMC_GPIO_IRQ(0),
+		.mode = GPIOF_DIR_IN,
+		.irqmode = IRQF_TRIGGER_RISING,
+	}, {
+		.gpio = FMC_GPIO_IRQ(1),
+		.mode = GPIOF_DIR_IN,
+		.irqmode = IRQF_TRIGGER_RISING,
+	}
+};
+
+static int t_probe(struct fmc_device *fmc)
+{
+	int ret;
+	int index = 0;
+
+	if (fmc->op->validate)
+		index = fmc->op->validate(fmc, &t_drv);
+	if (index < 0)
+		return -EINVAL; /* not our device: invalid */
+
+	ret = fmc->op->irq_request(fmc, t_handler, "fmc-trivial", IRQF_SHARED);
+	if (ret < 0)
+		return ret;
+	/* ignore error code of call below, we really don't care */
+	fmc->op->gpio_config(fmc, t_gpio, ARRAY_SIZE(t_gpio));
+
+	/* Reprogram, if asked to. ESRCH == no filename specified */
+	ret = -ESRCH;
+	if (fmc->op->reprogram)
+		ret = fmc->op->reprogram(fmc, &t_drv, "");
+	if (ret == -ESRCH)
+		ret = 0;
+	if (ret < 0)
+		fmc->op->irq_free(fmc);
+
+	/* FIXME: reprogram LM32 too */
+	return ret;
+}
+
+static int t_remove(struct fmc_device *fmc)
+{
+	fmc->op->irq_free(fmc);
+	return 0;
+}
+
+static struct fmc_driver t_drv = {
+	.version = FMC_VERSION,
+	.driver.name = KBUILD_MODNAME,
+	.probe = t_probe,
+	.remove = t_remove,
+	/* no table, as the current match just matches everything */
+};
+
+ /* We accept the generic parameters */
+FMC_PARAM_BUSID(t_drv);
+FMC_PARAM_GATEWARE(t_drv);
+
+static int t_init(void)
+{
+	int ret;
+
+	ret = fmc_driver_register(&t_drv);
+	return ret;
+}
+
+static void t_exit(void)
+{
+	fmc_driver_unregister(&t_drv);
+}
+
+module_init(t_init);
+module_exit(t_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.7.2
