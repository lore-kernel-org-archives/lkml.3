Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaLXHMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:12:30 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:40400 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaLXHMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:12:25 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <gregkh@linuxfoundation.org>
CC: <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh@kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 1/3] serial: 8250_early: optimize early 8250 uart
Date: Wed, 24 Dec 2014 12:42:14 +0530
Message-ID: <1419405136-14520-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419405136-14520-1-git-send-email-vgupta@synopsys.com>
References: <1419405136-14520-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In early 8250, IER is already zero so no point in writing this - twice
per char.

This helped improve the SystemC model based ARC OSCI platform

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
---
 drivers/tty/serial/8250/8250_early.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index 4858b8a99d3b..ce2a8abd1f54 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -95,13 +95,16 @@ static void __init early_serial8250_write(struct console *console,
 
 	/* Save the IER and disable interrupts */
 	ier = serial8250_early_in(port, UART_IER);
-	serial8250_early_out(port, UART_IER, 0);
+	if (ier)
+		serial8250_early_out(port, UART_IER, 0);
 
 	uart_console_write(port, s, count, serial_putc);
 
 	/* Wait for transmitter to become empty and restore the IER */
 	wait_for_xmitr(port);
-	serial8250_early_out(port, UART_IER, ier);
+
+	if (ier)
+		serial8250_early_out(port, UART_IER, ier);
 }
 
 static unsigned int __init probe_baud(struct uart_port *port)
-- 
1.8.3.2

