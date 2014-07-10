Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaGJG0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:26:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38434 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaGJGZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:25:24 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] phy: omap-usb2: fix devm_ioremap_resource error detection code
Date: Thu, 10 Jul 2014 11:55:00 +0530
Message-ID: <1404973503-3310-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404973503-3310-1-git-send-email-kishon@ti.com>
References: <1404973503-3310-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>

devm_ioremap_resource returns an ERR_PTR value, not NULL, on failure.

A simplified version of the semantic match that finds this problem is as
follows:

// <smpl>
@@
expression e,e1;
statement S;
@@

*e = devm_ioremap_resource(...);
if (!e1) S

// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-omap-usb2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
index 7007c11..2063d54 100644
--- a/drivers/phy/phy-omap-usb2.c
+++ b/drivers/phy/phy-omap-usb2.c
@@ -233,8 +233,8 @@ static int omap_usb2_probe(struct platform_device *pdev)
 	if (phy_data->flags & OMAP_USB2_CALIBRATE_FALSE_DISCONNECT) {
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 		phy->phy_base = devm_ioremap_resource(&pdev->dev, res);
-		if (!phy->phy_base)
-			return -ENOMEM;
+		if (IS_ERR(phy->phy_base))
+			return PTR_ERR(phy->phy_base);
 		phy->flags |= OMAP_USB2_CALIBRATE_FALSE_DISCONNECT;
 	}
 
-- 
1.7.9.5

