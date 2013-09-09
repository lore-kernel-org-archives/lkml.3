Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3IIQIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:08:51 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:50658 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3IIQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:08:48 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 2/5] USB : serial : get protected tty in handle_dcd_change.
Date: Mon,  9 Sep 2013 18:01:17 +0200
Message-Id: <1378742480-2146-3-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Mon, 09 Sep 2013 18:08:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch depends on 72df17e... (PATCH 1). It restores the retreiving
of a protected instance of tty.  As opposed to the serialcore.c
dcd_change implementation, the callers of dcd_change used to
get protected tty instance.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/usb/serial/generic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 33f1df1..91f0592 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -566,7 +566,7 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
 				unsigned int status)
 {
 	struct tty_port *port = &usb_port->port;
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = tty_port_tty_get(port);
 
 	dev_dbg(&usb_port->dev, "%s - status %d\n", __func__, status);
 
@@ -574,6 +574,8 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
 		wake_up_interruptible(&port->open_wait);
 	else if (tty && !C_CLOCAL(tty))
 		tty_hangup(tty);
+
+	tty_kref_put(tty);
 }
 EXPORT_SYMBOL_GPL(usb_serial_handle_dcd_change);
 
-- 
1.7.12.1

