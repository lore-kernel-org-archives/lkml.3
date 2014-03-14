Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaCNKAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:00:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:28334 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaCNKAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,653,1389772800"; 
   d="scan'208";a="491842100"
From: Chew Chiau Ee <chiau.ee.chew@intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Lim Lee Booi <lee.booi.lim@intel.com>
Subject: [PATCH v2] dma: dw: Add suspend and resume handling for PCI mode DW_DMAC.
Date: Sat, 15 Mar 2014 02:02:39 +0800
Message-Id: <1394820159-562-1-git-send-email-chiau.ee.chew@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chew, Chiau Ee <chiau.ee.chew@intel.com>

This is to disable/enable DW_DMAC hw during late suspend/early resume.
Since DMA is providing service to other clients (eg: SPI, HSUART),
we need to ensure DMA suspends after the clients and resume
before the clients are active.

Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
---
 v2 changelog:
 * Change suspend_noirq and resume_noirq callback to suspend_late
   and resume_early.

 drivers/dma/dw/pci.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
index 755cc6b..fec59f1 100644
--- a/drivers/dma/dw/pci.c
+++ b/drivers/dma/dw/pci.c
@@ -75,6 +75,36 @@ static void dw_pci_remove(struct pci_dev *pdev)
 		dev_warn(&pdev->dev, "can't remove device properly: %d\n", ret);
 }
 
+#ifdef CONFIG_PM_SLEEP
+
+static int dw_pci_suspend_late(struct device *dev)
+{
+	struct pci_dev *pci = to_pci_dev(dev);
+	struct dw_dma_chip *chip = pci_get_drvdata(pci);
+
+	return dw_dma_suspend(chip);
+};
+
+static int dw_pci_resume_early(struct device *dev)
+{
+	struct pci_dev *pci = to_pci_dev(dev);
+	struct dw_dma_chip *chip = pci_get_drvdata(pci);
+
+	return dw_dma_resume(chip);
+};
+
+#else /* !CONFIG_PM_SLEEP */
+
+#define dw_pci_suspend_late	NULL
+#define dw_pci_resume_early	NULL
+
+#endif /* !CONFIG_PM_SLEEP */
+
+static const struct dev_pm_ops dw_pci_dev_pm_ops = {
+	.suspend_late = dw_pci_suspend_late,
+	.resume_early = dw_pci_resume_early,
+};
+
 static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
 	/* Medfield */
 	{ PCI_VDEVICE(INTEL, 0x0827), (kernel_ulong_t)&dw_pci_pdata },
@@ -95,6 +125,9 @@ static struct pci_driver dw_pci_driver = {
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

