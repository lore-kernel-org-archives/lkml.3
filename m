Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964843AbaF3Mbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:31:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964776AbaF3Mba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 133/181] USB: sierra: fix AA deadlock in open error path
Date: Mon, 30 Jun 2014 13:52:34 +0200
Message-Id: <e1eb638190ae13c0156833b9eb8081811dbd08e5.1404128998.git.jslaby@suse.cz>
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

commit 353fe198602e8b4d1c7bdcceb8e60955087201b1 upstream.

Fix AA deadlock in open error path that would call close() and try to
grab the already held disc_mutex.

Fixes: b9a44bc19f48 ("sierra: driver urb handling improvements")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/sierra.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index b6910b7ab7e2..b3f2b60465bd 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -824,14 +824,9 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 			usb_sndbulkpipe(serial->dev, endpoint) | USB_DIR_IN);
 
 	err = sierra_submit_rx_urbs(port, GFP_KERNEL);
-	if (err) {
-		/* get rid of everything as in close */
-		sierra_close(port);
-		/* restore balance for autopm */
-		if (!serial->disconnected)
-			usb_autopm_put_interface(serial->interface);
-		return err;
-	}
+	if (err)
+		goto err_submit;
+
 	sierra_send_setup(port);
 
 	serial->interface->needs_remote_wakeup = 1;
@@ -841,6 +836,16 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 	usb_autopm_put_interface(serial->interface);
 
 	return 0;
+
+err_submit:
+	sierra_stop_rx_urbs(port);
+
+	for (i = 0; i < portdata->num_in_urbs; i++) {
+		sierra_release_urb(portdata->in_urbs[i]);
+		portdata->in_urbs[i] = NULL;
+	}
+
+	return err;
 }
 
 
-- 
2.0.0

