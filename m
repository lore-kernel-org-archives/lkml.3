Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaEJJ5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 05:57:38 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53363 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaEJJ5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 05:57:34 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, thierry.reding@gmail.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 5/6] usb: host: ehci-tegra: Use devm_ioremap_resource instead of devm_ioremap
Date: Sat, 10 May 2014 15:27:02 +0530
Message-Id: <1399715823-19839-6-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
References: <1399715823-19839-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using devm_ioremap_resource() API should actually be preferred over
devm_ioremap(), since the former request the mem region first and then
gives back the ioremap'ed memory pointer.
devm_ioremap_resource() calls request_mem_region(), therby preventing
other drivers to make any overlapping call to the same region.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/host/ehci-tegra.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
index 572634c..ccc6433 100644
--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -411,9 +411,8 @@ static int tegra_ehci_probe(struct platform_device *pdev)
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	hcd->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (!hcd->regs) {
-		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
 		err = -ENOMEM;
 		goto cleanup_clk_en;
 	}
-- 
1.7.10.4

