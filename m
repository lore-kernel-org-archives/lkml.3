Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaGHTRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:17:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54352 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755762AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.40075357@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 028/125] USB: option: fix runtime PM handling
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit acf47d4f9c39b1cba467aa9442fc2efe0b1da741 upstream.

Fix potential I/O while runtime suspended due to missing PM operations
in send_setup.

Fixes: 383cedc3bb43 ("USB: serial: full autosuspend support for the
option driver")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1955,6 +1955,7 @@ static int option_send_setup(struct usb_
 	struct usb_wwan_port_private *portdata;
 	int ifNum = serial->interface->cur_altsetting->desc.bInterfaceNumber;
 	int val = 0;
+	int res;
 	dbg("%s", __func__);
 
 	if (is_blacklisted(ifNum, OPTION_BLACKLIST_SENDSETUP,
@@ -1970,9 +1971,16 @@ static int option_send_setup(struct usb_
 	if (portdata->rts_state)
 		val |= 0x02;
 
-	return usb_control_msg(serial->dev,
-		usb_rcvctrlpipe(serial->dev, 0),
+	res = usb_autopm_get_interface(serial->interface);
+	if (res)
+		return res;
+
+	res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
 		0x22, 0x21, val, ifNum, NULL, 0, USB_CTRL_SET_TIMEOUT);
+
+	usb_autopm_put_interface(serial->interface);
+
+	return res;
 }
 
 MODULE_AUTHOR(DRIVER_AUTHOR);

