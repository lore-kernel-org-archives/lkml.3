Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaEJMAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:00:25 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50978 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbaEJMAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:00:23 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, thierry.reding@gmail.com,
        shc_work@mail.ru, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2 1/6] usb: host: ehci-exynos: Use devm_ioremap_resource instead of devm_ioremap
Date: Sat, 10 May 2014 17:30:05 +0530
Message-Id: <1399723210-21569-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
References: <1399723210-21569-1-git-send-email-gautam.vivek@samsung.com>
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
 drivers/usb/host/ehci-exynos.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index 7f425ac..c23a6d9 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -135,10 +135,9 @@ skip_phy:
 
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
-	hcd->regs = devm_ioremap(&pdev->dev, res->start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		dev_err(&pdev->dev, "Failed to remap I/O memory\n");
-		err = -ENOMEM;
+	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hcd->regs)) {
+		err = PTR_ERR(hcd->regs);
 		goto fail_io;
 	}
 
-- 
1.7.10.4

