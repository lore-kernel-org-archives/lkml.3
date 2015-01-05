Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbbAELbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:31:12 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:34521 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAELbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:31:09 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <robh@kernel.org>, <jslaby@suse.cz>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 2/3] serial: 8250_early: prepare for dynamic BASE_BAUD
Date: Mon, 5 Jan 2015 17:00:36 +0530
Message-ID: <1420457437-17636-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420457437-17636-1-git-send-email-vgupta@synopsys.com>
References: <1420457437-17636-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BASE_BAUD is pain in neck for multi-platform support as it hard codes at
build time the clk value for early uart.

Mitigate this by allowing arches/platforms to provide their own version
which can do dynamic setup based on DT values etc (see next patch for
usage)

This was needed for ARC SDP platforms based on 2 different FPGA flows, each
with a different UART clk value.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/tty/serial/earlycon.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index 64fe25a4285c..bfd3537739e0 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -54,6 +54,15 @@ static void __iomem * __init earlycon_map(unsigned long paddr, size_t size)
 	return base;
 }
 
+unsigned int __weak __init earlycon_base_baud(char *options)
+{
+#ifdef BASE_BAUD
+	return BASE_BAUD;
+#else
+	return 1843200/16;	/* x86 early console */
+#endif
+}
+
 static int __init parse_options(struct earlycon_device *device,
 				char *options)
 {
@@ -87,7 +96,7 @@ static int __init parse_options(struct earlycon_device *device,
 		return -EINVAL;
 	}
 
-	port->uartclk = BASE_BAUD * 16;
+	port->uartclk = earlycon_base_baud(options) * 16;
 
 	options = strchr(options, ',');
 	if (options) {
@@ -156,7 +165,7 @@ int __init of_setup_earlycon(unsigned long addr,
 
 	port->iotype = UPIO_MEM;
 	port->mapbase = addr;
-	port->uartclk = BASE_BAUD * 16;
+	port->uartclk = earlycon_base_baud(NULL) * 16;
 	port->membase = earlycon_map(addr, SZ_4K);
 
 	early_console_dev.con->data = &early_console_dev;
-- 
1.9.1

