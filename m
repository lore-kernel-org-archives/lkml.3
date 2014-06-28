Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaF1RZC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:25:02 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42777 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaF1RZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:25:00 -0400
Date: Sat, 28 Jun 2014 22:54:51 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: phy: omap-usb2: fix devm_ioremap_resource error
 detection code
Message-ID: <20140628172450.GA3425@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/phy/phy-omap-usb2.c | 4 ++--
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
1.9.1

