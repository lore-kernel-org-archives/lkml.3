Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3CODQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:16:00 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:45701 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3CODP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:15:57 -0400
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
Subject: [PATCH v2] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
Date: Thu, 14 Mar 2013 20:15:37 -0700
Message-Id: <1363317337-7316-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363305555-3544-1-git-send-email-dianders@chromium.org>
References: <1363305555-3544-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ehci_vbus_gpio is requested but never freed.  This can cause
problems with deferred probes and would cause problems if
s5p_ehci_remove was ever called.  Use devm to fix this.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- &pdev->dev => dev elsewhere in s5p_setup_vbus_gpio()

 drivers/usb/host/ehci-s5p.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 20ebf6a..738490e 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -92,20 +92,21 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
 
 static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	int err;
 	int gpio;
 
-	if (!pdev->dev.of_node)
+	if (!dev->of_node)
 		return;
 
-	gpio = of_get_named_gpio(pdev->dev.of_node,
-			"samsung,vbus-gpio", 0);
+	gpio = of_get_named_gpio(dev->of_node, "samsung,vbus-gpio", 0);
 	if (!gpio_is_valid(gpio))
 		return;
 
-	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
+	err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
+				    "ehci_vbus_gpio");
 	if (err)
-		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
+		dev_err(dev, "can't request ehci vbus gpio %d", gpio);
 }
 
 static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
-- 
1.8.1.3

