Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbaGDKBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:01:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33799 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965011AbaGDJ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:56:05 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>
CC: <nsekhar@ti.com>, <nm@ti.com>, <george.cherian@ti.com>,
        <sergei.shtylyov@cogentembedded.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 2/6] phy: core: Fix error path in phy_create()
Date: Fri, 4 Jul 2014 12:55:44 +0300
Message-ID: <1404467748-12154-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404467748-12154-1-git-send-email-rogerq@ti.com>
References: <1404467748-12154-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent resources from being freed twice in case device_add() call
fails within phy_create(). Also use ida_simple_remove() instead of
ida_remove() as we had used ida_simple_get() to allocate the ida.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/phy/phy-core.c | 7 ++++---
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
1.8.3.2

