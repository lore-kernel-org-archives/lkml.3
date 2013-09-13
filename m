Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab3IMPmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:42:04 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:37402 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757519Ab3IMPlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:41:44 -0400
From: Paul Chavent <Paul.Chavent@onera.fr>
To: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com
Cc: linux-kernel@vger.kernel.org, Paul Chavent <Paul.Chavent@onera.fr>
Subject: [PATCH 2/3] USB : serial : invoke dcd_change ldisc's handler.
Date: Fri, 13 Sep 2013 17:35:12 +0200
Message-Id: <1379086513-2434-3-git-send-email-paul.chavent@onera.fr>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 13 Sep 2013 17:41:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
---
 Documentation/pps/pps.txt    | 15 +++++++++++++++
 drivers/usb/serial/generic.c |  9 +++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/pps/pps.txt b/Documentation/pps/pps.txt
index d35dcdd..67b9a94 100644
--- a/Documentation/pps/pps.txt
+++ b/Documentation/pps/pps.txt
@@ -66,6 +66,21 @@ In LinuxPPS the PPS sources are simply char devices usually mapped
 into files /dev/pps0, /dev/pps1, etc..
 
 
+PPS with USB to serial devices
+------------------------------
+
+It is possible to grab the PPS from an USB to serial device. However,
+you should take into account the latencies and jitter introduced by
+the USB stack. Users has reported clock instability around +-1ms when
+synchronized with PPS through USB. This isn't suited for time server
+synchronisation.
+
+If your device doesn't report PPS, you can check that the feature is
+supported by its driver. Most of the time, you only need to add a call
+to usb_serial_handle_dcd_change after checking the DCD status (see
+ch341 and pl2303 examples).
+
+
 Coding example
 --------------
 
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 1f31e6b..877d6e0 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -568,6 +568,15 @@ void usb_serial_handle_dcd_change(struct usb_serial_port *usb_port,
 {
 	struct tty_port *port = &usb_port->port;
 
+	if (tty) {
+		struct tty_ldisc *ld = tty_ldisc_ref(tty);
+		if (ld) {
+			if (ld->ops->dcd_change)
+				ld->ops->dcd_change(tty, status);
+			tty_ldisc_deref(ld);
+		}
+	}
+
 	dev_dbg(&usb_port->dev, "%s - status %d\n", __func__, status);
 
 	if (status)
-- 
1.7.12.1

