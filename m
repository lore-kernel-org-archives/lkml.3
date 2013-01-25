Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3AYKtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:49:19 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40730 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286Ab3AYKtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:49:17 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 6/6] USB: MUSB: OMAP: get PHY by phandle for dt boot
Date: Fri, 25 Jan 2013 16:19:10 +0530
Message-ID: <1359110950-6147-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359081206-5602-7-git-send-email-kishon@ti.com>
References: <1359081206-5602-7-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP glue has been modified to get PHY by phandle for dt boot.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
There were some comments w.r.t this patch for returning EPROBE_DEFER if
not able to get the phy, in my previous version.
Currently we can't have that because the gadget driver doesn't do a
EPROBE_DEFER. We have a separate activity planned for making gadget driver
also do EPROBE_DEFER for 3.10.
 drivers/usb/musb/omap2430.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index be6d259..08814d2 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -345,7 +345,12 @@ static int omap2430_musb_init(struct musb *musb)
 	 * up through ULPI.  TWL4030-family PMICs include one,
 	 * which needs a driver, drivers aren't always needed.
 	 */
-	musb->xceiv = devm_usb_get_phy_dev(dev, 0);
+	if (dev->parent->of_node)
+		musb->xceiv = devm_usb_get_phy_by_phandle(dev->parent,
+		    "usb-phy", 0);
+	else
+		musb->xceiv = devm_usb_get_phy_dev(dev, 0);
+
 	if (IS_ERR_OR_NULL(musb->xceiv)) {
 		pr_err("HS USB OTG: no transceiver configured\n");
 		return -ENODEV;
-- 
1.7.9.5

