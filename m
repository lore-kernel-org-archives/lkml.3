Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKDCWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:22:30 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:64386 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaKDCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:22:19 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkabhadram@gmail.com>, Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 05/27] host: ohci-at91: remove duplicate check on resource
Date: Tue,  4 Nov 2014 07:51:12 +0530
Message-Id: <1415067694-9473-6-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
References: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkabhadram@gmail.com>

Sanity check on resource happening with devm_ioremap_resource().

Signed-off-by: Varka Bhadram <varkab@cdac.in>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-at91.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 6181549..3940660 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -133,12 +133,6 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	struct resource *res;
 	int irq;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_dbg(dev, "hcd probe: missing memory resource\n");
-		return -ENXIO;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_dbg(dev, "hcd probe: missing irq resource\n");
@@ -148,14 +142,15 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	hcd = usb_create_hcd(driver, dev, "at91");
 	if (!hcd)
 		return -ENOMEM;
-	hcd->rsrc_start = res->start;
-	hcd->rsrc_len = resource_size(res);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	hcd->regs = devm_ioremap_resource(dev, res);
 	if (IS_ERR(hcd->regs)) {
 		retval = PTR_ERR(hcd->regs);
 		goto err;
 	}
+	hcd->rsrc_start = res->start;
+	hcd->rsrc_len = resource_size(res);
 
 	iclk = devm_clk_get(dev, "ohci_clk");
 	if (IS_ERR(iclk)) {
-- 
1.7.9.5

