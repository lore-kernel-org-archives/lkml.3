Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaGGGts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:49:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49133 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaGGGsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:48:50 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] phy: core: Fix error path in phy_create()
Date: Mon, 7 Jul 2014 12:18:22 +0530
Message-ID: <1404715705-5041-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404715705-5041-1-git-send-email-kishon@ti.com>
References: <1404715705-5041-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

Prevent resources from being freed twice in case device_add() call
fails within phy_create(). Also use ida_simple_remove() instead of
ida_remove() as we had used ida_simple_get() to allocate the ida.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
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
1.7.9.5

