Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbaKTPxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:53:50 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:51092 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaKTPxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:53:48 -0500
From: Arjun Sreedharan <arjun024@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Date: Thu, 20 Nov 2014 21:23:36 +0530
Message-Id: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __of_usb_find_phy() fails, it returns -ENODEV - its
error code has to be returned by devm_usb_get_phy_by_phandle().
Only when the former function succeeds and try_module_get()
fails should -EPROBE_DEFER be returned.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/usb/phy/phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index 045cd30..0310112 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
 
 	phy = __of_usb_find_phy(node);
 	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
-		phy = ERR_PTR(-EPROBE_DEFER);
+		if (!IS_ERR(phy))
+			phy = ERR_PTR(-EPROBE_DEFER);
+		
 		devres_free(ptr);
 		goto err1;
 	}
-- 
1.7.11.7

