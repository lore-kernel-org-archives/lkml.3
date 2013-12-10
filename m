Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3LJGFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:05:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:43388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab3LJGFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:05:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,863,1378882800"; 
   d="scan'208";a="441481915"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dma: dw: Add suspend and resume handling for PCI mode DW_DMAC.
Date: Tue, 10 Dec 2013 22:06:13 +0800
Message-Id: <1386684373-24753-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

This is to disable/enable DW_DMAC hw during suspend/resume.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/pci.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
index e89fc24..97bc3a2 100644
--- a/drivers/dma/dw/pci.c
+++ b/drivers/dma/dw/pci.c
@@ -75,6 +75,36 @@ static void dw_pci_remove(struct pci_dev *pdev)
 		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);
 }
 
+#ifdef CONFIG_PM_SLEEP
+
+static int dw_pci_suspend_noirq(struct device *dev)
+{
+	struct pci_dev *pci = to_pci_dev(dev);
+	struct dw_dma_chip *chip = pci_get_drvdata(pci);
+
+	return dw_dma_suspend(chip);
+};
+
+static int dw_pci_resume_noirq(struct device *dev)
+{
+	struct pci_dev *pci = to_pci_dev(dev);
+	struct dw_dma_chip *chip = pci_get_drvdata(pci);
+
+	return dw_dma_resume(chip);
+};
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define dw_pci_suspend_noirq	NULL
+#define dw_pci_resume_noirq	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops dw_pci_dev_pm_ops = {
+	.suspend_noirq = dw_pci_suspend_noirq,
+	.resume_noirq = dw_pci_resume_noirq,
+};
+
 static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
 	/* Medfield */
 	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata },
@@ -92,6 +122,9 @@ static struct pci_driver dw_pci_driver = {
 	.id_table	= dw_pci_id_table,
 	.probe		= dw_pci_probe,
 	.remove		= dw_pci_remove,
+	.driver	= {
+		.pm	= &dw_pci_dev_pm_ops,
+	},
 };
 
 module_pci_driver(dw_pci_driver);
-- 
1.7.4.4

