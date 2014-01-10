Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaAJVWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:22:33 -0500
Received: from mail.ispras.ru ([83.149.199.45]:56073 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbaAJVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:22:30 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: wlan-ng: fix leaks on failure paths in prism2sta_probe_usb()
Date: Sat, 11 Jan 2014 01:22:11 +0400
Message-Id: <1389388931-18832-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are leaks of resources allocated by wlan_setup() and usb_dev refcnt
on failure paths in prism2sta_probe_usb().

The patch adds appropriate deallocations and removes invalid code
from hfa384x_corereset() failure handling.
unregister_wlandev() is wrong because it is not registered yet.
hfa384x_destroy() is just noop in init state.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/wlan-ng/prism2usb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index b401974fb282..4739c14d8359 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -140,11 +140,9 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 					   prism2_reset_holdtime,
 					   prism2_reset_settletime, 0);
 		if (result != 0) {
-			unregister_wlandev(wlandev);
-			hfa384x_destroy(hw);
 			result = -EIO;
 			dev_err(&interface->dev, "hfa384x_corereset() failed.\n");
-			goto failed;
+			goto failed_reset;
 		}
 	}
 
@@ -159,11 +157,15 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	if (register_wlandev(wlandev) != 0) {
 		dev_err(&interface->dev, "register_wlandev() failed.\n");
 		result = -EIO;
-		goto failed;
+		goto failed_register;
 	}
 
 	goto done;
 
+failed_register:
+	usb_put_dev(dev);
+failed_reset:
+	wlan_unsetup(wlandev);
 failed:
 	kfree(wlandev);
 	kfree(hw);
-- 
1.8.3.2

