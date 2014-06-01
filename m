Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaFANPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:15:13 -0400
Received: from mail.grouk.net ([92.222.18.81]:55789 "EHLO grouk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbaFANPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:15:11 -0400
X-Greylist: delayed 2540 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 09:15:11 EDT
From: Thomas Vegas <thomas@grouk.net>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Thomas Vegas <thomas@grouk.net>
Date: Sun,  1 Jun 2014 14:34:40 +0200
Message-Id: <1401626080-4620-2-git-send-email-thomas@grouk.net>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1401626080-4620-1-git-send-email-thomas@grouk.net>
References: <1401626080-4620-1-git-send-email-thomas@grouk.net>
X-SA-Exim-Connect-IP: 92.151.84.65
X-SA-Exim-Mail-From: thomas@grouk.net
Subject: [PATCH 2/2] staging: rtl8712: Remove useless variable 'fw_found'
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on grouk.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The net device only exists when firmware is loaded successfully.
Firmware presence variable is only used through r871xu_dev_remove() and
this function already checks for net device existence.

Signed-off-by: Thomas Vegas <thomas@grouk.net>
---
 drivers/staging/rtl8712/drv_types.h | 1 -
 drivers/staging/rtl8712/hal_init.c  | 2 --
 drivers/staging/rtl8712/os_intfs.c  | 3 +--
 drivers/staging/rtl8712/usb_intf.c  | 6 ++----
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8712/drv_types.h b/drivers/staging/rtl8712/drv_types.h
index 3362e5e..0168745 100644
--- a/drivers/staging/rtl8712/drv_types.h
+++ b/drivers/staging/rtl8712/drv_types.h
@@ -160,7 +160,6 @@ struct _adapter {
 	s32	bSurpriseRemoved;
 	u32	IsrContent;
 	u32	ImrContent;
-	bool	fw_found;
 	u8	EepromAddressSize;
 	u8	hw_init_completed;
 	struct task_struct *cmdThread;
diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 36de7e4..0556de3 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -50,13 +50,11 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 		struct usb_device *udev = padapter->dvobjpriv.pusbdev;
 		struct usb_interface *pusb_intf = padapter->pusb_intf;
 		dev_err(&udev->dev, "r8712u: Firmware request failed\n");
-		padapter->fw_found = false;
 		usb_put_dev(udev);
 		usb_set_intfdata(pusb_intf, NULL);
 		return;
 	}
 	padapter->fw = firmware;
-	padapter->fw_found = true;
 	/* firmware available - start netdev */
 	register_netdev(padapter->pnetdev);
 }
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 6bd0821..13debb5 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -345,8 +345,7 @@ u8 r8712_free_drv_sw(struct _adapter *padapter)
 	r8712_free_mlme_priv(&padapter->mlmepriv);
 	r8712_free_io_queue(padapter);
 	_free_xmit_priv(&padapter->xmitpriv);
-	if (padapter->fw_found)
-		_r8712_free_sta_priv(&padapter->stapriv);
+	_r8712_free_sta_priv(&padapter->stapriv);
 	_r8712_free_recv_priv(&padapter->recvpriv);
 	mp871xdeinit(padapter);
 	if (pnetdev)
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index bec9d454..beff69b 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -613,8 +613,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 		struct _adapter *padapter = netdev_priv(pnetdev);
 
 		usb_set_intfdata(pusb_intf, NULL);
-		if (padapter->fw_found)
-			release_firmware(padapter->fw);
+		release_firmware(padapter->fw);
 		/* never exit with a firmware callback pending */
 		wait_for_completion(&padapter->rtl8712_fw_ready);
 		if (drvpriv.drv_registered == true)
@@ -623,8 +622,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 		flush_scheduled_work();
 		udelay(1);
 		/* Stop driver mlme relation timer */
-		if (padapter->fw_found)
-			r8712_stop_drv_timers(padapter);
+		r8712_stop_drv_timers(padapter);
 		r871x_dev_unload(padapter);
 		r8712_free_drv_sw(padapter);
 
-- 
1.8.5.5

