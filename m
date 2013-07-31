Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3GaNja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:39:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46878 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759683Ab3GaNZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johan Hovold" <jhovold@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.720798838@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [83/84] USB: mos7840: fix memory leak in open
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5f8a2e68b679b41cc8e9b642f2f5aa45dd678641 upstream.

Allocated urbs and buffers were never freed on errors in open.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/mos7840.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -925,20 +925,20 @@ static int mos7840_open(struct tty_struc
 	status = mos7840_get_reg_sync(port, mos7840_port->SpRegOffset, &Data);
 	if (status < 0) {
 		dbg("Reading Spreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 
 	Data &= ~0x80;
 	status = mos7840_set_reg_sync(port, mos7840_port->SpRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Spreg failed");
-		return -1;
+		goto err;
 	}
 	/* End of block to be checked */
 
@@ -947,7 +947,7 @@ static int mos7840_open(struct tty_struc
 									&Data);
 	if (status < 0) {
 		dbg("Reading Controlreg failed");
-		return -1;
+		goto err;
 	}
 	Data |= 0x08;		/* Driver done bit */
 	Data |= 0x20;		/* rx_disable */
@@ -955,7 +955,7 @@ static int mos7840_open(struct tty_struc
 				mos7840_port->ControlRegOffset, Data);
 	if (status < 0) {
 		dbg("writing Controlreg failed");
-		return -1;
+		goto err;
 	}
 	/* do register settings here */
 	/* Set all regs to the device default values. */
@@ -966,21 +966,21 @@ static int mos7840_open(struct tty_struc
 	status = mos7840_set_uart_reg(port, INTERRUPT_ENABLE_REGISTER, Data);
 	if (status < 0) {
 		dbg("disabling interrupts failed");
-		return -1;
+		goto err;
 	}
 	/* Set FIFO_CONTROL_REGISTER to the default value */
 	Data = 0x00;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0xcf;
 	status = mos7840_set_uart_reg(port, FIFO_CONTROL_REGISTER, Data);
 	if (status < 0) {
 		dbg("Writing FIFO_CONTROL_REGISTER  failed");
-		return -1;
+		goto err;
 	}
 
 	Data = 0x03;
@@ -1136,7 +1136,15 @@ static int mos7840_open(struct tty_struc
 	dbg ("%s leave", __func__);
 
 	return 0;
-
+err:
+	for (j = 0; j < NUM_URBS; ++j) {
+		urb = mos7840_port->write_urb_pool[j];
+		if (!urb)
+			continue;
+		kfree(urb->transfer_buffer);
+		usb_free_urb(urb);
+	}
+	return status;
 }
 
 /*****************************************************************************

