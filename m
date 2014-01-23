Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaAWTNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:13:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaAWTGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Medhurst <tixy@linaro.org>
Subject: [PATCH 3.12 24/27] serial: amba-pl011: use port lock to guard control register access
Date: Thu, 23 Jan 2014 11:07:01 -0800
Message-Id: <20140123190651.185399000@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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


