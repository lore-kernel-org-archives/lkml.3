Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbaGRJcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:32:50 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56593 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934143AbaGRJcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:32:10 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 9/9] usb: musb: musb_am335x: reinstate module loading/unloading support
Date: Fri, 18 Jul 2014 11:31:30 +0200
Message-Id: <1405675890-8802-10-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to throw the baby out with the bath due to a bad
failure analysis. The commit:
7adb5c876e9c usb: musb: Fix panic upon musb_am335x module removal
came to a wrong conclusion about the cause of the crash it was
"fixing". The real culprit was the phy-am335x module that was removed
from underneath its users that were still referencing data from it.
After having fixed this in a previous patch, module unloading can be
reinstated.

Another bug with module loading/unloading was the fact, that after
removing the devices instantiated from DT their 'OF_POPULATED' flag
was still set, so that re-loading the module after an unload had no
effect. This is also fixed in this patch.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/musb/musb_am335x.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/musb_am335x.c b/drivers/usb/musb/musb_am335x.c
index 164c868..152a6f5 100644
--- a/drivers/usb/musb/musb_am335x.c
+++ b/drivers/usb/musb/musb_am335x.c
@@ -19,6 +19,22 @@ err:
 	return ret;
 }
 
+static int of_remove_populated_child(struct device *dev, void *d)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	of_device_unregister(pdev);
+	of_node_clear_flag(pdev->dev.of_node, OF_POPULATED);
+	return 0;
+}
+
+static int am335x_child_remove(struct platform_device *pdev)
+{
+	device_for_each_child(&pdev->dev, NULL, of_remove_populated_child);
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
 static const struct of_device_id am335x_child_of_match[] = {
 	{ .compatible = "ti,am33xx-usb" },
 	{  }
@@ -27,17 +43,14 @@ MODULE_DEVICE_TABLE(of, am335x_child_of_match);
 
 static struct platform_driver am335x_child_driver = {
 	.probe		= am335x_child_probe,
+	.remove		= am335x_child_remove,
 	.driver		= {
 		.name	= "am335x-usb-childs",
 		.of_match_table	= am335x_child_of_match,
 	},
 };
 
-static int __init am335x_child_init(void)
-{
-	return platform_driver_register(&am335x_child_driver);
-}
-module_init(am335x_child_init);
+module_platform_driver(am335x_child_driver);
 
 MODULE_DESCRIPTION("AM33xx child devices");
 MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

