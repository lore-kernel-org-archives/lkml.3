Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbaCGVMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:12:17 -0500
Received: from mail.ispras.ru ([83.149.199.45]:44156 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaCGVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:12:14 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] p54usb: fix leaks at failure path in p54u_probe()
Date: Sat,  8 Mar 2014 01:11:49 +0400
Message-Id: <1394226709-10763-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If p54u_load_firmware() fails, p54u_probe() does not deallocate
already allocated resources. The patch adds proper failure handling.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/p54/p54usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index 6e635cfa24c8..5df74503fd4f 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -1053,6 +1053,10 @@ static int p54u_probe(struct usb_interface *intf,
 		priv->upload_fw = p54u_upload_firmware_net2280;
 	}
 	err = p54u_load_firmware(dev, intf);
+	if (err) {
+		usb_put_dev(udev);
+		p54_free_common(dev);
+	}
 	return err;
 }
 
-- 
1.8.3.2

