Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932243AbaF3MM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51979 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/181] USB: cdc-acm: fix runtime PM for control messages
Date: Mon, 30 Jun 2014 13:51:22 +0200
Message-Id: <2b3d198964217187e5e1da3013008d98769751b6.1404128998.git.jslaby@suse.cz>
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

commit bae3f4c53585e9a170da9436e0f06919874bda9a upstream.

Fix runtime PM handling of control messages by adding the required PM
counter operations.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index d9e346cf1eb8..d89871b49f11 100644
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
2.0.0

