Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaFLKdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:33:07 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:51857 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaFLKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:33:03 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 4/9] serial/arc: Use generic earlycon infrastructure
Date: Thu, 12 Jun 2014 16:01:34 +0530
Message-ID: <1402569099-9900-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change both earlyprintk and earlycon coexist
We switch over to latter in next patch

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/tty/serial/Kconfig    |  1 +
 drivers/tty/serial/arc_uart.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index fb57159bad3a..2311443be7dc 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1473,6 +1473,7 @@ config SERIAL_ARC_CONSOLE
 	bool "Console on ARC UART"
 	depends on SERIAL_ARC=y
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 	help
 	  Enable system Console on ARC UART
 
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index a6da10f84293..0c8ba5bb97c7 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -646,6 +646,36 @@ static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
 	register_console(&arc_early_serial_console);
 	return 0;
 }
+
+static __init void arc_early_serial_write(struct console *con, const char *s,
+					  unsigned int n)
+{
+	struct earlycon_device *dev = con->data;
+
+	uart_console_write(&dev->port, s, n, arc_serial_poll_putchar);
+}
+
+static int __init arc_early_console_setup(struct earlycon_device *dev,
+					  const char *opt)
+{
+	struct uart_port *port = &dev->port;
+	unsigned int l, h, hw_val;
+
+	if (!dev->port.membase)
+		return -ENODEV;
+
+	hw_val = port->uartclk / (dev->baud * 4) - 1;
+	l = hw_val & 0xFF;
+	h = (hw_val >> 8) & 0xFF;
+
+	UART_SET_BAUDL(port, l);
+	UART_SET_BAUDH(port, h);
+
+	dev->con->write = arc_early_serial_write;
+	return 0;
+}
+EARLYCON_DECLARE(arc_uart, arc_early_console_setup);
+
 #endif	/* CONFIG_SERIAL_ARC_CONSOLE */
 
 static int arc_serial_probe(struct platform_device *pdev)
-- 
1.8.3.2

