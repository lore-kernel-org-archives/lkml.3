Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3IIQIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:08:53 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:50671 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3IIQIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:08:51 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 4/5] USB : serial : invoke dcd_change ldisc's handler.
Date: Mon,  9 Sep 2013 18:01:19 +0200
Message-Id: <1378742480-2146-5-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Mon, 09 Sep 2013 18:08:27 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to have the PPS line discipline to work with usb devices.

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 drivers/usb/serial/generic.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 91f0592..a18a086 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -567,6 +567,13 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
 {
 	struct tty_port *port = &usb_port->port;
 	struct tty_struct *tty = tty_port_tty_get(port);
+	struct tty_ldisc *ld = tty ? tty_ldisc_ref(tty) : NULL;
+
+	if (ld) {
+		if (ld->ops->dcd_change)
+			ld->ops->dcd_change(tty, status);
+		tty_ldisc_deref(ld);
+	}
 
 	dev_dbg(&usb_port->dev, "%s - status %d\n", __func__, status);
 
-- 
1.7.12.1

