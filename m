Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaC2Afx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:35:53 -0400
Received: from ring0.de ([5.45.105.125]:43193 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbaC2Ael (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:34:41 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 11/14] HSI: Introduce Nokia N900 modem driver
Date: Sat, 29 Mar 2014 01:31:47 +0100
Message-Id: <1396053110-21639-12-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Nokia N900's modem is connected via Synchronous Serial Interface (SSI),
which is a legacy version of MIPI's High-speed Synchronous Serial Interface
(HSI).

The handles the GPIOs for enabling and resetting the modem and instanciates
ssi-protocol for data exchange. It does not yet support exchanging voice data
with the modem.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 .../devicetree/bindings/hsi/nokia-modem.txt        |  58 +++++
 drivers/hsi/clients/Kconfig                        |   9 +
 drivers/hsi/clients/Makefile                       |   1 +
 drivers/hsi/clients/nokia-modem.c                  | 272 +++++++++++++++++++++
 4 files changed, 340 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hsi/nokia-modem.txt
 create mode 100644 drivers/hsi/clients/nokia-modem.c

diff --git a/Documentation/devicetree/bindings/hsi/nokia-modem.txt b/Documentation/devicetree/bindings/hsi/nokia-modem.txt
new file mode 100644
index 0000000..a8b8b6b
--- /dev/null
+++ b/Documentation/devicetree/bindings/hsi/nokia-modem.txt
@@ -0,0 +1,58 @@
+Nokia modem client bindings
+
+The Nokia modem HSI client follows the common HSI
+client binding and inherits all required properties.
+The following additional properties are needed by
+the Nokia modem HSI client:
+
+Required properties:
+- compatible:		Should be one of
+      "nokia,n900-modem"
+- reg-names:		Should contain the following strings
+      "mcsaab-control"
+      "speech-control"
+      "speech-data"
+      "mcsaab-data"
+- gpios:		Should provide a GPIO handler for each GPIO listed in
+                        gpio-names
+- gpio-names:		Should contain the following strings
+      "cmt_apeslpx"
+      "cmt_rst_rq"
+      "cmt_en"
+      "cmt_rst"
+      "cmt_bsi"
+- interrupts:		Should be IRQ handle for modem's reset indication
+
+Example:
+
+&ssi_port {
+	modem: hsi-client {
+		compatible = "nokia,n900-modem";
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&modem_pins>;
+
+		reg = <0>, <1>, <2>, <3>;
+		reg-names = "mcsaab-control",
+			    "speech-control",
+			    "speech-data",
+			    "mcsaab-data";
+		hsi-speed-kbps = <55000>;
+		hsi-mode = "frame";
+		hsi-flow = "synchronized";
+		hsi-arb-mode = "round-robin";
+
+		interrupts-extended = <&gpio3 8 IRQ_TYPE_EDGE_FALLING>; /* 72 */
+
+		gpios = <&gpio3  6 GPIO_ACTIVE_HIGH>, /* 70 */
+			<&gpio3  9 GPIO_ACTIVE_HIGH>, /* 73 */
+			<&gpio3 10 GPIO_ACTIVE_HIGH>, /* 74 */
+			<&gpio3 11 GPIO_ACTIVE_HIGH>, /* 75 */
+			<&gpio5 29 GPIO_ACTIVE_HIGH>; /* 157 */
+		gpio-names = "cmt_apeslpx",
+			     "cmt_rst_rq",
+			     "cmt_en",
+			     "cmt_rst",
+			     "cmt_bsi";
+	};
+};
diff --git a/drivers/hsi/clients/Kconfig b/drivers/hsi/clients/Kconfig
index 0c70861..6ce1ea2 100644
--- a/drivers/hsi/clients/Kconfig
+++ b/drivers/hsi/clients/Kconfig
@@ -4,6 +4,15 @@
 
 comment "HSI clients"
 
+config NOKIA_MODEM
+	tristate "Nokia Modem"
+	depends on SSI_PROTOCOL
+	help
+	Say Y here if you want to add support for the modem on Nokia
+	N900 (Nokia RX-51) hardware.
+
+	If unsure, say N.
+
 config SSI_PROTOCOL
 	tristate "SSI protocol"
 	depends on HSI && OMAP_SSI && PHONET
diff --git a/drivers/hsi/clients/Makefile b/drivers/hsi/clients/Makefile
index ccbf768..4d5bc0e 100644
--- a/drivers/hsi/clients/Makefile
+++ b/drivers/hsi/clients/Makefile
@@ -2,5 +2,6 @@
 # Makefile for HSI clients
 #
 
+obj-$(CONFIG_NOKIA_MODEM)	+= nokia-modem.o
 obj-$(CONFIG_SSI_PROTOCOL)	+= ssi_protocol.o
 obj-$(CONFIG_HSI_CHAR)		+= hsi_char.o
diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
new file mode 100644
index 0000000..f12ec76
--- /dev/null
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -0,0 +1,272 @@
+/*
+ * nokia-modem.c
+ *
+ * HSI client driver for Nokia N900 modem.
+ *
+ * Copyright (C) 2014 Sebastian Reichel <sre@kernel.org>
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
+#include <linux/gpio/consumer.h>
+#include <linux/hsi/hsi.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_gpio.h>
+#include <linux/hsi/ssi_protocol.h>
+
+struct nokia_modem_gpio {
+	struct gpio_desc	*gpio;
+	const char		*name;
+};
+
+struct nokia_modem_device {
+	struct tasklet_struct	nokia_modem_rst_ind_tasklet;
+	int			nokia_modem_rst_ind_irq;
+	struct device		*device;
+	struct nokia_modem_gpio	*gpios;
+	int			gpio_amount;
+	struct hsi_client	*ssi_protocol;
+};
+
+static void do_nokia_modem_rst_ind_tasklet(unsigned long data)
+{
+	struct nokia_modem_device *modem = (struct nokia_modem_device *)data;
+
+	if (!modem)
+		return;
+
+	dev_info(modem->device, "*** CMT rst line change detected ***\n");
+
+	if (modem->ssi_protocol)
+		ssip_reset_event(modem->ssi_protocol);
+}
+
+static irqreturn_t nokia_modem_rst_ind_isr(int irq, void *data)
+{
+	struct nokia_modem_device *modem = (struct nokia_modem_device *)data;
+
+	tasklet_schedule(&modem->nokia_modem_rst_ind_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static void nokia_modem_gpio_unexport(struct device *dev)
+{
+	struct nokia_modem_device *modem = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < modem->gpio_amount; i++) {
+		sysfs_remove_link(&dev->kobj, modem->gpios[i].name);
+		gpiod_unexport(modem->gpios[i].gpio);
+	}
+}
+
+static int nokia_modem_gpio_probe(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct nokia_modem_device *modem = dev_get_drvdata(dev);
+	int gpio_count, gpio_name_count, i, err;
+
+	gpio_count = of_gpio_count(np);
+	gpio_name_count = of_property_count_strings(np, "gpio-names");
+
+	if(gpio_count != gpio_name_count) {
+		dev_err(dev, "number of gpios does not equal number of gpio names\n");
+		return -EINVAL;
+	}
+
+	modem->gpios = devm_kzalloc(dev, gpio_count*sizeof(struct nokia_modem_gpio),
+								GFP_KERNEL);
+	if (modem->gpios == NULL) {
+		dev_err(dev, "Could not allocate memory for gpios\n");
+		return -ENOMEM;
+	}
+
+	modem->gpio_amount = gpio_count;
+
+	for (i = 0; i < gpio_count; i++) {
+		modem->gpios[i].gpio = devm_gpiod_get_index(dev, NULL, i);
+		if (IS_ERR(modem->gpios[i].gpio)) {
+			dev_err(dev, "Could not get gpio %d\n", i);
+			return PTR_ERR(modem->gpios[i].gpio);
+		}
+
+		err = of_property_read_string_index(np, "gpio-names", i,
+							&(modem->gpios[i].name));
+		if (err) {
+			dev_err(dev, "Could not get gpio name %d\n", i);
+			return err;
+		}
+
+		err = gpiod_direction_output(modem->gpios[i].gpio, 0);
+		if (err)
+			return err;
+
+		err = gpiod_export(modem->gpios[i].gpio, 0);
+		if (err)
+			return err;
+
+		err = gpiod_export_link(dev, modem->gpios[i].name,
+							modem->gpios[i].gpio);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int nokia_modem_probe(struct device *dev)
+{
+	struct device_node *np;
+	struct nokia_modem_device *modem;
+	struct hsi_client *cl = to_hsi_client(dev);
+	struct hsi_port *port = hsi_get_port(cl);
+	int irq, pflags, err;
+	struct hsi_board_info ssip;
+
+	np = dev->of_node;
+	if (!np) {
+		dev_err(dev, "device tree node not found\n");
+		return -ENXIO;
+	}
+
+	modem = devm_kzalloc(dev, sizeof(*modem), GFP_KERNEL);
+	if (!modem) {
+		dev_err(dev, "Could not allocate memory for nokia_modem_device\n");
+		return -ENOMEM;
+	}
+	dev_set_drvdata(dev, modem);
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq < 0) {
+		dev_err(dev, "Invalid nokia_modem_rst_ind interrupt: %d\n", irq);
+		return irq;
+	}
+	modem->nokia_modem_rst_ind_irq = irq;
+	pflags = irq_get_trigger_type(irq);
+
+	tasklet_init(&modem->nokia_modem_rst_ind_tasklet,
+			do_nokia_modem_rst_ind_tasklet, (unsigned long)modem);
+	err = devm_request_irq(dev, irq, nokia_modem_rst_ind_isr,
+				IRQF_DISABLED | pflags, "modem_rst_ind", modem);
+	if (err < 0) {
+		dev_err(dev, "Request modem_rst_ind irq(%d) failed (flags %d)\n",
+								irq, pflags);
+		return err;
+	}
+	enable_irq_wake(irq);
+
+	err = nokia_modem_gpio_probe(dev);
+	if (err < 0) {
+		dev_err(dev, "Could not probe GPIOs\n");
+		goto error1;
+	}
+
+	ssip.name = "ssi-protocol";
+	ssip.tx_cfg = cl->tx_cfg;
+	ssip.rx_cfg = cl->rx_cfg;
+	ssip.platform_data = NULL;
+	ssip.archdata = NULL;
+
+	modem->ssi_protocol = hsi_new_client(port, &ssip);
+	if (modem->ssi_protocol == NULL) {
+		dev_err(dev, "Could not register ssi-protocol device\n");
+		goto error2;
+	}
+
+	err = device_attach(&modem->ssi_protocol->device);
+	if (err == 0) {
+		dev_err(dev, "Missing ssi-protocol driver\n");
+		err = -EPROBE_DEFER;
+		goto error3;
+	} else if (err < 0) {
+		dev_err(dev, "Could not load ssi-protocol driver (%d)\n", err);
+		goto error3;
+	}
+
+	/* TODO: register cmt-speech hsi client */
+
+	dev_info(dev, "Registered Nokia HSI modem\n");
+
+	return 0;
+
+error3:
+	hsi_remove_client(&modem->ssi_protocol->device, NULL);
+error2:
+	nokia_modem_gpio_unexport(dev);
+error1:
+	disable_irq_wake(modem->nokia_modem_rst_ind_irq);
+	tasklet_kill(&modem->nokia_modem_rst_ind_tasklet);
+
+	return err;
+}
+
+static int nokia_modem_remove(struct device *dev)
+{
+	struct nokia_modem_device *modem = dev_get_drvdata(dev);
+
+	if (!modem)
+		return 0;
+
+	if (modem->ssi_protocol) {
+		hsi_remove_client(&modem->ssi_protocol->device, NULL);
+		modem->ssi_protocol = NULL;
+	}
+
+	nokia_modem_gpio_unexport(dev);
+	dev_set_drvdata(dev, NULL);
+	disable_irq_wake(modem->nokia_modem_rst_ind_irq);
+	tasklet_kill(&modem->nokia_modem_rst_ind_tasklet);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id nokia_modem_of_match[] = {
+       { .compatible = "nokia,n900-modem", },
+       {},
+};
+MODULE_DEVICE_TABLE(of, nokia_modem_of_match);
+#endif
+
+static struct hsi_client_driver nokia_modem_driver = {
+	.driver = {
+		.name	= "nokia-modem",
+		.owner	= THIS_MODULE,
+		.probe	= nokia_modem_probe,
+		.remove	= nokia_modem_remove,
+		.of_match_table = of_match_ptr(nokia_modem_of_match),
+	},
+};
+
+static int __init nokia_modem_init(void)
+{
+	return hsi_register_client_driver(&nokia_modem_driver);
+}
+module_init(nokia_modem_init);
+
+static void __exit nokia_modem_exit(void)
+{
+	hsi_unregister_client_driver(&nokia_modem_driver);
+}
+module_exit(nokia_modem_exit);
+
+MODULE_ALIAS("hsi:nokia-modem");
+MODULE_AUTHOR("Sebastian Reichel <sre@kernel.org>");
+MODULE_DESCRIPTION("HSI driver module for Nokia N900 Modem");
+MODULE_LICENSE("GPL");
-- 
1.9.0

