Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaEOKS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 06:18:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54456 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754523AbaEOKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 06:18:26 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v6 02/17] usb: ehci-orion: rename error goto labels in ehci_orion_drv_probe()
Date: Thu, 15 May 2014 12:17:27 +0200
Message-Id: <1400149062-32661-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
References: <1400149062-32661-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

In preparation to the introduction of additional initialization steps
in ehci_orion_drv_probe(), we rename the error goto labels from err1,
err2 and err3 names to some more meaningful names.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-orion.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ehci-orion.c b/drivers/usb/host/ehci-orion.c
index 7728e83007a7..9298be7c0f9b 100644
--- a/drivers/usb/host/ehci-orion.c
+++ b/drivers/usb/host/ehci-orion.c
@@ -160,7 +160,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 			"Found HC with no IRQ. Check %s setup!\n",
 			dev_name(&pdev->dev));
 		err = -ENODEV;
-		goto err1;
+		goto err;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -169,7 +169,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 			"Found HC with no register addr. Check %s setup!\n",
 			dev_name(&pdev->dev));
 		err = -ENODEV;
-		goto err1;
+		goto err;
 	}
 
 	/*
@@ -179,12 +179,12 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 	 */
 	err = dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
-		goto err1;
+		goto err;
 
 	regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(regs)) {
 		err = PTR_ERR(regs);
-		goto err1;
+		goto err;
 	}
 
 	/* Not all platforms can gate the clock, so it is not
@@ -197,7 +197,7 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 			&pdev->dev, dev_name(&pdev->dev));
 	if (!hcd) {
 		err = -ENOMEM;
-		goto err2;
+		goto err_create_hcd;
 	}
 
 	hcd->rsrc_start = res->start;
@@ -237,17 +237,17 @@ static int ehci_orion_drv_probe(struct platform_device *pdev)
 
 	err = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (err)
-		goto err3;
+		goto err_add_hcd;
 
 	device_wakeup_enable(hcd->self.controller);
 	return 0;
 
-err3:
+err_add_hcd:
 	usb_put_hcd(hcd);
-err2:
+err_create_hcd:
 	if (!IS_ERR(clk))
 		clk_disable_unprepare(clk);
-err1:
+err:
 	dev_err(&pdev->dev, "init %s fail, %d\n",
 		dev_name(&pdev->dev), err);
 
-- 
1.8.1.2

