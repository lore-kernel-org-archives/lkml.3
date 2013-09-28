Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3I1DwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 23:52:16 -0400
Received: from mail.ispras.ru ([83.149.199.45]:40399 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab3I1DwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 23:52:15 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] carl9170: fix leaks at failure path in carl9170_usb_probe()
Date: Fri, 27 Sep 2013 23:51:51 -0400
Message-Id: <1380340311-4630-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

carl9170_usb_probe() does not handle request_firmware_nowait() failure
that leads to several leaks in this case.
The patch adds all required deallocations.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/carl9170/usb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 307bc0d..3c76de1 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -1076,8 +1076,14 @@ static int carl9170_usb_probe(struct usb_interface *intf,
 
 	carl9170_set_state(ar, CARL9170_STOPPED);
 
-	return request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
+	err = request_firmware_nowait(THIS_MODULE, 1, CARL9170FW_NAME,
 		&ar->udev->dev, GFP_KERNEL, ar, carl9170_usb_firmware_step2);
+	if (err) {
+		usb_put_dev(udev);
+		usb_put_dev(udev);
+		carl9170_free(ar);
+	}
+	return err;
 }
 
 static void carl9170_usb_disconnect(struct usb_interface *intf)
-- 
1.8.1.2

