Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3CNX7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:59:41 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56484 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab3CNX7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:59:39 -0400
From: Doug Anderson <dianders@chromium.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Alexander Graf <agraf@suse.de>, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
Date: Thu, 14 Mar 2013 16:59:15 -0700
Message-Id: <1363305555-3544-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ehci_vbus_gpio is requested but never freed.  This can cause
problems with deferred probes and would cause problems if
s5p_ehci_remove was ever called.  Use devm to fix this.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/host/ehci-s5p.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 20ebf6a..a464197 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -92,6 +92,7 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
 
 static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	int err;
 	int gpio;
 
@@ -103,7 +104,8 @@ static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 	if (!gpio_is_valid(gpio))
 		return;
 
-	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
+	err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
+				    "ehci_vbus_gpio");
 	if (err)
 		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
 }
-- 
1.8.1.3

