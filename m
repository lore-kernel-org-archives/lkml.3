Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3CNAtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:49:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725Ab3CNAtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:49:22 -0400
From: Alexander Graf <agraf@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH v2] USB: ehci-s5p: Fix phy reset
Date: Thu, 14 Mar 2013 00:59:39 +0100
Message-Id: <1363219179-14900-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Exynos 5 based Arndale system, I need to pull the reset line down
and then let it go up again to actually perform a reset. Without that
reset, I can't find any USB hubs on my bus, rendering the USB controller
useless.

We also only need to reset the line after the phy node has been found.
This way we don't accidently reserve the vbus GPIO pin, but later on
defer the creation of our controller, because the phy device tree node
hasn't been probed yet.

This patch implements the above logic, making EHCI and OHCI work on
Arndale systems for me.

Signed-off-by: Alexander Graf <agraf@suse.de>
CC: Vivek Gautam <gautam.vivek@samsung.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Doug Anderson <dianders@chromium.org>

---

v1 -> v2:

  - remove gpio_free call
  - move reset logic after phy node search

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 20ebf6a..b29b2b8 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -103,9 +103,14 @@ static void s5p_setup_vbus_gpio(struct platform_device *pdev)
 	if (!gpio_is_valid(gpio))
 		return;
 
-	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
-	if (err)
+	/* reset pulls the line down, then up again */
+	err = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, "ehci_vbus_gpio");
+	if (err) {
 		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
+		return;
+	}
+	mdelay(1);
+	__gpio_set_value(gpio, 1);
 }
 
 static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
@@ -131,8 +136,6 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 
-	s5p_setup_vbus_gpio(pdev);
-
 	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
 				GFP_KERNEL);
 	if (!s5p_ehci)
@@ -152,6 +155,8 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		s5p_ehci->otg = phy->otg;
 	}
 
+	s5p_setup_vbus_gpio(pdev);
+
 	s5p_ehci->dev = &pdev->dev;
 
 	hcd = usb_create_hcd(&s5p_ehci_hc_driver, &pdev->dev,
