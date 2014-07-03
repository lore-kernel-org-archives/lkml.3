Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbaGCNYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:24:18 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49921 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbaGCNXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:09 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 05/11] MIPS: Alchemy: pci: use clk framework to enable PCI clock
Date: Thu,  3 Jul 2014 15:22:36 +0200
Message-Id: <1404393762-858019-6-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the clock framework to get at the PCI clock source and enable
it on driver initialization.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 arch/mips/pci/pci-alchemy.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/mips/pci/pci-alchemy.c b/arch/mips/pci/pci-alchemy.c
index 912c5f2..adc810f 100644
--- a/arch/mips/pci/pci-alchemy.c
+++ b/arch/mips/pci/pci-alchemy.c
@@ -7,6 +7,7 @@
  * Support for all devices (greater than 16) added by David Gathright.
  */
 
+#include <linux/clk.h>
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/pci.h>
@@ -365,6 +366,7 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 	void __iomem *virt_io;
 	unsigned long val;
 	struct resource *r;
+	struct clk *c;
 	int ret;
 
 	/* need at least PCI IRQ mapping table */
@@ -394,11 +396,24 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 		goto out1;
 	}
 
+	c = clk_get(&pdev->dev, "pci_clko");
+	if (IS_ERR(c)) {
+		dev_err(&pdev->dev, "unable to find PCI clock\n");
+		ret = PTR_ERR(c);
+		goto out2;
+	}
+	ret = clk_prepare_enable(c);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot enable PCI clock\n");
+		clk_put(c);
+		goto out2;
+	}
+
 	ctx->regs = ioremap_nocache(r->start, resource_size(r));
 	if (!ctx->regs) {
 		dev_err(&pdev->dev, "cannot map pci regs\n");
 		ret = -ENODEV;
-		goto out2;
+		goto out5;
 	}
 
 	/* map parts of the PCI IO area */
@@ -466,12 +481,18 @@ static int alchemy_pci_probe(struct platform_device *pdev)
 	register_syscore_ops(&alchemy_pci_pmops);
 	register_pci_controller(&ctx->alchemy_pci_ctrl);
 
+	dev_info(&pdev->dev, "PCI controller at %ld MHz\n",
+		 clk_get_rate(c) / 1000000);
+
 	return 0;
 
 out4:
 	iounmap(virt_io);
 out3:
 	iounmap(ctx->regs);
+out5:
+	clk_disable_unprepare(c);
+	clk_put(c);
 out2:
 	release_mem_region(r->start, resource_size(r));
 out1:
-- 
2.0.0

