Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030981AbaGCKEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:04:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758431AbaGCJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/198] USB: cdc-acm: fix runtime PM for control messages
Date: Thu,  3 Jul 2014 10:18:31 +0100
Message-Id: <1404379241-8590-69-git-send-email-luis.henriques@canonical.com>
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

commit bae3f4c53585e9a170da9436e0f06919874bda9a upstream.

Fix runtime PM handling of control messages by adding the required PM
counter operations.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7b1ed4b06f6b..ca53818690e3 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -122,13 +122,23 @@ static void acm_release_minor(struct acm *acm)
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
 
-- 
1.9.1

