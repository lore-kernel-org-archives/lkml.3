Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3CAFz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:55:29 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34766 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAFz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:55:27 -0500
Date: Fri, 1 Mar 2013 13:56:10 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: swarren@wwwdotorg.org, jslaby@suse.cz, alan@linux.intel.com, arnd@arndb.de,
        paul.gortmaker@windriver.com, damm@opensource.se,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]serial: 8250: Fix detect XScale port wrong
Message-ID: <20130301055610.GA31770@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, swarren@wwwdotorg.org, jslaby@suse.cz,
	alan@linux.intel.com, arnd@arndb.de, paul.gortmaker@windriver.com,
	damm@opensource.se, linux-serial@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some UARTs add enhanced functions with unused bit in
16550 standard, like UART_IER_UUE bit, it cause XScale
detect wrong. Now detect UART_IER_UUE and UART_IER_RTOIE
to reduce the annoying wrong result which cause UARTs don't
work.

Serial controller: Device 4348:3253(CH352 PCI based Multi-I/O Controller)
is a example. It use UART_IER_UUE as the LOWPOWER function,
you can get the datasheet from below urls:

http://wch-ic.com/download/list.asp?id=116
CH352DS1.PDF

http://wch-ic.com/download/list.asp?id=117
CH352DS2.PDF.

I choice UART_IER_RTOIE as another test bit, because
choice it is harmless for current code, we will set
UART_CAP_RTOIE if it is XScale port.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/serial/8250/8250.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 0efc815..2c1f9c9 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -841,6 +841,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 {
 	unsigned char status1, status2;
 	unsigned int iersave;
+	unsigned int iertest;
 
 	up->port.type = PORT_16550A;
 	up->capabilities |= UART_CAP_FIFO;
@@ -966,16 +967,25 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * We're going to explicitly set the UUE bit to 0 before
 	 * trying to write and read a 1 just to make sure it's not
 	 * already a 1 and maybe locked there before we even start start.
+	 *
+	 * 01/03/2013
+	 * Some UARTs add enhanced functions with unused bit in
+	 * 16550 standard, like UART_IER_UUE bit, it cause XScale
+	 * detect wrong. Now detect UART_IER_UUE and UART_IER_RTOIE
+	 * to reduce the annoying wrong result which cause UART don't
+	 * work.
 	 */
 	iersave = serial_in(up, UART_IER);
-	serial_out(up, UART_IER, iersave & ~UART_IER_UUE);
-	if (!(serial_in(up, UART_IER) & UART_IER_UUE)) {
+	iertest = UART_IER_UUE | UART_IER_RTOIE;
+
+	serial_out(up, UART_IER, iersave & ~iertest);
+	if (!(serial_in(up, UART_IER) & iertest)) {
 		/*
 		 * OK it's in a known zero state, try writing and reading
 		 * without disturbing the current state of the other bits.
 		 */
-		serial_out(up, UART_IER, iersave | UART_IER_UUE);
-		if (serial_in(up, UART_IER) & UART_IER_UUE) {
+		serial_out(up, UART_IER, iersave | iertest);
+		if ((serial_in(up, UART_IER) & iertest) == iertest) {
 			/*
 			 * It's an Xscale.
 			 * We'll leave the UART_IER_UUE bit set to 1 (enabled).
-- 
1.7.11.1.116.g8228a23
