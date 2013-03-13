Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3CMB4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:56:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab3CMB4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:56:09 -0400
From: Alexander Graf <agraf@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] USB: ehci-s5p: Fix phy reset
Date: Wed, 13 Mar 2013 02:09:48 +0100
Message-Id: <1363136988-3704-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Exynos 5 based Arndale system, I need to pull the reset line down
and then let it go up again to actually perform a reset. Without that
reset, I can't find any USB hubs on my bus, rendering the USB controller
useless.

So this patch implements the above logic, making EHCI and OHCI work on
Arndale systems for me.

Signed-off-by: Alexander Graf <agraf@suse.de>
CC: Vivek Gautam <gautam.vivek@samsung.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

As this affects 3.9, this patch should definitely be considered for inclusion
there.
---
 drivers/usb/host/ehci-s5p.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 20ebf6a..c6d67e4 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -103,9 +103,15 @@ static void s5p_setup_vbus_gpio(struct platform_device *pdev)
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
+	gpio_free(gpio);
 }
 
 static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
-- 
1.7.12.4

