Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaBFAr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:47:27 -0500
Received: from mail.ispras.ru ([83.149.199.45]:34143 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaBFAr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:47:26 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: gdm72xx: fix leaks at failure path in gdm_usb_probe()
Date: Thu,  6 Feb 2014 01:47:13 +0100
Message-Id: <1391647633-21832-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling code in gdm_usb_probe() misses to deallocate
tx_ and rx_structs and to do usb_put_dev().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/gdm72xx/gdm_usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index f8788bf0a7d3..cdeffe75496b 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -635,11 +635,14 @@ static int gdm_usb_probe(struct usb_interface *intf,
 #endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
 
 	ret = register_wimax_device(phy_dev, &intf->dev);
+	if (ret)
+		release_usb(udev);
 
 out:
 	if (ret) {
 		kfree(phy_dev);
 		kfree(udev);
+		usb_put_dev(usbdev);
 	} else {
 		usb_set_intfdata(intf, phy_dev);
 	}
-- 
1.8.3.2

