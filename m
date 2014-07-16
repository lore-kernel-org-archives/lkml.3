Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaGPKXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:23:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18030 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758894AbaGPKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:23:06 -0400
X-AuditID: cbfee61a-f79e46d00000134f-85-53c65288ba7e
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 06/12] usb: dwc2/gadget: ensure that all fifos have correct
 memory buffers
Date: Wed, 16 Jul 2014 12:22:24 +0200
Message-id: <1405506150-16185-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
References: <1405506150-16185-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd3OoGPBBnPms1jMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZYu2Ru+wW26dMZ7J4cHgnuwOHx/65a9g9+rasYvTYsv8zo8fxG9uZ
	PD5vkgtgjeKySUnNySxLLdK3S+DK+DCni61gonDF34WTmBoYN/F3MXJySAiYSHzf+ZcZwhaT
	uHBvPVsXIxeHkMB0RomvS+6yQjjtTBLn1nezgVSxCehIbPk+gRHEFhEQkFj/4hI7SBGzwAlG
	iY7/F8CKhAXiJSY+/skCYrMIqEqs3bYKaAUHB6+Aq8SSR4kQ2+QkTh6bzApicwq4Sax53cwO
	YgsBlRxft4xpAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjB4fVMagfjygaLQ4wC
	HIxKPLwbQo4GC7EmlhVX5h5ilOBgVhLhdfA/FizEm5JYWZValB9fVJqTWnyIUZqDRUmc90Cr
	daCQQHpiSWp2ampBahFMlomDU6qBcfPsX7qJ3iVbLaNqzZ3dezYcmFFfrhup2TqjI7fcpMou
	5fGrH1r7Z6/6qD7L6V5ytpzp/7MPTOKTk6YvvX69WUz51j7H38qPJHNd7b5lsnh9Fanb+J5T
	/22XUL3hlmv/pKzf3ZA1dP6bLKTbox+YYqbdKVK32cxPVu+KxLPKL05+PBJpH6qUWIozEg21
	mIuKEwFZ1KzFKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

Print warning if FIFOs are configured in such a way that they don't fit
into the SPRAM available on the s3c hsotg module.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/usb/dwc2/core.h   |  1 +
 drivers/usb/dwc2/gadget.c | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 1efd10c..067390e 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -194,6 +194,7 @@ struct s3c_hsotg {
 	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
 
 	u32                     phyif;
+	int			fifo_mem;
 	unsigned int            dedicated_fifos:1;
 	unsigned char           num_of_eps;
 
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 95b6dcb..21d21de 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -194,6 +194,8 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
 	for (ep = 1; ep <= 15; ep++) {
 		val = addr;
 		val |= size << FIFOSIZE_DEPTH_SHIFT;
+		WARN_ONCE(addr + size > hsotg->fifo_mem,
+			  "insufficient fifo memory");
 		addr += size;
 
 		writel(val, hsotg->regs + DPTXFSIZN(ep));
@@ -3030,19 +3032,22 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
  */
 static void s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
 {
-	u32 cfg2, cfg4;
+	u32 cfg2, cfg3, cfg4;
 	/* check hardware configuration */
 
 	cfg2 = readl(hsotg->regs + 0x48);
 	hsotg->num_of_eps = (cfg2 >> 10) & 0xF;
 
-	dev_info(hsotg->dev, "EPs:%d\n", hsotg->num_of_eps);
+	cfg3 = readl(hsotg->regs + 0x4C);
+	hsotg->fifo_mem = (cfg3 >> 16);
 
 	cfg4 = readl(hsotg->regs + 0x50);
 	hsotg->dedicated_fifos = (cfg4 >> 25) & 1;
 
-	dev_info(hsotg->dev, "%s fifos\n",
-		 hsotg->dedicated_fifos ? "dedicated" : "shared");
+	dev_info(hsotg->dev, "EPs: %d, %s fifos, %d entries in SPRAM\n",
+		 hsotg->num_of_eps,
+		 hsotg->dedicated_fifos ? "dedicated" : "shared",
+		 hsotg->fifo_mem);
 }
 
 /**
@@ -3495,8 +3500,8 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	s3c_hsotg_phy_enable(hsotg);
 
 	s3c_hsotg_corereset(hsotg);
-	s3c_hsotg_init(hsotg);
 	s3c_hsotg_hw_cfg(hsotg);
+	s3c_hsotg_init(hsotg);
 
 	/* hsotg->num_of_eps holds number of EPs other than ep0 */
 
-- 
1.9.1

