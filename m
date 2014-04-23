Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaDWKdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:33:43 -0400
Received: from mail.pcs.de ([145.253.69.50]:7738 "EHLO exchange5.pcs.ditec.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756171AbaDWKdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:33:40 -0400
Date: Wed, 23 Apr 2014 12:33:22 +0200
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <gnomes@lxorguk.ukuu.org.uk>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] serial_core: fix uart PORT_UNKNOWN handling
Message-ID: <alpine.LNX.2.00.1404231135450.4361@lxtpfaff.pcs.ditec.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-GFI-SMTP-Submission: 1
X-GFI-SMTP-Submission: 1
X-GFI-SMTP-HelloDomain: lxtpfaff.pcs.ditec.de
X-GFI-SMTP-RemoteIP: 192.168.9.96
X-KSE-AntiSpam-Interceptor-Info: white sender email list
X-GFIME-MASPAM: SPAM
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Thomas Pfaff" <tpfaff@pcs.com>

While porting a RS485 driver from 2.6.29 to 3.14, i noticed that the serial tty 
driver could break it by using uart ports that it does not own :

1. uart_change_pm ist called during uart_open and calls the uart pm function
   without checking for PORT_UNKNOWN.
   The fix is to move uart_change_pm from uart_open to uart_port_startup.
2. The return code from the uart request_port call in uart_set_info is not
   handled properly, leading to the situation that the serial driver also
   thinks it owns the uart ports.
   This can triggered by doing following actions :

   setserial /dev/ttyS0 uart none    # release the uart ports
   modprobe lirc-serial              # or any other device that uses the uart
   setserial /dev/ttyS0 uart 16550   # gives no error and the uart tty driver
                                     # can use the ports as well

Signed-off-by: Thomas Pfaff <tpfaff@pcs.com>
---
diff -urp linux-3.14.org/drivers/tty/serial/serial_core.c linux-3.14/drivers/tty/serial/serial_core.c
--- linux-3.14.org/drivers/tty/serial/serial_core.c	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.14/drivers/tty/serial/serial_core.c	2014-04-09 16:41:03.940046814 +0200
@@ -138,6 +138,11 @@ static int uart_port_startup(struct tty_
 		return 1;
 
 	/*
+	 * Make sure the device is in D0 state.
+	 */
+	uart_change_pm(state, UART_PM_STATE_ON);
+
+	/*
 	 * Initialise and allocate the transmit and temporary
 	 * buffer.
 	 */
@@ -826,25 +831,29 @@ static int uart_set_info(struct tty_stru
 		 * If we fail to request resources for the
 		 * new port, try to restore the old settings.
 		 */
-		if (retval && old_type != PORT_UNKNOWN) {
+		if (retval) {
 			uport->iobase = old_iobase;
 			uport->type = old_type;
 			uport->hub6 = old_hub6;
 			uport->iotype = old_iotype;
 			uport->regshift = old_shift;
 			uport->mapbase = old_mapbase;
-			retval = uport->ops->request_port(uport);
-			/*
-			 * If we failed to restore the old settings,
-			 * we fail like this.
-			 */
-			if (retval)
-				uport->type = PORT_UNKNOWN;
 
-			/*
-			 * We failed anyway.
-			 */
-			retval = -EBUSY;
+			if (old_type != PORT_UNKNOWN) {
+				retval = uport->ops->request_port(uport);
+				/*
+				 * If we failed to restore the old settings,
+				 * we fail like this.
+				 */
+				if (retval)
+					uport->type = PORT_UNKNOWN;
+
+				/*
+				 * We failed anyway.
+				 */
+				retval = -EBUSY;
+			}
+
 			/* Added to return the correct error -Ram Gupta */
 			goto exit;
 		}
@@ -1570,12 +1579,6 @@ static int uart_open(struct tty_struct *
 	}
 
 	/*
-	 * Make sure the device is in D0 state.
-	 */
-	if (port->count == 1)
-		uart_change_pm(state, UART_PM_STATE_ON);
-
-	/*
 	 * Start up the serial port.
 	 */
 	retval = uart_startup(tty, state, 0);
