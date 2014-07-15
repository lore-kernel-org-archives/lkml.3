Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbaGORWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:22:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48934 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaGORWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:22:32 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Himangi Saraogi <himangi774@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 72/94] phy: omap-usb2: fix devm_ioremap_resource error detection code
Date: Tue, 15 Jul 2014 20:01:27 +0300
Message-Id: <1405443709-15288-72-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
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
1.7.10.4

