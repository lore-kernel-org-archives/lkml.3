Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbaFANPX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:15:23 -0400
Received: from mail.grouk.net ([92.222.18.81]:55795 "EHLO grouk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaFANPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:15:12 -0400
From: Thomas Vegas <thomas@grouk.net>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Thomas Vegas <thomas@grouk.net>
Date: Sun,  1 Jun 2014 14:34:39 +0200
Message-Id: <1401626080-4620-1-git-send-email-thomas@grouk.net>
X-Mailer: git-send-email 1.8.5.5
X-SA-Exim-Connect-IP: 92.151.84.65
X-SA-Exim-Mail-From: thomas@grouk.net
Subject: [PATCH 1/2] staging: rtl8712: Fix oops on dongle removal if firmware is not available
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on grouk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When firmware is not available, net device is not created. Upon
disconnect, we must check for net device existence before trying to
release net device private data.

Signed-off-by: Thomas Vegas <thomas@grouk.net>
---
 drivers/staging/rtl8712/usb_intf.c | 44 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index ba74354..bec9d454 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -607,31 +607,31 @@ error:
 static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 {
 	struct net_device *pnetdev = usb_get_intfdata(pusb_intf);
-	struct _adapter *padapter = netdev_priv(pnetdev);
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
 
-	usb_set_intfdata(pusb_intf, NULL);
-	if (padapter->fw_found)
-		release_firmware(padapter->fw);
-	/* never exit with a firmware callback pending */
-	wait_for_completion(&padapter->rtl8712_fw_ready);
-	if (drvpriv.drv_registered == true)
-		padapter->bSurpriseRemoved = true;
-	if (pnetdev != NULL) {
-		/* will call netdev_close() */
-		unregister_netdev(pnetdev);
+	if (pnetdev) {
+		struct _adapter *padapter = netdev_priv(pnetdev);
+
+		usb_set_intfdata(pusb_intf, NULL);
+		if (padapter->fw_found)
+			release_firmware(padapter->fw);
+		/* never exit with a firmware callback pending */
+		wait_for_completion(&padapter->rtl8712_fw_ready);
+		if (drvpriv.drv_registered == true)
+			padapter->bSurpriseRemoved = true;
+		unregister_netdev(pnetdev); /* will call netdev_close() */
+		flush_scheduled_work();
+		udelay(1);
+		/* Stop driver mlme relation timer */
+		if (padapter->fw_found)
+			r8712_stop_drv_timers(padapter);
+		r871x_dev_unload(padapter);
+		r8712_free_drv_sw(padapter);
+
+		/* decrease the reference count of the usb device structure
+		 * when disconnect */
+		usb_put_dev(udev);
 	}
-	flush_scheduled_work();
-	udelay(1);
-	/*Stop driver mlme relation timer */
-	if (padapter->fw_found)
-		r8712_stop_drv_timers(padapter);
-	r871x_dev_unload(padapter);
-	r8712_free_drv_sw(padapter);
-	usb_set_intfdata(pusb_intf, NULL);
-	/* decrease the reference count of the usb device structure
-	 * when disconnect */
-	usb_put_dev(udev);
 	/* If we didn't unplug usb dongle and remove/insert module, driver
 	 * fails on sitesurvey for the first time when device is up.
 	 * Reset usb port for sitesurvey fail issue. */
-- 
1.8.5.5

