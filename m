Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbbALNp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:45:27 -0500
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:47156 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbbALNpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:45:25 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH v3] tty: serial: msm_serial: code cleanup in msm_console_setup
Date: Mon, 12 Jan 2015 19:15:32 +0530
Message-Id: <1421070332-24420-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change does following:
 - baud, flow, bits, parity were being overwritten as they were
   being reinitialized after parsing.  Initialize them when they are
   declared so that user provided setting are not overwritten.
 - msm_set_baud_rate() is anyway called in uart_set_options when it calls
   msm_set_termios(). msm_reset() is called when we change the baud rate.
   Hence doing away with both of these calls.
 - CR_CMD_PROTECTION_EN and CR_TX_ENABLE settings are done in msm_set_baud_rate.
   So do away with this here.

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Changes since v2:
 - initialize baud, flow, bits, parity when they are declared.
 - undo msm_init_clock removal as suggested by Stephen.
 - Remove unused variable msm_port

Tested on IFC6410.

 drivers/tty/serial/msm_serial.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index c88b522..a0cc6e0 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -920,14 +920,15 @@ static void msm_console_write(struct console *co, const char *s,
 static int __init msm_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port;
-	struct msm_port *msm_port;
-	int baud = 0, flow, bits, parity;
+	int baud = 115200;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
 
 	if (unlikely(co->index >= UART_NR || co->index < 0))
 		return -ENXIO;
 
 	port = get_port_from_line(co->index);
-	msm_port = UART_TO_MSM(port);
 
 	if (unlikely(!port->membase))
 		return -ENXIO;
@@ -937,23 +938,6 @@ static int __init msm_console_setup(struct console *co, char *options)
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 
-	bits = 8;
-	parity = 'n';
-	flow = 'n';
-	msm_write(port, UART_MR2_BITS_PER_CHAR_8 | UART_MR2_STOP_BIT_LEN_ONE,
-		  UART_MR2);	/* 8N1 */
-
-	if (baud < 300 || baud > 115200)
-		baud = 115200;
-	msm_set_baud_rate(port, baud);
-
-	msm_reset(port);
-
-	if (msm_port->is_uartdm) {
-		msm_write(port, UART_CR_CMD_PROTECTION_EN, UART_CR);
-		msm_write(port, UART_CR_TX_ENABLE, UART_CR);
-	}
-
 	pr_info("msm_serial: console setup on port #%d\n", port->line);
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
-- 
1.7.9.5

