Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaA0UQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:16:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaA0UQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:16:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Medhurst <tixy@linaro.org>
Subject: [PATCH 3.13 06/10] serial: amba-pl011: use port lock to guard control register access
Date: Mon, 27 Jan 2014 12:17:09 -0800
Message-Id: <20140127201535.805714682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <20140127201535.350372282@linuxfoundation.org>
References: <20140127201535.350372282@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Medhurst <tixy@linaro.org>

commit fe43390702a1b5741fdf217063b05c7612b38303 upstream.

When the pl011 is being used for a console, pl011_console_write forces
the control register (CR) to enable the UART for transmission and then
restores this to the original value afterwards. It does this while
holding the port lock.

Unfortunately, when the uart is started or shutdown - say in response to
userland using the serial device for a terminal - then this updates the
control register without any locking.

This means we can have

  pl011_console_write   Save CR
  pl011_startup         Initialise CR, e.g. enable receive
  pl011_console_write   Restore old CR with receive not enabled

this result is a serial port which doesn't respond to any input.

A similar race in reverse could happen when the device is shutdown.

We can fix these problems by taking the port lock when updating CR.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1537,6 +1537,8 @@ static int pl011_startup(struct uart_por
 	/*
 	 * Provoke TX FIFO interrupt into asserting.
 	 */
+	spin_lock_irq(&uap->port.lock);
+
 	cr = UART01x_CR_UARTEN | UART011_CR_TXE | UART011_CR_LBE;
 	writew(cr, uap->port.membase + UART011_CR);
 	writew(0, uap->port.membase + UART011_FBRD);
@@ -1561,6 +1563,8 @@ static int pl011_startup(struct uart_por
 	cr |= UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
 
+	spin_unlock_irq(&uap->port.lock);
+
 	/*
 	 * initialise the old status of the modem signals
 	 */
@@ -1629,11 +1633,13 @@ static void pl011_shutdown(struct uart_p
 	 * it during startup().
 	 */
 	uap->autorts = false;
+	spin_lock_irq(&uap->port.lock);
 	cr = readw(uap->port.membase + UART011_CR);
 	uap->old_cr = cr;
 	cr &= UART011_CR_RTS | UART011_CR_DTR;
 	cr |= UART01x_CR_UARTEN | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
+	spin_unlock_irq(&uap->port.lock);
 
 	/*
 	 * disable break condition and fifos


