Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964817AbaF3Mbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964795AbaF3Mbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 134/181] USB: sierra: fix use after free at suspend/resume
Date: Mon, 30 Jun 2014 13:52:35 +0200
Message-Id: <5335b365b1d7a24630fb5485fc19d883eec99147.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8452727de70f6ad850cd6d0aaa18b5d9050aa63b upstream.

Fix use after free or NULL-pointer dereference during suspend and
resume.

The port data may never have been allocated (port probe failed)
or may already have been released by port_remove (e.g. driver is
unloaded) when suspend and resume are called.

Fixes: e6929a9020ac ("USB: support for autosuspend in sierra while
online")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/sierra.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index b3f2b60465bd..efdb76a7b787 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -941,6 +941,7 @@ static int sierra_port_remove(struct usb_serial_port *port)
 	struct sierra_port_private *portdata;
 
 	portdata = usb_get_serial_port_data(port);
+	usb_set_serial_port_data(port, NULL);
 	kfree(portdata);
 
 	return 0;
@@ -957,6 +958,8 @@ static void stop_read_write_urbs(struct usb_serial *serial)
 	for (i = 0; i < serial->num_ports; ++i) {
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
+		if (!portdata)
+			continue;
 		sierra_stop_rx_urbs(port);
 		usb_kill_anchored_urbs(&portdata->active);
 	}
@@ -999,6 +1002,9 @@ static int sierra_resume(struct usb_serial *serial)
 		port = serial->port[i];
 		portdata = usb_get_serial_port_data(port);
 
+		if (!portdata)
+			continue;
+
 		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			usb_anchor_urb(urb, &portdata->active);
 			intfdata->in_flight++;
-- 
2.0.0

