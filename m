Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaKQNi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:38:26 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48705 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752899AbaKQNgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:36:00 -0500
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com, balbi@ti.com,
        p.zabel@pengutronix.de
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, michal.simek@xilinx.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 07/13] usb: chipidea: fix phy handling
Date: Mon, 17 Nov 2014 14:35:41 +0100
Message-Id: <1416231347-27193-8-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1416231347-27193-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic plaftorm device for ChipIdea drivers is probed by calling
ci_hdrc_probe. The device structure used is not the one of the specific
ChipIdea driver but the one of the generic ChipIdea platform device.

This results in not being able to probe the PHYs as we're not using the
right device structure. Since all ChipIdea drivers are retrieving their
PHYs in their specific driver code, this didn't impact any of them yet.

Fixes it using the right device structure (dev->parent).

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/usb/chipidea/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index de1e4a84aa93..068e0c6acc3f 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -686,8 +686,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 	} else if (ci->platdata->usb_phy) {
 		ci->usb_phy = ci->platdata->usb_phy;
 	} else {
-		ci->phy = devm_phy_get(dev, "usb-phy");
-		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
+		ci->phy = devm_phy_get(dev->parent, "usb-phy");
+		ci->usb_phy = devm_usb_get_phy(dev->parent, USB_PHY_TYPE_USB2);
 
 		/* if both generic PHY and USB PHY layers aren't enabled */
 		if (PTR_ERR(ci->phy) == -ENOSYS &&
-- 
2.1.0

