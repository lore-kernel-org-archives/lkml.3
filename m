Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaFXI0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:26:25 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:53682 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaFXI0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:26:19 -0400
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
Subject: [PATCH v2 REBASED 03/10] serial/arc: Remove the workaround for legacy ISS
Date: Tue, 24 Jun 2014 13:55:08 +0530
Message-ID: <1403598315-1429-4-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
References: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 drivers/tty/serial/arc_uart.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 4d971281e3d9..a6da10f84293 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -102,7 +102,6 @@
 struct arc_uart_port {
 	struct uart_port port;
 	unsigned long baud;
-	int is_emulated;	/* H/w vs. Instruction Set Simulator */
 };
 
 #define to_arc_port(uport)  container_of(uport, struct arc_uart_port, port)
@@ -387,17 +386,6 @@ arc_serial_set_termios(struct uart_port *port, struct ktermios *new,
 	uartl = hw_val & 0xFF;
 	uarth = (hw_val >> 8) & 0xFF;
 
-	/*
-	 * UART ISS(Instruction Set simulator) emulation has a subtle bug:
-	 * A existing value of Baudh = 0 is used as a indication to startup
-	 * it's internal state machine.
-	 * Thus if baudh is set to 0, 2 times, it chokes.
-	 * This happens with BAUD=115200 and the formaula above
-	 * Until that is fixed, when running on ISS, we will set baudh to !0
-	 */
-	if (uart->is_emulated)
-		uarth = 1;
-
 	spin_lock_irqsave(&port->lock, flags);
 
 	UART_ALL_IRQ_DISABLE(port);
@@ -520,8 +508,6 @@ arc_uart_init_one(struct platform_device *pdev, int dev_id)
 	if (!plat_data)
 		return -ENODEV;
 
-	uart->is_emulated = !!plat_data[0];	/* workaround ISS bug */
-
 	if (is_early_platform_device(pdev)) {
 		port->uartclk = plat_data[1];
 		uart->baud = plat_data[2];
-- 
1.8.3.2

