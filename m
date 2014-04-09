Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbaDIL2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:28:01 -0400
Received: from mail.pcs.de ([145.253.69.50]:51049 "EHLO exchange5.pcs.ditec.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932786AbaDIL16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:27:58 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2014 07:27:57 EDT
Date: Wed, 9 Apr 2014 13:22:14 +0200
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial_core: fix uart PORT_UNKNOWN handling
Message-ID: <alpine.LNX.2.00.1404091151430.6519@lxtpfaff.pcs.ditec.de>
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
2. uart_shutdown is called from uart_set_info and does not check it either.
3. The return code from the uart request_port call in uart_set_info is not
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
+++ linux-3.14/drivers/tty/serial/serial_core.c	2014-04-08 16:51:28.176459065 +0200
@@ -225,6 +225,9 @@ static void uart_shutdown(struct tty_str
 	struct uart_port *uport = state->uart_port;
 	struct tty_port *port = &state->port;
 
+	if (uport->type == PORT_UNKNOWN)
+		return;
+
 	/*
 	 * Set the TTY IO error marker
 	 */
@@ -826,25 +829,29 @@ static int uart_set_info(struct tty_stru
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
@@ -1900,6 +1907,9 @@ static void uart_change_pm(struct uart_s
 {
 	struct uart_port *port = state->uart_port;
 
+	if (port->type == PORT_UNKNOWN)
+		return;
+
 	if (state->pm_state != pm_state) {
 		if (port->ops->pm)
 			port->ops->pm(port, pm_state, state->pm_state);
