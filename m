Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965385AbaFXQHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:07:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967AbaFXP4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:56:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.15 29/61] USB: cdc-acm: fix runtime PM for control messages
Date: Tue, 24 Jun 2014 11:51:12 -0400
Message-Id: <20140624154954.097244504@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit bae3f4c53585e9a170da9436e0f06919874bda9a upstream.

Fix runtime PM handling of control messages by adding the required PM
counter operations.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -122,13 +122,23 @@ static void acm_release_minor(struct acm
 static int acm_ctrl_msg(struct acm *acm, int request, int value,
 							void *buf, int len)
 {
-	int retval = usb_control_msg(acm->dev, usb_sndctrlpipe(acm->dev, 0),
+	int retval;
+
+	retval = usb_autopm_get_interface(acm->control);
+	if (retval)
+		return retval;
+
+	retval = usb_control_msg(acm->dev, usb_sndctrlpipe(acm->dev, 0),
 		request, USB_RT_ACM, value,
 		acm->control->altsetting[0].desc.bInterfaceNumber,
 		buf, len, 5000);
+
 	dev_dbg(&acm->control->dev,
 			"%s - rq 0x%02x, val %#x, len %#x, result %d\n",
 			__func__, request, value, len, retval);
+
+	usb_autopm_put_interface(acm->control);
+
 	return retval < 0 ? retval : 0;
 }
 


