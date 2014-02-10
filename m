Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBJCUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:20:55 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39610 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaBJCUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:36 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 02/24] Revert "Bluetooth: Always wait for a connection on RFCOMM open()"
Date: Sun,  9 Feb 2014 20:59:02 -0500
Message-Id: <1391997564-1805-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 4a2fb3ecc7467c775b154813861f25a0ddc11aa0.

This is the second of a 3-patch revert, together with
Revert "Bluetooth: Remove rfcomm_carrier_raised()" and
Revert "Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()".

Before commit cad348a17e170451ea8688b532a6ca3e98c63b60,
  Bluetooth: Implement .activate, .shutdown and .carrier_raised methods,
tty_port_block_til_ready() was open-coded in rfcomm_tty_install() as
part of the RFCOMM tty open().

Unfortunately, it did not implement non-blocking open nor CLOCAL open,
but rather always blocked for carrier. This is not the expected or
typical behavior for ttys, and prevents several common terminal
programming idioms from working (eg., opening in non-blocking
mode to initialize desired termios settings then re-opening for
connection).

Commit cad348a17e170451ea8688b532a6ca3e98c63b60,
  Bluetooth: Implement .activate, .shutdown and .carrier_raised methods,
added the necessary tty_port methods to use the default tty_port_open().
However, this triggered two important user-space regressions.

The first regression involves the complicated mechanism for reparenting
the rfcomm tty device to the ACL link device which represents an
open link to a specific bluetooth host. This regression causes ModemManager
to conclude the rfcomm tty device does not front a modem so it makes
no attempt to initialize an attached modem. This regression is
caused by the lack of a device_move() if the dlc is already open (and
not specifically related to the open-coded block_til_ready()).

A more appropriate solution is submitted in
"Bluetooth: Fix unsafe RFCOMM device parenting" and
"Bluetooth: Fix RFCOMM parent device for reused dlc"

The second regression involves "rfcomm bind" and wvdial (a ppp dialer).
rfcomm bind creates a device node for a /dev/rfcomm<n>. wvdial opens
that device in non-blocking mode (because it expects the connection
to have already been established). In addition, subsequent writes
to the rfcomm tty device fail (because the link is not yet connected;
rfcomm connection begins with the actual tty open()).

However, restoring the original behavior (in the patch which
this reverts) was undesirable.

Firstly, the original reporter notes that a trivial userspace
"workaround" already exists: rfcomm connect, which creates the
device node and establishes the expected connection.

Secondly, the failed writes occur because the rfcomm tty driver
does not buffer writes to an unconnected device; this contrasts with
the dozen of other tty drivers (in fact, all of them) that do just
that. The submitted patch "Bluetooth: Don't fail RFCOMM tty writes"
corrects this.

Thirdly, it was a long-standing bug to block on non-blocking open,
which is re-fixed by revert.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 46 ++++++++--------------------------------------
 1 file changed, 8 insertions(+), 38 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index aeabade..32ef9f9 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -58,7 +58,6 @@ struct rfcomm_dev {
 	uint			modem_status;
 
 	struct rfcomm_dlc	*dlc;
-	wait_queue_head_t       conn_wait;
 
 	struct device		*tty_dev;
 
@@ -124,40 +123,8 @@ static struct device *rfcomm_get_device(struct rfcomm_dev *dev)
 static int rfcomm_dev_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
-	DEFINE_WAIT(wait);
-	int err;
-
-	err = rfcomm_dlc_open(dev->dlc, &dev->src, &dev->dst, dev->channel);
-	if (err)
-		return err;
-
-	while (1) {
-		prepare_to_wait(&dev->conn_wait, &wait, TASK_INTERRUPTIBLE);
 
-		if (dev->dlc->state == BT_CLOSED) {
-			err = -dev->err;
-			break;
-		}
-
-		if (dev->dlc->state == BT_CONNECTED)
-			break;
-
-		if (signal_pending(current)) {
-			err = -ERESTARTSYS;
-			break;
-		}
-
-		tty_unlock(tty);
-		schedule();
-		tty_lock(tty);
-	}
-	finish_wait(&dev->conn_wait, &wait);
-
-	if (!err)
-		device_move(dev->tty_dev, rfcomm_get_device(dev),
-			    DPM_ORDER_DEV_AFTER_PARENT);
-
-	return err;
+	return rfcomm_dlc_open(dev->dlc, &dev->src, &dev->dst, dev->channel);
 }
 
 /* we block the open until the dlc->state becomes BT_CONNECTED */
@@ -184,6 +151,7 @@ static const struct tty_port_operations rfcomm_port_ops = {
 	.destruct = rfcomm_dev_destruct,
 	.activate = rfcomm_dev_activate,
 	.shutdown = rfcomm_dev_shutdown,
+	.carrier_raised = rfcomm_dev_carrier_raised,
 };
 
 static struct rfcomm_dev *__rfcomm_dev_get(int id)
@@ -290,7 +258,6 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 
 	tty_port_init(&dev->port);
 	dev->port.ops = &rfcomm_port_ops;
-	init_waitqueue_head(&dev->conn_wait);
 
 	skb_queue_head_init(&dev->pending);
 
@@ -609,9 +576,12 @@ static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err)
 	BT_DBG("dlc %p dev %p err %d", dlc, dev, err);
 
 	dev->err = err;
-	wake_up_interruptible(&dev->conn_wait);
+	if (dlc->state == BT_CONNECTED) {
+		device_move(dev->tty_dev, rfcomm_get_device(dev),
+			    DPM_ORDER_DEV_AFTER_PARENT);
 
-	if (dlc->state == BT_CLOSED)
+		wake_up_interruptible(&dev->port.open_wait);
+	} else if (dlc->state == BT_CLOSED)
 		tty_port_tty_hangup(&dev->port, false);
 }
 
@@ -1133,7 +1103,7 @@ int __init rfcomm_init_ttys(void)
 	rfcomm_tty_driver->subtype	= SERIAL_TYPE_NORMAL;
 	rfcomm_tty_driver->flags	= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	rfcomm_tty_driver->init_termios	= tty_std_termios;
-	rfcomm_tty_driver->init_termios.c_cflag	= B9600 | CS8 | CREAD | HUPCL | CLOCAL;
+	rfcomm_tty_driver->init_termios.c_cflag	= B9600 | CS8 | CREAD | HUPCL;
 	rfcomm_tty_driver->init_termios.c_lflag &= ~ICANON;
 	tty_set_operations(rfcomm_tty_driver, &rfcomm_ops);
 
-- 
1.8.1.2

