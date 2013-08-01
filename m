Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3HAOFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:05:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48794 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3HAOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:05:31 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 4/7] usb: musb: omap2430: Don't use omap_get_control_dev()
Date: Thu, 1 Aug 2013 17:05:12 +0300
Message-ID: <1375365915-21380-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1375365915-21380-1-git-send-email-rogerq@ti.com>
References: <1375365915-21380-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap_get_control_dev() is being deprecated as it doesn't support
multiple instances. As control device is present only from OMAP4
onwards which supports DT only, we use phandles to get the
reference to the control device.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/musb/omap2430.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index ebb46ec..1db9588 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/usb/musb-omap.h>
 #include <linux/usb/omap_control_usb.h>
+#include <linux/of_platform.h>
 
 #include "musb_core.h"
 #include "omap2430.h"
@@ -547,12 +548,25 @@ static int omap2430_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->has_mailbox) {
-		glue->control_otghs = omap_get_control_dev();
-		if (IS_ERR(glue->control_otghs)) {
-			dev_vdbg(&pdev->dev, "Failed to get control device\n");
-			ret = PTR_ERR(glue->control_otghs);
+		struct device_node *control_node;
+		struct platform_device *control_pdev;
+
+		control_node = of_parse_phandle(np, "ctrl-module", 0);
+		if (!control_node) {
+			dev_err(&pdev->dev, "Failed to get control device phandle\n");
+			ret = -ENODEV;
+			goto err2;
+		}
+
+		control_pdev = of_find_device_by_node(control_node);
+		if (!control_pdev) {
+			dev_err(&pdev->dev, "Failed to get control device\n");
+			ret = -ENODEV;
 			goto err2;
 		}
+
+		glue->control_otghs = &control_pdev->dev;
+
 	} else {
 		glue->control_otghs = ERR_PTR(-ENODEV);
 	}
-- 
1.7.4.1

