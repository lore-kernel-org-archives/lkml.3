Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3BKImu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:42:50 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:57869 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3BKIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:42:48 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        <linux-serial@vger.kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial/arc-uart: Miscll DT related updates (Grant's review comments)
Date: Mon, 11 Feb 2013 14:11:41 +0530
Message-ID: <1360572101-12744-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1360572101-12744-1-git-send-email-vgupta@synopsys.com>
References: <201302090928.43929.arnd@arndb.de>
 <1360572101-12744-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-replace "baud" with "current-speed"
-if uart alias doesn't exist in DT, don't abort, pick 0

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/tty/serial/arc-uart.txt    |    4 ++--
 drivers/tty/serial/arc_uart.c                      |   10 ++++------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/tty/serial/arc-uart.txt b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
index c3bd8f9..5cae2eb 100644
--- a/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
+++ b/Documentation/devicetree/bindings/tty/serial/arc-uart.txt
@@ -5,7 +5,7 @@ Required properties:
 - reg			: offset and length of the register set for the device.
 - interrupts		: device interrupt
 - clock-frequency	: the input clock frequency for the UART
-- baud			: baud rate for UART
+- current-speed		: baud rate for UART
 
 e.g.
 
@@ -14,7 +14,7 @@ arcuart0: serial@c0fc1000 {
 	reg = <0xc0fc1000 0x100>;
 	interrupts = <5>;
 	clock-frequency = <80000000>;
-	baud = <115200>;
+	current-speed = <115200>;
 	status = "okay";
 };
 
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 6f7eadc..d97e194 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -547,8 +547,8 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 		}
 		uart->port.uartclk = val;
 
-		if (of_property_read_u32(np, "baud", &val)) {
-			dev_err(&pdev->dev, "baud property NOT set\n");
+		if (of_property_read_u32(np, "current-speed", &val)) {
+			dev_err(&pdev->dev, "current-speed property NOT set\n");
 			return -EINVAL;
 		}
 		uart->baud = val;
@@ -694,10 +694,8 @@ static int arc_serial_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	dev_id = of_alias_get_id(np, "serial");
-	if (dev_id < 0) {
-		dev_err(&pdev->dev, "failed to get alias id: %d\n", dev_id);
-		return dev_id;
-	}
+	if (dev_id < 0)
+		dev_id = 0;
 
 	rc = arc_uart_init_one(pdev, dev_id);
 	if (rc)
-- 
1.7.4.1

