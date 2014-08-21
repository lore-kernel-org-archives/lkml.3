Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaHUG5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:57:33 -0400
Received: from mail1.skidata.com ([91.230.2.99]:2239 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaHUG5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:57:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqkEACCX9VOsEApK/2dsb2JhbABag2BXBLY/lXqHYQGBJHeEBAEFJxM/EBgUJQ9IBg4FiEfBcBePTAeETAEEhhGMD4MrhniBWIV/kRNqgUiBBwEBAQ
X-IPAS-Result: AqkEACCX9VOsEApK/2dsb2JhbABag2BXBLY/lXqHYQGBJHeEBAEFJxM/EBgUJQ9IBg4FiEfBcBePTAeETAEEhhGMD4MrhniBWIV/kRNqgUiBBwEBAQ
Date: Thu, 21 Aug 2014 08:57:28 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: <balbi@ti.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: gadget: serial: remove PREFIX macro
Message-ID: <20140821085728.74ddc10f@lxbuild.skidata.net>
In-Reply-To: <53F4CF2E.2070605@cogentembedded.com>
References: <20140718113946.0e70c0cb@lxbuild.skidata.net>
	<20140820155417.GD24500@saruman.home>
	<53F4CF2E.2070605@cogentembedded.com>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the ttyGS PREFIX macro from u_serial.c and replace all occurences with
the hardcoded ttyGS string.

This macro was mostly used in a few debug/warning messages and a lot of
hardcoded ttyGS existed beneath. It may have been used for renaming the
tty, but if done so most debug messages would have ignored this.

Due to the fact the usage of this PREFIX in all debug calls would have
resulted in a hard to read/grep code it is removed completely.

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
---
changes from RFC to PATCH:
	- rebased on v3.17-rc1
	- fixed some PARENTHESIS_ALIGNMENT checkpatch.pl warnings
---
 drivers/usb/gadget/function/u_serial.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index ad0aca8..491082a 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -55,11 +55,8 @@
  * for a telephone or fax link.  And ttyGS2 might be something that just
  * needs a simple byte stream interface for some messaging protocol that
  * is managed in userspace ... OBEX, PTP, and MTP have been mentioned.
- */
-
-#define PREFIX	"ttyGS"
-
-/*
+ *
+ *
  * gserial is the lifecycle interface, used by USB functions
  * gs_port is the I/O nexus, used by the tty driver
  * tty_struct links to the tty/filesystem framework
@@ -385,9 +382,9 @@ __acquires(&port->port_lock)
 		list_del(&req->list);
 		req->zero = (gs_buf_data_avail(&port->port_write_buf) == 0);
 
-		pr_vdebug(PREFIX "%d: tx len=%d, 0x%02x 0x%02x 0x%02x ...\n",
-				port->port_num, len, *((u8 *)req->buf),
-				*((u8 *)req->buf+1), *((u8 *)req->buf+2));
+		pr_vdebug("ttyGS%d: tx len=%d, 0x%02x 0x%02x 0x%02x ...\n",
+			  port->port_num, len, *((u8 *)req->buf),
+			  *((u8 *)req->buf+1), *((u8 *)req->buf+2));
 
 		/* Drop lock while we call out of driver; completions
 		 * could be issued while we do so.  Disconnection may
@@ -503,13 +500,13 @@ static void gs_rx_push(unsigned long _port)
 		switch (req->status) {
 		case -ESHUTDOWN:
 			disconnect = true;
-			pr_vdebug(PREFIX "%d: shutdown\n", port->port_num);
+			pr_vdebug("ttyGS%d: shutdown\n", port->port_num);
 			break;
 
 		default:
 			/* presumably a transient fault */
-			pr_warning(PREFIX "%d: unexpected RX status %d\n",
-					port->port_num, req->status);
+			pr_warn("ttyGS%d: unexpected RX status %d\n",
+				port->port_num, req->status);
 			/* FALLTHROUGH */
 		case 0:
 			/* normal completion */
@@ -537,9 +534,8 @@ static void gs_rx_push(unsigned long _port)
 			if (count != size) {
 				/* stop pushing; TTY layer can't handle more */
 				port->n_read += count;
-				pr_vdebug(PREFIX "%d: rx block %d/%d\n",
-						port->port_num,
-						count, req->actual);
+				pr_vdebug("ttyGS%d: rx block %d/%d\n",
+					  port->port_num, count, req->actual);
 				break;
 			}
 			port->n_read = 0;
@@ -569,7 +565,7 @@ static void gs_rx_push(unsigned long _port)
 			if (do_push)
 				tasklet_schedule(&port->push);
 			else
-				pr_warning(PREFIX "%d: RX not scheduled?\n",
+				pr_warn("ttyGS%d: RX not scheduled?\n",
 					port->port_num);
 		}
 	}
@@ -985,7 +981,7 @@ static void gs_unthrottle(struct tty_struct *tty)
 		 * read queue backs up enough we'll be NAKing OUT packets.
 		 */
 		tasklet_schedule(&port->push);
-		pr_vdebug(PREFIX "%d: unthrottle\n", port->port_num);
+		pr_vdebug("ttyGS%d: unthrottle\n", port->port_num);
 	}
 	spin_unlock_irqrestore(&port->port_lock, flags);
 }
@@ -1295,7 +1291,7 @@ static int userial_init(void)
 		return -ENOMEM;
 
 	gs_tty_driver->driver_name = "g_serial";
-	gs_tty_driver->name = PREFIX;
+	gs_tty_driver->name = "ttyGS";
 	/* uses dynamically assigned dev_t values */
 
 	gs_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
-- 
1.7.10.4
