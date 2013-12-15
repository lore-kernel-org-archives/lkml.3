Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3LOX2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 18:28:50 -0500
Received: from ring0.de ([91.143.88.219]:40097 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab3LOX2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 18:28:45 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: nokia.com]
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv4 06/11] misc: Introduce Nokia CMT driver
Date: Mon, 16 Dec 2013 00:27:59 +0100
Message-Id: <1387150085-23173-7-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387150085-23173-1-git-send-email-sre@debian.org>
References: <1387150085-23173-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add driver handling GPIO pins of Nokia modems. The
driver provides reset notifications, so that SSI
clients can subscribe to them easily.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 drivers/misc/Kconfig      |   7 ++
 drivers/misc/Makefile     |   1 +
 drivers/misc/nokia-cmt.c  | 298 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nokia-cmt.h |  46 +++++++
 4 files changed, 352 insertions(+)
 create mode 100644 drivers/misc/nokia-cmt.c
 create mode 100644 include/linux/nokia-cmt.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a3e291d..74e96cc 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -515,6 +515,13 @@ config SRAM
 	  the genalloc API. It is supposed to be used for small on-chip SRAM
 	  areas found on many SoCs.
 
+config NOKIA_CMT
+	tristate "Enable CMT support"
+	help
+	If you say Y here, you will enable CMT support.
+
+	If unsure, say Y, or else you will not be able to use the CMT.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f45473e..b109e84 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
 obj-y				+= mic/
+obj-$(CONFIG_NOKIA_CMT)		+= nokia-cmt.o
diff --git a/drivers/misc/nokia-cmt.c b/drivers/misc/nokia-cmt.c
new file mode 100644
index 0000000..9c40cf6
--- /dev/null
+++ b/drivers/misc/nokia-cmt.c
@@ -0,0 +1,298 @@
+/*
+ * CMT support.
+ *
+ * Copyright (C) 2009 Nokia Corporation. All rights reserved.
+ * Copyright (C) 2013 Sebastian Reichel <sre@kernel.org>
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <asm/atomic.h>
+#include <linux/nokia-cmt.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+
+/**
+ * struct cmt_gpio - GPIO with name
+ * @gpio: GPIO number
+ * @name: name for the GPIO
+ */
+struct cmt_gpio {
+	int				gpio;
+	const char			*name;
+};
+
+/**
+ * struct cmt_device - CMT device data
+ * @cmt_rst_ind_tasklet: Bottom half for CMT reset line events
+ * @cmt_rst_ind_irq: IRQ number of the CMT reset line
+ * @n_head: List of notifiers registered to get CMT events
+ * @node: Link on the list of available CMTs
+ * @device: Reference to the CMT platform device
+ */
+struct cmt_device {
+	struct tasklet_struct		cmt_rst_ind_tasklet;
+	unsigned int			cmt_rst_ind_irq;
+	struct atomic_notifier_head	n_head;
+	struct list_head		node;
+	struct device			*device;
+	struct cmt_gpio			*gpios;
+	int				gpio_amount;
+};
+
+static LIST_HEAD(cmt_list);	/* List of CMT devices */
+
+int cmt_notifier_register(struct cmt_device *cmtdev, struct notifier_block *nb)
+{
+	struct cmt_device *cmt;
+	int err = -ENODEV;
+
+	if ((!cmtdev) || (!nb))
+		return -EINVAL;
+
+	list_for_each_entry(cmt, &cmt_list, node)
+		if (cmt == cmtdev) {
+			err = atomic_notifier_chain_register(&cmt->n_head, nb);
+			break;
+		}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cmt_notifier_register);
+
+int cmt_notifier_unregister(struct cmt_device *cmtdev,
+						struct notifier_block *nb)
+{
+	struct cmt_device *cmt;
+	int err = -ENODEV;
+
+	if ((!cmtdev) || (!nb))
+		return -EINVAL;
+
+	list_for_each_entry(cmt, &cmt_list, node)
+		if (cmt == cmtdev) {
+			err = atomic_notifier_chain_unregister(&cmt->n_head,
+									nb);
+			break;
+		}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(cmt_notifier_unregister);
+
+struct cmt_device *cmt_get(const char *name)
+{
+	struct cmt_device *p, *cmt = ERR_PTR(-ENODEV);
+
+	list_for_each_entry(p, &cmt_list, node)
+		if (strcmp(name, dev_name(p->device)) == 0) {
+			cmt = p;
+			break;
+		}
+
+	return cmt;
+}
+EXPORT_SYMBOL_GPL(cmt_get);
+
+struct cmt_device *cmt_get_by_phandle(struct device_node *np,
+							const char *propname)
+{
+	struct cmt_device *p, *cmt = ERR_PTR(-EPROBE_DEFER);
+	struct device_node *cmt_np = of_parse_phandle(np, propname, 0);
+
+	if (!cmt_np)
+		return ERR_PTR(-ENOENT);
+
+	list_for_each_entry(p, &cmt_list, node)
+		if (p->device->of_node == cmt_np) {
+			cmt = p;
+			break;
+		}
+
+	of_node_put(cmt_np);
+
+	return cmt;
+}
+EXPORT_SYMBOL_GPL(cmt_get_by_phandle);
+
+void cmt_put(struct cmt_device *cmtdev)
+{
+}
+EXPORT_SYMBOL_GPL(cmt_put);
+
+static void do_cmt_rst_ind_tasklet(unsigned long cmtdev)
+{
+	struct cmt_device *cmt = (struct cmt_device *)cmtdev;
+
+	dev_dbg(cmt->device, "*** CMT rst line change detected ***\n");
+	atomic_notifier_call_chain(&cmt->n_head, CMT_RESET, NULL);
+}
+
+static irqreturn_t cmt_rst_ind_isr(int irq, void *cmtdev)
+{
+	struct cmt_device *cmt = (struct cmt_device *)cmtdev;
+
+	tasklet_schedule(&cmt->cmt_rst_ind_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static int cmt_probe(struct platform_device *pd)
+{
+	struct device_node *np = pd->dev.of_node;
+	struct cmt_device *cmt;
+	int irq, pflags, err, gpio_count, gpio_name_count, i;
+
+	if (!np) {
+		dev_err(&pd->dev, "device tree node not found\n");
+		return -ENXIO;
+	}
+
+	cmt = devm_kzalloc(&pd->dev, sizeof(*cmt), GFP_KERNEL);
+	if (!cmt) {
+		dev_err(&pd->dev, "Could not allocate memory for cmtdev\n");
+		return -ENOMEM;
+	}
+
+	cmt->device = &pd->dev;
+
+	irq = platform_get_irq(pd, 0);
+	if (irq < 0) {
+		dev_err(&pd->dev, "Invalid cmt_rst_ind interrupt\n");
+		return irq;
+	}
+
+	pflags = irq_get_trigger_type(irq);
+
+	tasklet_init(&cmt->cmt_rst_ind_tasklet, do_cmt_rst_ind_tasklet,
+							(unsigned long)cmt);
+	err = devm_request_irq(&pd->dev, irq, cmt_rst_ind_isr,
+		IRQF_DISABLED | pflags, "cmt_rst_ind", cmt);
+	if (err < 0) {
+		dev_err(&pd->dev, "Request cmt_rst_ind irq(%d) failed (flags %d)\n",
+			irq, pflags);
+		return err;
+	}
+	enable_irq_wake(irq);
+
+	ATOMIC_INIT_NOTIFIER_HEAD(&cmt->n_head);
+	list_add(&cmt->node, &cmt_list);
+
+	cmt->cmt_rst_ind_irq = irq;
+	platform_set_drvdata(pd, cmt);
+
+	gpio_count = of_gpio_count(np);
+	gpio_name_count = of_property_count_strings(np, "gpio-names");
+
+	if(gpio_count != gpio_name_count) {
+		dev_err(&pd->dev, "number of gpios does not equal number of gpio names\n");
+		return -EINVAL;
+	}
+
+	cmt->gpios = devm_kzalloc(&pd->dev, gpio_count*sizeof(struct cmt_gpio),
+								GFP_KERNEL);
+	if (cmt->gpios == NULL) {
+		dev_err(&pd->dev, "Could not allocate memory for gpios\n");
+		return -ENOMEM;
+	}
+
+	cmt->gpio_amount = gpio_count;
+
+	for (i = 0; i < gpio_count; i++) {
+		cmt->gpios[i].gpio = of_get_gpio(np, i);
+
+		if (cmt->gpios[i].gpio < 0)
+			return cmt->gpios[i].gpio;
+
+		err = of_property_read_string_index(np, "gpio-names", i,
+							&(cmt->gpios[i].name));
+		if (err)
+			return err;
+
+		err = devm_gpio_request_one(&pd->dev, cmt->gpios[i].gpio,
+							GPIOF_OUT_INIT_LOW,
+							cmt->gpios[i].name);
+		if (err)
+			return err;
+
+		err = gpio_export(cmt->gpios[i].gpio, 0);
+		if (err)
+			return err;
+
+		err = gpio_export_link(&pd->dev, cmt->gpios[i].name,
+							cmt->gpios[i].gpio);
+		if (err)
+			return err;
+	}
+
+	dev_info(&pd->dev, "loaded sucessfully\n");
+
+	return 0;
+}
+
+static int cmt_remove(struct platform_device *pd)
+{
+	struct cmt_device *cmt = platform_get_drvdata(pd);
+	int i;
+
+	if (!cmt)
+		return 0;
+	platform_set_drvdata(pd, NULL);
+	list_del(&cmt->node);
+	disable_irq_wake(cmt->cmt_rst_ind_irq);
+	tasklet_kill(&cmt->cmt_rst_ind_tasklet);
+
+	for (i=0; i < cmt->gpio_amount; i++)
+		sysfs_remove_link(&pd->dev.kobj, cmt->gpios[i].name);
+
+	return 0;
+}
+
+#if defined(CONFIG_OF)
+static const struct of_device_id cmt_of_match[] = {
+	{ .compatible = "nokia,cmt", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, cmt_of_match);
+#endif
+
+static struct platform_driver cmt_driver = {
+	.driver = {
+		.name	= "nokia-cmt",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(cmt_of_match),
+	},
+	.probe = cmt_probe,
+	.remove = cmt_remove,
+};
+
+module_platform_driver(cmt_driver);
+MODULE_AUTHOR("Carlos Chinea, Nokia");
+MODULE_DESCRIPTION("CMT related support");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:nokia-cmt");
diff --git a/include/linux/nokia-cmt.h b/include/linux/nokia-cmt.h
new file mode 100644
index 0000000..2f19a8b
--- /dev/null
+++ b/include/linux/nokia-cmt.h
@@ -0,0 +1,46 @@
+/*
+ * CMT support header
+ *
+ * Copyright (C) 2009 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __NOKIA_CMT_H__
+#define __NOKIA_CMT_H__
+
+#include <linux/notifier.h>
+#include <linux/of.h>
+
+/*
+ * NOKIA CMT notifier events
+ */
+enum {
+	CMT_RESET,
+};
+
+struct cmt_device;
+
+struct cmt_device *cmt_get(const char *name);
+struct cmt_device *cmt_get_by_phandle(struct device_node *np,
+							const char *propname);
+void cmt_put(struct cmt_device *cmt);
+int cmt_notifier_register(struct cmt_device *cmtdev,
+						struct notifier_block *nb);
+int cmt_notifier_unregister(struct cmt_device *cmtdev,
+						struct notifier_block *nb);
+#endif /* __NOKIA_CMT_H__ */
-- 
1.8.5.1

