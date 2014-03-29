Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaC2Adz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:33:55 -0400
Received: from ring0.de ([5.45.105.125]:43096 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaC2Adx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:33:53 -0400
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
Subject: [PATCHv3 07/14] HSI: Add common DT binding for HSI client devices
Date: Sat, 29 Mar 2014 01:31:43 +0100
Message-Id: <1396053110-21639-8-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement and document generic DT bindings for HSI clients.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 .../devicetree/bindings/hsi/client-devices.txt     |  44 +++++
 drivers/hsi/hsi.c                                  | 197 ++++++++++++++++++++-
 include/linux/hsi/hsi.h                            |   2 +
 3 files changed, 241 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/client-devices.txt

diff --git a/Documentation/devicetree/bindings/hsi/client-devices.txt b/Documentation/devicetree/bindings/hsi/client-devices.txt
new file mode 100644
index 0000000..7504cb1
--- /dev/null
+++ b/Documentation/devicetree/bindings/hsi/client-devices.txt
@@ -0,0 +1,44 @@
+Each HSI port is supposed to have one child node, which
+symbols the remote device connected to the HSI port. The
+following properties are standardized for HSI clients:
+
+Required HSI configuration properties:
+
+- reg:			A list of channel ids
+
+- hsi-rx-mode:		Receiver Bit transmission mode ("stream" or "frame")
+- hsi-tx-mode:		Transmitter Bit transmission mode ("stream" or "frame")
+- hsi-mode:		May be used instead hsi-rx-mode and hsi-tx-mode if
+			the transmission mode is the same for receiver and
+			transmitter
+- hsi-speed-kbps:	Max bit transmission speed in kbit/s
+- hsi-flow:		RX flow type ("synchronized" or "pipeline")
+- hsi-arb-mode:		Arbitration mode for TX frame ("round-robin", "priority")
+
+Optional HSI configuration properties:
+
+- reg-names:		A list with one name per channel specified in the
+			reg property
+
+
+Device Tree node example for an HSI client:
+
+hsi-controller {
+	hsi-port {
+		modem: hsi-client {
+			compatible = "nokia,n900-modem";
+
+			reg = <0>, <1>, <2>, <3>;
+			reg-names = "mcsaab-control",
+				    "speech-control",
+				    "speech-data",
+				    "mcsaab-data";
+			hsi-speed-kbps = <55000>;
+			hsi-mode = "frame";
+			hsi-flow = "synchronized";
+			hsi-arb-mode = "round-robin";
+
+			/* more client specific properties */
+		};
+	};
+};
diff --git a/drivers/hsi/hsi.c b/drivers/hsi/hsi.c
index 07e1639..5973906 100644
--- a/drivers/hsi/hsi.c
+++ b/drivers/hsi/hsi.c
@@ -26,8 +26,14 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/notifier.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include "hsi_core.h"
 
+static struct hsi_board_info hsi_char_dev_info = {
+	.name = "hsi_char",
+};
+
 static ssize_t modalias_show(struct device *dev,
 			struct device_attribute *a __maybe_unused, char *buf)
 {
@@ -50,7 +56,13 @@ static int hsi_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 static int hsi_bus_match(struct device *dev, struct device_driver *driver)
 {
-	return strcmp(dev_name(dev), driver->name) == 0;
+	if (of_driver_match_device(dev, driver))
+		return true;
+
+	if (strcmp(dev_name(dev), driver->name) == 0)
+		return true;
+
+	return false;
 }
 
 static struct bus_type hsi_bus_type = {
@@ -126,6 +138,187 @@ static void hsi_scan_board_info(struct hsi_controller *hsi)
 		}
 }
 
+static int hsi_of_property_parse_mode(struct device_node *client, char *name,
+				      unsigned int *result)
+{
+	const char *mode;
+	int err;
+
+	err = of_property_read_string(client, name, &mode);
+	if (err < 0)
+		return err;
+
+	if (strcmp(mode, "stream") == 0)
+		*result = HSI_MODE_STREAM;
+	else if (strcmp(mode, "frame") == 0)
+		*result = HSI_MODE_FRAME;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int hsi_of_property_parse_flow(struct device_node *client, char *name,
+				      unsigned int *result)
+{
+	const char *flow;
+	int err;
+
+	err = of_property_read_string(client, name, &flow);
+	if (err < 0)
+		return err;
+
+	if (strcmp(flow, "synchronized") == 0)
+		*result = HSI_FLOW_SYNC;
+	else if (strcmp(flow, "pipeline") == 0)
+		*result = HSI_FLOW_PIPE;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int hsi_of_property_parse_arb_mode(struct device_node *client,
+					  char *name, unsigned int *result)
+{
+	const char *arb_mode;
+	int err;
+
+	err = of_property_read_string(client, name, &arb_mode);
+	if (err < 0)
+		return err;
+
+	if (strcmp(arb_mode, "round-robin") == 0)
+		*result = HSI_ARB_RR;
+	else if (strcmp(arb_mode, "priority") == 0)
+		*result = HSI_ARB_PRIO;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static void hsi_add_client_from_dt(struct hsi_port *port,
+						struct device_node *client)
+{
+	struct hsi_client *cl;
+	struct hsi_channel *channels;
+	struct property *prop;
+	char name[32];
+	int length, cells, err, i, max_chan, mode;
+
+	cl = kzalloc(sizeof(*cl), GFP_KERNEL);
+	if (!cl)
+		return;
+
+	err = of_modalias_node(client, name, sizeof(name));
+	if (err)
+		goto err;
+
+	dev_set_name(&cl->device, "%s", name);
+
+	err = hsi_of_property_parse_mode(client, "hsi-mode", &mode);
+	if (err) {
+		err = hsi_of_property_parse_mode(client, "hsi-rx-mode",
+						 &cl->rx_cfg.mode);
+		if (err)
+			goto err;
+
+		err = hsi_of_property_parse_mode(client, "hsi-tx-mode",
+						 &cl->tx_cfg.mode);
+		if (err)
+			goto err;
+	} else {
+		cl->rx_cfg.mode = mode;
+		cl->tx_cfg.mode = mode;
+	}
+
+	err = of_property_read_u32(client, "hsi-speed-kbps",
+				   &cl->tx_cfg.speed);
+	if (err)
+		goto err;
+	cl->rx_cfg.speed = cl->tx_cfg.speed;
+
+	err = hsi_of_property_parse_flow(client, "hsi-flow",
+					 &cl->rx_cfg.flow);
+	if (err)
+		goto err;
+
+	err = hsi_of_property_parse_arb_mode(client, "hsi-arb-mode",
+					     &cl->rx_cfg.arb_mode);
+	if (err)
+		goto err;
+
+	prop = of_find_property(client, "reg", &length);
+	if (!prop) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	cells = length / sizeof(u32);
+
+	cl->rx_cfg.num_channels = cells;
+	cl->tx_cfg.num_channels = cells;
+
+	channels = kzalloc(cells * sizeof(*channels), GFP_KERNEL);
+	if (!channels) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	cl->tx_cfg.channels = channels;
+	cl->rx_cfg.channels = channels;
+
+	for (i=0; i < cells; i++) {
+		err = of_property_read_u32_index(client, "reg", i,
+							&channels[i].id);
+		if (err)
+			goto err2;
+
+		err = of_property_read_string_index(client, "reg-names", i,
+							&channels[i].name);
+		if (err)
+			channels[i].name = NULL;
+
+		if (channels[i].id > max_chan)
+			max_chan = channels[i].id;
+	}
+
+	cl->rx_cfg.num_hw_channels = max_chan + 1;
+	cl->tx_cfg.num_hw_channels = max_chan + 1;
+
+	cl->device.bus = &hsi_bus_type;
+	cl->device.parent = &port->device;
+	cl->device.release = hsi_client_release;
+	cl->device.of_node = client;
+
+	if (device_register(&cl->device) < 0) {
+		pr_err("hsi: failed to register client: %s\n", name);
+		put_device(&cl->device);
+		goto err2;
+	}
+
+	return;
+
+err2:
+	kfree(channels);
+err:
+	kfree(cl);
+	pr_err("hsi client: missing or incorrect of property: err=%d\n", err);
+}
+
+void hsi_add_clients_from_dt(struct hsi_port *port, struct device_node *clients)
+{
+	struct device_node *child;
+
+	/* register hsi-char device */
+	hsi_new_client(port, &hsi_char_dev_info);
+
+	for_each_available_child_of_node(clients, child)
+		hsi_add_client_from_dt(port, child);
+}
+EXPORT_SYMBOL_GPL(hsi_add_clients_from_dt);
+
 int hsi_remove_client(struct device *dev, void *data __maybe_unused)
 {
 	device_unregister(dev);
@@ -508,7 +701,7 @@ int hsi_unregister_port_event(struct hsi_client *cl)
 EXPORT_SYMBOL_GPL(hsi_unregister_port_event);
 
 /**
- * hsi_event -Notifies clients about port events
+ * hsi_event - Notifies clients about port events
  * @port: Port where the event occurred
  * @event: The event type
  *
diff --git a/include/linux/hsi/hsi.h b/include/linux/hsi/hsi.h
index 57ee40f..610c6f9 100644
--- a/include/linux/hsi/hsi.h
+++ b/include/linux/hsi/hsi.h
@@ -298,6 +298,8 @@ int hsi_register_controller(struct hsi_controller *hsi);
 void hsi_unregister_controller(struct hsi_controller *hsi);
 struct hsi_client *hsi_new_client(struct hsi_port *port,
 						struct hsi_board_info *info);
+void hsi_add_clients_from_dt(struct hsi_port *port,
+						struct device_node *clients);
 int hsi_remove_client(struct device *dev, void *data);
 void hsi_port_unregister_clients(struct hsi_port *port);
 
-- 
1.9.0

