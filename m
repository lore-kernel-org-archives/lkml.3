Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaIIIrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:47:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65080 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbaIIIpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:45:22 -0400
X-AuditID: cbfee61a-f79e46d00000134f-1d-540ebe20ebfd
From: Robert Baldyga <r.baldyga@samsung.com>
To: Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 4/6] usb: dwc2/gadget: ensure that all fifos have correct
 memory buffers
Date: Tue, 09 Sep 2014 10:44:55 +0200
Message-id: <1410252297-13738-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jQV2FfXwhBs1ztC0O3q+3aF68ns3i
	8q45bBaLlrUyW6w9cpfd4tHDrawWDw7vZHdg99g/dw27R9+WVYweW/Z/ZvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGf2nF7IVbBSumNhwhq2B8SJ/FyMnh4SAicTDy60sELaYxIV769m6
	GLk4hASmM0p0rtjHCuG0M0msfXKEEaSKTUBHYsv3CWC2iIC8xPWNN1lAipgF9jFKTP+0jR0k
	ISwQJXFz02RWEJtFQFXi/4M1zCA2r4CrxKp125gg1slJnDwGUcMp4Cbx59gXsF4hoJp/c6ax
	TGDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKyeSe1gXNlgcYhRgINRiYc3I5gv
	RIg1say4MvcQowQHs5II75XdQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNT
	UwtSi2CyTBycUg2M0i6ZX09t5Y3xCg/cJrhbmXdR3Sfzck/R1z+0f/RJtS59yqN4pcJ/xvb+
	Y83qdd8E967rOfsrqeb/xy/b/CVWhr1X1vT73K5+js9Occ6Zr+vX/+k/kmIzL9vV5+jVQ7qH
	Tx/6f/trJOua23/K73xTUNhdv9Ax4Y35NNGsNba/fHdKBTt/3/b5iRJLcUaioRZzUXEiAIqP
	wv8nAgAA
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
index f63858a..bd58756 100644
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
@@ -3485,8 +3490,8 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	s3c_hsotg_phy_enable(hsotg);
 
 	s3c_hsotg_corereset(hsotg);
-	s3c_hsotg_init(hsotg);
 	s3c_hsotg_hw_cfg(hsotg);
+	s3c_hsotg_init(hsotg);
 
 	ret = devm_request_irq(&pdev->dev, hsotg->irq, s3c_hsotg_irq, 0,
 				dev_name(dev), hsotg);
-- 
1.9.1

