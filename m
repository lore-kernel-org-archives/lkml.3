Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3IQU6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 16:58:25 -0400
Received: from mail.ispras.ru ([83.149.199.45]:38502 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab3IQU6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 16:58:23 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] p54usb: fix leak at failure path in p54u_load_firmware()
Date: Wed, 18 Sep 2013 00:57:59 +0400
Message-Id: <1379451479-31107-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If request_firmware_nowait() fails in p54u_load_firmware(),
p54u_load_firmware_cb is not called and no one decrements usb_dev refcnt.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/p54/p54usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index b9deef6..7fa81d1 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -979,6 +979,7 @@ static int p54u_load_firmware(struct ieee80211_hw *dev,
 	if (err) {
 		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
 					  "(%d)!\n", p54u_fwlist[i].fw, err);
+		usb_put_dev(udev);
 	}
 
 	return err;
-- 
1.8.1.2

