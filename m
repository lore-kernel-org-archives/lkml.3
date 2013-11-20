Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab3KTCNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 21:13:15 -0500
Received: from asix.com.tw ([113.196.140.82]:15201 "EHLO freebsd2.asix.com.tw"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752234Ab3KTCNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 21:13:13 -0500
From: freddy@asix.com.tw
To: netdev@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        davemloft@davemloft.net, louis@asix.com.tw, allan@asix.com.tw,
        grundler@google.com, daniel@asix.com.tw,
        Freddy Xin <freddy@asix.com.tw>
Subject: [PATCH 1/1] Workaround for Suspend/Resume issue of AX88772B under ChromeOS
Date: Wed, 20 Nov 2013 10:11:36 +0800
Message-Id: <1384913496-26261-1-git-send-email-freddy@asix.com.tw>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Freddy Xin <freddy@asix.com.tw>

This patch adds a workaroud to solve Suspend/Resume issue that AX88772B turns
off its Ethernet PHY power in the case that REMOTE_WAKEUP feature doesn't
be set when system suspend. In this case, the PHY power will not be turned
on again when system resume, so the HW reset must be added in the resume function.

Signed-off-by: Freddy Xin <freddy@asix.com.tw>
Tested-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix.h         |    1 +
 drivers/net/usb/asix_devices.c |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index bdaa12d..0e975aa 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -48,6 +48,7 @@
 #define AX_CMD_SET_SW_MII		0x06
 #define AX_CMD_READ_MII_REG		0x07
 #define AX_CMD_WRITE_MII_REG		0x08
+#define AX_CMD_STATMNGSTS_REG		0x09
 #define AX_CMD_SET_HW_MII		0x0a
 #define AX_CMD_READ_EEPROM		0x0b
 #define AX_CMD_WRITE_EEPROM		0x0c
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 386a3df..3ac9958 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -845,6 +845,20 @@ static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 	return 0;
 }
 
+static int asix_resume(struct usb_interface *intf)
+{
+	struct usbnet *dev = usb_get_intfdata(intf);
+	u8 chipcode = 0;
+
+	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode);
+	chipcode &= 0x70;
+
+	if (dev->driver_info->reset && (chipcode == 0x20))
+		dev->driver_info->reset(dev);
+
+	return usbnet_resume(intf);
+}
+
 static const struct driver_info ax8817x_info = {
 	.description = "ASIX AX8817x USB 2.0 Ethernet",
 	.bind = ax88172_bind,
@@ -1101,7 +1115,7 @@ static struct usb_driver asix_driver = {
 	.id_table =	products,
 	.probe =	usbnet_probe,
 	.suspend =	usbnet_suspend,
-	.resume =	usbnet_resume,
+	.resume =	asix_resume,
 	.disconnect =	usbnet_disconnect,
 	.supports_autosuspend = 1,
 	.disable_hub_initiated_lpm = 1,
-- 
1.7.10.4

