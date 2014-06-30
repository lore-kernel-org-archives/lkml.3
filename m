Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbaF3Me2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:34:28 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174AbaF3Mb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 109/181] USB: option: fix runtime PM handling
Date: Mon, 30 Jun 2014 13:52:10 +0200
Message-Id: <1c2846ce8c2a1226a8a079856133ff553ae52788.1404128998.git.jslaby@suse.cz>
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

commit acf47d4f9c39b1cba467aa9442fc2efe0b1da741 upstream.

Fix potential I/O while runtime suspended due to missing PM operations
in send_setup.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/option.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 948a19f0cdf7..70ede84f4f6b 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1925,6 +1925,7 @@ static int option_send_setup(struct usb_serial_port *port)
 	struct option_private *priv = intfdata->private;
 	struct usb_wwan_port_private *portdata;
 	int val = 0;
+	int res;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -1933,9 +1934,17 @@ static int option_send_setup(struct usb_serial_port *port)
 	if (portdata->rts_state)
 		val |= 0x02;
 
-	return usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+	res = usb_autopm_get_interface(serial->interface);
+	if (res)
+		return res;
+
+	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 				0x22, 0x21, val, priv->bInterfaceNumber, NULL,
 				0, USB_CTRL_SET_TIMEOUT);
+
+	usb_autopm_put_interface(serial->interface);
+
+	return res;
 }
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
-- 
2.0.0

