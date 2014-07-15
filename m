Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbaGORIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:08:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42177 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbaGORCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:20 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 74/94] phy: core: Fix error path in phy_create()
Date: Tue, 15 Jul 2014 20:01:29 +0300
Message-Id: <1405443709-15288-74-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

Prevent resources from being freed twice in case device_add() call
fails within phy_create(). Also use ida_simple_remove() instead of
ida_remove() as we had used ida_simple_get() to allocate the ida.

Cc: 3.13+ <stable@vger.kernel.org> # 3.13+
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/phy/phy-core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index c64a2f3..49c4465 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -614,8 +614,9 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 	return phy;
 
 put_dev:
-	put_device(&phy->dev);
-	ida_remove(&phy_ida, phy->id);
+	put_device(&phy->dev);  /* calls phy_release() which frees resources */
+	return ERR_PTR(ret);
+
 free_phy:
 	kfree(phy);
 	return ERR_PTR(ret);
@@ -799,7 +800,7 @@ static void phy_release(struct device *dev)
 
 	phy = to_phy(dev);
 	dev_vdbg(dev, "releasing '%s'\n", dev_name(dev));
-	ida_remove(&phy_ida, phy->id);
+	ida_simple_remove(&phy_ida, phy->id);
 	kfree(phy);
 }
 
-- 
1.7.10.4

