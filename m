Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaHSI6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:58:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15198 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaHSI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:58:34 -0400
X-AuditID: cbfee61a-f79e46d00000134f-da-53f311b821d9
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH RESEND v3 06/12] usb: dwc2/gadget: ensure that all fifos have
 correct memory buffers
Date: Tue, 19 Aug 2014 10:54:12 +0200
Message-id: <1408438458-3317-7-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
References: <1408438458-3317-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQd0dgp+DDabtlbWY9bKdxeLg/XqL
	5sXr2Swu75rDZrFoWSuzxdojd9ktHj3cymrx4PBOdgcOj/1z17B79G1ZxeixZf9nRo/jN7Yz
	eXzeJBfAGsVlk5Kak1mWWqRvl8CV8e6hUcFE4YqWJRdYGxg38XcxcnJICJhIPHt3hg3CFpO4
	cG89kM3FISQwnVHi0b33jBBOO5PErxn9TCBVbAI6Elu+T2AEsUUE5CWub7zJAlLELHCIUeLV
	nWNgRcICaRInj81n72Lk4GARUJW41O8PYvIKuEjs+y4IsUwOqGIyK4jNKeAq8XbfLHYQWwio
	ZHPrGbYJjLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH1jOpHYwrGywOMQpwMCrx
	8Cp8+RgsxJpYVlyZC3QLB7OSCK/ji0/BQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmk
	J5akZqemFqQWwWSZODilGhiPz3/xx90ibm3f1WtiCt/K9Ny9J27vOtGy3kOS+fntq0I5MRZi
	y368cOC657zHYHbEGXWN2Gt/muUnm5/yFY1i+vWW0V/j/+LnDod6HnTf5fzdYXyBq/9rrMsm
	CyWm5/pbuh4K7T4SE5ncdNbs1/Kii7OcnNhv1HC6CJznZPaQqeWq/h15TEKJpTgj0VCLuag4
	EQD+fMW4KQIAAA==
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
index 6d20ae9..3faa4f3 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -192,6 +192,8 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
 	for (ep = 1; ep <= 15; ep++) {
 		val = addr;
 		val |= size << FIFOSIZE_DEPTH_SHIFT;
+		WARN_ONCE(addr + size > hsotg->fifo_mem,
+			  "insufficient fifo memory");
 		addr += size;
 
 		writel(val, hsotg->regs + DPTXFSIZN(ep));
@@ -3029,19 +3031,22 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
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
@@ -3492,8 +3497,8 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	s3c_hsotg_phy_enable(hsotg);
 
 	s3c_hsotg_corereset(hsotg);
-	s3c_hsotg_init(hsotg);
 	s3c_hsotg_hw_cfg(hsotg);
+	s3c_hsotg_init(hsotg);
 
 	/* hsotg->num_of_eps holds number of EPs other than ep0 */
 
-- 
1.9.1

