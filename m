Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaLDMGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:06:15 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38367 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbaLDMGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:06:13 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: phy: Restore deferred probing path
Date: Thu,  4 Dec 2014 13:06:07 +0100
Message-Id: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
failure") broke platforms that rely on deferred probing to order probing
of PHY and host controller drivers. The reason is that the commit simply
propagates errors from __of_usb_find_phy(), which returns -ENODEV if no
PHY has been registered yet for a given device tree node. The only case
in which -EPROBE_DEFER would now be returned is if try_module_get() did
fail, which does not make sense.

The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't been
registered yet. The only condition under which it makes sense to return
-ENODEV is if the device tree node representing the PHY has been
disabled (via the status property) because in that case the PHY will
never be registered.

This patch addresses the problem by making __of_usb_find_phy() return an
appropriate error code while keeping in line with the above-mentioned
commit to propagate error codes rather than overwriting them. At the
same time the check for a valid PHY is decoupled from the check for the
try_module_get() call and a separate error code is returned if the
latter fails.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/usb/phy/phy.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
index b4066a001ba0..2f9735b35338 100644
--- a/drivers/usb/phy/phy.c
+++ b/drivers/usb/phy/phy.c
@@ -59,6 +59,9 @@ static struct usb_phy *__of_usb_find_phy(struct device_node *node)
 {
 	struct usb_phy  *phy;
 
+	if (!of_device_is_available(node))
+		return ERR_PTR(-ENODEV);
+
 	list_for_each_entry(phy, &phy_list, head) {
 		if (node != phy->dev->of_node)
 			continue;
@@ -66,7 +69,7 @@ static struct usb_phy *__of_usb_find_phy(struct device_node *node)
 		return phy;
 	}
 
-	return ERR_PTR(-ENODEV);
+	return ERR_PTR(-EPROBE_DEFER);
 }
 
 static void devm_usb_phy_release(struct device *dev, void *res)
@@ -190,10 +193,13 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struct device *dev,
 	spin_lock_irqsave(&phy_lock, flags);
 
 	phy = __of_usb_find_phy(node);
-	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
-		if (!IS_ERR(phy))
-			phy = ERR_PTR(-EPROBE_DEFER);
+	if (IS_ERR(phy)) {
+		devres_free(ptr);
+		goto err1;
+	}
 
+	if (!try_module_get(phy->dev->driver->owner)) {
+		phy = ERR_PTR(-ENODEV);
 		devres_free(ptr);
 		goto err1;
 	}
-- 
2.1.3

