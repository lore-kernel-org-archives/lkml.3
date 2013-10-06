Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3JFU22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:28:28 -0400
Received: from ring0.de ([91.143.88.219]:45475 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3JFU2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:28:22 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?=27Pali=20Roh=C3=A1r=27?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=27=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2=27?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Sebastian Reichel <sre@debian.org>
Subject: [RFCv3 2/7] HSI: add Device Tree support for HSI clients
Date: Sun,  6 Oct 2013 22:27:10 +0200
Message-Id: <1381091235-18293-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381091235-18293-1-git-send-email-sre@debian.org>
References: <1381091235-18293-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new method hsi_add_clients_from_dt, which can be used
to initialize HSI clients from a device tree node.

The patch also documents the DT binding for trivial HSI
clients.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/hsi/trivial-devices.txt    | 36 +++++++++++
 drivers/hsi/hsi.c                                  | 70 +++++++++++++++++++++-
 include/dt-bindings/hsi/hsi.h                      | 17 ++++++
 include/linux/hsi/hsi.h                            |  2 +
 4 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/trivial-devices.txt
 create mode 100644 include/dt-bindings/hsi/hsi.h

diff --git a/Documentation/devicetree/bindings/hsi/trivial-devices.txt b/Documentation/devicetree/bindings/hsi/trivial-devices.txt
new file mode 100644
index 0000000..1ace14a
--- /dev/null
+++ b/Documentation/devicetree/bindings/hsi/trivial-devices.txt
@@ -0,0 +1,36 @@
+This is a list of trivial hsi client devices that have simple
+device tree bindings, consisting only of a compatible field
+and the optional hsi configuration.
+
+If a device needs more specific bindings, such as properties to
+describe some aspect of it, there needs to be a specific binding
+document for it just like any other devices.
+
+Optional HSI configuration properties:
+
+- hsi,mode		Bit transmission mode (STREAM or FRAME)
+			The first value is used for RX and the second one for
+			TX configuration. If only one value is provided it will
+			be used for RX and TX.
+			The assignments may be found in header file
+			<dt-bindings/hsi/hsi.h>.
+- hsi,channels		Number of channels to use [1..16]
+			The first value is used for RX and the second one for
+			TX configuration. If only one value is provided it will
+			be used for RX and TX.
+- hsi,speed		Max bit transmission speed (Kbit/s)
+			The first value is used for RX and the second one for
+			TX configuration. If only one value is provided it will
+			be used for RX and TX.
+- hsi,flow		RX flow type (SYNCHRONIZED or PIPELINE)
+			The assignments may be found in header file
+			<dt-bindings/hsi/hsi.h>.
+- hsi,arb_mode		Arbitration mode for TX frame (Round robin, priority)
+			The assignments may be found in header file
+			<dt-bindings/hsi/hsi.h>.
+
+This is the list of trivial client devices:
+
+Compatible		Description
+==========		=============
+hsi-char		HSI character device
diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 66d4458..4384d7e 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -26,6 +26,8 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/notifier.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include "hsi_core.h"
 
 static ssize_t modalias_show(struct device *dev,
@@ -48,7 +50,10 @@ static int hsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static int hsi_bus_match(struct device *dev, struct device_driver *driver)
 {
-	return strcmp(dev_name(dev), driver->name) == 0;
+	if (dev->of_node != NULL)
+		return of_driver_match_device(dev, driver);
+	else
+		return strcmp(dev_name(dev), driver->name) == 0;
 }
 
 static struct bus_type hsi_bus_type = {
@@ -73,6 +78,7 @@ static void hsi_new_client(struct hsi_port *port, struct hsi_board_info *info)
 	cl->tx_cfg = info->tx_cfg;
 	cl->rx_cfg = info->rx_cfg;
 	cl->device.bus = &hsi_bus_type;
+
 	cl->device.parent = &port->device;
 	cl->device.release = hsi_client_release;
 	dev_set_name(&cl->device, "%s", info->name);
@@ -99,6 +105,68 @@ static void hsi_scan_board_info(struct hsi_controller *hsi)
 		}
 }
 
+static void hsi_of_get_client_cfg_property(struct device_node *client,
+				char *name, unsigned int *rx, unsigned int *tx)
+{
+	int err;
+
+	err = of_property_read_u32_index(client, name, 0, rx);
+	if (!err)
+		*rx = 0;
+
+	err = of_property_read_u32_index(client, name, 1, tx);
+	if (!err)
+		*tx = *rx;
+}
+
+static void hsi_add_client_from_dt(struct hsi_port *port,
+						struct device_node *client)
+{
+	struct hsi_client *cl;
+	const char *name;
+	int err;
+
+	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
+	if (!cl)
+		return;
+
+	err = of_property_read_string(client, "compatible", &name);
+	if (!err) {
+		dev_set_name(&cl->device, "%s", name);
+	} else {
+		kfree(cl);
+		return;
+	}
+
+	hsi_of_get_client_cfg_property(client, "hsi,mode", &cl->rx_cfg.mode,
+							&cl->tx_cfg.mode);
+	hsi_of_get_client_cfg_property(client, "hsi,speed", &cl->rx_cfg.speed,
+							&cl->tx_cfg.speed);
+	hsi_of_get_client_cfg_property(client, "hsi,channels",
+				&cl->rx_cfg.channels, &cl->tx_cfg.channels);
+	of_property_read_u32(client, "hsi,flow", &cl->rx_cfg.flow);
+	of_property_read_u32(client, "hsi,arb_mode", &cl->tx_cfg.arb_mode);
+
+	cl->device.bus = &hsi_bus_type;
+	cl->device.parent = &port->device;
+	cl->device.release = hsi_client_release;
+	cl->device.of_node = client;
+
+	if (device_register(&cl->device) < 0) {
+		pr_err("hsi: failed to register client: %s\n", name);
+		put_device(&cl->device);
+	}
+}
+
+void hsi_add_clients_from_dt(struct hsi_port *port, struct device_node *clients)
+{
+	struct device_node *child;
+
+	for_each_available_child_of_node(clients, child)
+		hsi_add_client_from_dt(port, child);
+}
+EXPORT_SYMBOL_GPL(hsi_add_clients_from_dt);
+
 static int hsi_remove_client(struct device *dev, void *data __maybe_unused)
 {
 	device_unregister(dev);
diff --git a/include/dt-bindings/hsi/hsi.h b/include/dt-bindings/hsi/hsi.h
new file mode 100644
index 0000000..2d6b181
--- /dev/null
+++ b/include/dt-bindings/hsi/hsi.h
@@ -0,0 +1,17 @@
+/*
+ * This header provides constants for hsi client bindings.
+ */
+
+#ifndef _DT_BINDINGS_HSI_H
+#define _DT_BINDINGS_HSI_H
+
+#define HSI_MODE_STREAM 1
+#define HSI_MODE_FRAME 2
+
+#define HSI_FLOW_SYNC 0
+#define HSI_FLOW_PIPE 1
+
+#define HSI_ARB_RR 0
+#define HSI_ARB_PRIO 1
+
+#endif /* _DT_BINDINGS_HSI_H */
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index 0dca785..fb07339 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -282,6 +282,8 @@ struct hsi_controller *hsi_alloc_controller(unsigned int n_ports, gfp_t flags);
 void hsi_put_controller(struct hsi_controller *hsi);
 int hsi_register_controller(struct hsi_controller *hsi);
 void hsi_unregister_controller(struct hsi_controller *hsi);
+void hsi_add_clients_from_dt(struct hsi_port *port,
+						struct device_node *clients);
 
 static inline void hsi_controller_set_drvdata(struct hsi_controller *hsi,
 								void *data)
-- 
1.8.4.rc3

