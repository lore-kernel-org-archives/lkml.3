Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030996AbaGCKGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:06:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019AbaGCJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/198] USB: option: fix runtime PM handling
Date: Thu,  3 Jul 2014 10:18:22 +0100
Message-Id: <1404379241-8590-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit acf47d4f9c39b1cba467aa9442fc2efe0b1da741 upstream.

Fix potential I/O while runtime suspended due to missing PM operations
in send_setup.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

