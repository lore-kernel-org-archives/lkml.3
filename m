Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761244AbaGRJbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:31:55 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56571 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaGRJbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:31:53 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 4/9] usb: phy: am335x-control: prevent module from being unloaded when in use
Date: Fri, 18 Jul 2014 11:31:25 +0200
Message-Id: <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the real cause of the crash that was "fixed" by
commit 7adb5c876e9c usb: musb: Fix panic upon musb_am335x module removal

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/usb/phy/phy-am335x-control.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/phy/phy-am335x-control.c b/drivers/usb/phy/phy-am335x-control.c
index 35b6083..df3e1ba 100644
--- a/drivers/usb/phy/phy-am335x-control.c
+++ b/drivers/usb/phy/phy-am335x-control.c
@@ -140,6 +140,9 @@ static int am335x_control_usb_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 	const struct phy_control *phy_ctrl;
 
+	if (!try_module_get(pdev->dev.parent->driver->owner))
+		return -EPROBE_DEFER;
+
 	of_id = of_match_node(omap_control_usb_id_table, pdev->dev.of_node);
 	if (!of_id)
 		return -EINVAL;
@@ -171,8 +174,15 @@ static int am335x_control_usb_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int am335x_control_usb_remove(struct platform_device *pdev)
+{
+	module_put(pdev->dev.parent->driver->owner);
+	return 0;
+}
+
 static struct platform_driver am335x_control_driver = {
 	.probe		= am335x_control_usb_probe,
+	.remove		= am335x_control_usb_remove,
 	.driver		= {
 		.name	= "am335x-control-usb",
 		.owner	= THIS_MODULE,
-- 
1.7.10.4

