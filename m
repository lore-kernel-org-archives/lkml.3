Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaC1U0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:26:31 -0400
Received: from mail.ispras.ru ([83.149.199.45]:52379 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaC1U03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:26:29 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] rtl8187: fix use after free on failure path in rtl8187_probe()
Date: Sat, 29 Mar 2014 00:26:15 +0400
Message-Id: <1396038375-18122-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If allocation of io_dmabuf fails, rtl8187_probe() calls usb_put_dev(udev)
while usb_get_dev(udev) is not called yet. As a result refcnt is decremented
incorrectly and usb_dev can be used after memory deallocation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index fd78df813a85..d7f540a9dc9b 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -1636,10 +1636,10 @@ static int rtl8187_probe(struct usb_interface *intf,
 
  err_free_dmabuf:
 	kfree(priv->io_dmabuf);
- err_free_dev:
-	ieee80211_free_hw(dev);
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(udev);
+ err_free_dev:
+	ieee80211_free_hw(dev);
 	return err;
 }
 
-- 
1.8.3.2

