Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbaF1TVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:21:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbaF1RrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 09/43] USB: option: fix runtime PM handling
Date: Sat, 28 Jun 2014 10:46:00 -0700
Message-Id: <20140628174450.244909867@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit acf47d4f9c39b1cba467aa9442fc2efe0b1da741 upstream.

Fix potential I/O while runtime suspended due to missing PM operations
in send_setup.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1930,6 +1930,7 @@ static int option_send_setup(struct usb_
 	struct usb_wwan_port_private *portdata;
 	int ifNum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
 	int val = 0;
+	int res;
 	dbg("%s", __func__);
 
 	if (is_blacklisted(ifNum, OPTION_BLACKLIST_SENDSETUP,
@@ -1945,9 +1946,17 @@ static int option_send_setup(struct usb_
 	if (portdata->rts_state)
 		val |= 0x02;
 
-	return usb_control_msg(serial->dev,
-		usb_rcvctrlpipe(serial->dev, 0),
-		0x22, 0x21, val, ifNum, NULL, 0, USB_CTRL_SET_TIMEOUT);
+	res = usb_autopm_get_interface(serial->interface);
+	if (res)
+		return res;
+
+	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
+				0x22, 0x21, val, ifNum, NULL,
+				0, USB_CTRL_SET_TIMEOUT);
+
+	usb_autopm_put_interface(serial->interface);
+
+	return res;
 }
 
 MODULE_AUTHOR(DRIVER_AUTHOR);


