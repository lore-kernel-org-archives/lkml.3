Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaGJG0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:26:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38436 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaGJGZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] phy: core: Fix error path in phy_create()
Date: Thu, 10 Jul 2014 11:55:02 +0530
Message-ID: <1404973503-3310-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404973503-3310-1-git-send-email-kishon@ti.com>
References: <1404973503-3310-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
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

