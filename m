Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaELIfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:35:12 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:13734 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685AbaELIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:35:10 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-11.tower-194.messagelabs.com!1399883707!11077877!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 12 May 2014 10:35:07 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] tty: serial: men_z135_uart: Don't activate TX Space available IRQ on startup
Date: Mon, 12 May 2014 10:34:59 +0200
Message-ID: <1399883699-8925-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't activate the TX Space available IRQ on startup, or a simple
$ cat /dev/ttyHSU0
will cause an endless amount of IRQs, as there is always space in
the TX FIFO available if no data is going to be sent.

Also correct comments for IRQ names (RX and TX swapped).

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/tty/serial/men_z135_uart.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/men_z135_uart.c b/drivers/tty/serial/men_z135_uart.c
index d08eb5d..c9d1854 100644
--- a/drivers/tty/serial/men_z135_uart.c
+++ b/drivers/tty/serial/men_z135_uart.c
@@ -41,8 +41,8 @@
 #define IS_IRQ(x) ((x) & 1)
 #define IRQ_ID(x) (((x) >> 1) & 7)

-#define MEN_Z135_IER_RXCIEN BIT(0)		/* TX Space IRQ */
-#define MEN_Z135_IER_TXCIEN BIT(1)		/* RX Space IRQ */
+#define MEN_Z135_IER_RXCIEN BIT(0)		/* RX Space IRQ */
+#define MEN_Z135_IER_TXCIEN BIT(1)		/* TX Space IRQ */
 #define MEN_Z135_IER_RLSIEN BIT(2)		/* Receiver Line Status IRQ */
 #define MEN_Z135_IER_MSIEN  BIT(3)		/* Modem Status IRQ */
 #define MEN_Z135_ALL_IRQS (MEN_Z135_IER_RXCIEN		\
@@ -576,7 +576,8 @@ static int men_z135_startup(struct uart_port *port)

 	conf_reg = ioread32(port->membase + MEN_Z135_CONF_REG);

-	conf_reg |= MEN_Z135_ALL_IRQS;
+	/* Activate all but TX space available IRQ */
+	conf_reg |= MEN_Z135_ALL_IRQS & ~MEN_Z135_IER_TXCIEN;
 	conf_reg &= ~(0xff << 16);
 	conf_reg |= (txlvl << 16);
 	conf_reg |= (rxlvl << 20);
--
1.9.2

