Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964802AbaDIPGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:06:43 -0400
Received: from mail.pcs.de ([145.253.69.50]:63615 "EHLO exchange5.pcs.ditec.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933427AbaDIPGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:06:42 -0400
Date: Wed, 9 Apr 2014 17:06:24 +0200
From: Thomas Pfaff <tpfaff@pcs.com>
X-X-Sender: tpfaff@lxtpfaff.pcs.ditec.de
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: fix uart PORT_UNKNOWN handling
In-Reply-To: <20140409133909.2073453a@alan.etchedpixels.co.uk>
Message-ID: <alpine.LNX.2.00.1404091655140.29879@lxtpfaff.pcs.ditec.de>
References: <alpine.LNX.2.00.1404091151430.6519@lxtpfaff.pcs.ditec.de> <20140409133909.2073453a@alan.etchedpixels.co.uk>
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


On Wed, 9 Apr 2014, One Thousand Gnomes wrote:

> On Wed, 9 Apr 2014 13:22:14 +0200
> Thomas Pfaff <tpfaff@pcs.com> wrote:
> 
> > 1. uart_change_pm ist called during uart_open and calls the uart pm function
> >    without checking for PORT_UNKNOWN.
> 
> Removing this breaks other parts of the code assume that the port will be
> powered up (notably setserial paths). So it makes sense that
> uart_change_pm for a "none" port is a no-op but needs logic in the
> setserial path to power up a port when we move none->known and power it
> down on known->none
> 

Then why not move uart_change_pm into uart_port_startup, where it will be called 
when needed ?
A reworked patch is below.

> > 2. uart_shutdown is called from uart_set_info and does not check it either.
> 
> I don't see why this one matters. We would have done
> 
> 	uart_startup
> 		uart_port_startup
> 			uport->type == PORT_UNKNOWN
> 			return 1;
> 		ASYNCB_INITIALIZED is not set
> 
> 	uart_shutdown
> 		ASYNCB_INITIALISED is not set
> 			Skip call to uart_port_shutdown
> 
> So that code looks correct to me.

I agree, i have overlooked this.

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
