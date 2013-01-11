Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3AKGWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:22:00 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:60851 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab3AKGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:21:58 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH 4/4] serial/arc-uart: switch to devicetree based probing
Date: Fri, 11 Jan 2013 11:50:23 +0530
Message-ID: <1357885223-19243-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* DT binding for arc-uart
* With alll the bits in place we can now use DT probing.

Note that there's a bit of kludge right now because earlyprintk portion
of driver can't use the DT infrastrcuture to get resoures/plat_data.
This requires some infrastructre changes to of_flat_ framework

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: linux-serial@vger.kernel.org
---
 .../devicetree/bindings/tty/serial/arc-uart.txt    |   26 ++++++++++++
 drivers/tty/serial/arc_uart.c                      |   43 ++++++++++++++++++-
 2 files changed, 66 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/arc-uart.txt

diff --git a/Documentation/devicetree/bindings/tty/serial/arc-uart.txt b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
new file mode 100644
index 0000000..c3bd8f9
--- /dev/null
+++ b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
@@ -0,0 +1,26 @@
+* Synopsys ARC UART : Non standard UART used in some of the ARC FPGA boards
+
+Required properties:
+- compatible		: "snps,arc-uart"
+- reg			: offset and length of the register set for the device.
+- interrupts		: device interrupt
+- clock-frequency	: the input clock frequency for the UART
+- baud			: baud rate for UART
+
+e.g.
+
+arcuart0: serial@c0fc1000 {
+	compatible = "snps,arc-uart";
+	reg = <0xc0fc1000 0x100>;
+	interrupts = <5>;
+	clock-frequency = <80000000>;
+	baud = <115200>;
+	status = "okay";
+};
+
+Note: Each port should have an alias correctly numbered in "aliases" node.
+
+e.g.
+aliases {
+	serial0 = &arcuart0;
+};
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 2db6410..b468601 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -37,6 +37,8 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 
 /*************************************
  * ARC UART Hardware Specs
@@ -537,8 +539,26 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 		return -ENODEV;
 
 	uart->is_emulated = !!plat_data[0];	/* workaround ISS bug */
-	uart->port.uartclk = plat_data[1];
-	uart->baud = plat_data[2];
+
+	if (is_early_platform_device(pdev)) {
+		uart->port.uartclk = plat_data[1];
+		uart->baud = plat_data[2];
+	} else {
+		struct device_node *np = pdev->dev.of_node;
+		u32 val;
+
+		if (of_property_read_u32(np, "clock-frequency", &val)) {
+			dev_err(&pdev->dev, "clock-frequency property NOTset\n");
+			return -EINVAL;
+		}
+		uart->port.uartclk = val;
+
+		if (of_property_read_u32(np, "baud", &val)) {
+			dev_err(&pdev->dev, "baud property NOT set\n");
+			return -EINVAL;
+		}
+		uart->baud = val;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -673,8 +693,18 @@ static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
 static int arc_serial_probe(struct platform_device *pdev)
 {
 	int rc, dev_id;
+	struct device_node *np = pdev->dev.of_node;
+
+	/* no device tree device */
+	if (!np)
+		return -ENODEV;
+
+	dev_id = of_alias_get_id(np, "serial");
+	if (dev_id < 0) {
+		dev_err(&pdev->dev, "failed to get alias id: %d\n", dev_id);
+		return dev_id;
+	}
 
-	dev_id = pdev->id < 0 ? 0 : pdev->id;
 	rc = arc_uart_init_one(pdev, dev_id);
 	if (rc)
 		return rc;
@@ -689,12 +719,19 @@ static int arc_serial_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id arc_uart_dt_ids[] = {
+	{ .compatible = "snps,arc-uart" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, arc_uart_dt_ids);
+
 static struct platform_driver arc_platform_driver = {
 	.probe = arc_serial_probe,
 	.remove = arc_serial_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table  = arc_uart_dt_ids,
 	 },
 };
 
-- 
1.7.4.1

