Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbbAHJPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:15:46 -0500
Received: from smtp121.ord1c.emailsrvr.com ([108.166.43.121]:45785 "EHLO
	smtp121.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbbAHJPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:15:43 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [PATCH v2] tty: serial: msm_serial: Remove duplicate code in msm_console_setup
Date: Thu,  8 Jan 2015 14:45:45 +0530
Message-Id: <1420708545-6477-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes done here are already being done somewhere else in code.
 - The function msm_init_clock() is also called while doing msm_startup
   hence removing.
 - msm_set_baud_rate() is anyway called in uart_set_options when it calls
   msm_set_termios(). msm_reset() is called when we change the baud rate.
   Hence doing away with both of these calls.
 - CR_CMD_PROTECTION_EN and CR_TX_ENABLE settings are done in msm_set_baud_rate.
   So do away with this here.

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Changes since v1:
 - v1 was just removing call to msm_set_baud_rate(). Other code is removed on review
   comments from Stephen Boyd here [1].
 - Removed call to msm_init_clock() as it is called while doing msm_startup

Tested on ifc6410 console.

[1]: https://patchwork.kernel.org/patch/5527551/

 drivers/tty/serial/msm_serial.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index c88b522..057008d 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -932,27 +932,12 @@ static int __init msm_console_setup(struct console *co, char *options)
 	if (unlikely(!port->membase))
 		return -ENXIO;
 
-	msm_init_clock(port);
-
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
 
 	bits = 8;
 	parity = 'n';
 	flow = 'n';
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
 
 	pr_info("msm_serial: console setup on port #%d\n", port->line);
 
-- 
1.7.9.5

