Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaBDMhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:37:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:4547 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaBDMhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:37:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,779,1384329600"; 
   d="scan'208";a="477777430"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        xinhuix.pan@intel.com, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] i2c: designware-pci: Cleanup driver power management
Date: Tue,  4 Feb 2014 14:37:07 +0200
Message-Id: <1391517427-16204-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI part of the DesignWare I2C driver does a lot of things that are not
required anymore. For example drivers aren't supposed to handle PCI state
transitions themselves. This is all provided by the PCI bus core already.

In addition to that there is no point scheduling RPM suspend on driver's
idle hook but instead we can use RPM autosuspend for this (which is enabled
in the driver already).

As a bonus, this patch also fixes following compile warning which is
emitted when the driver was compiled without CONFIG_PM_RUNTIME set:

drivers/i2c/busses/i2c-designware-pcidrv.c:245:12: warning: ‘i2c_dw_pci_runtime_idle’ defined but not used [-Wunused-function]

Reported-by: xinhui.pan <xinhuix.pan@intel.com>
Reported-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 57 ++++--------------------------
 1 file changed, 7 insertions(+), 50 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index f6ed06c966ee..c0a87a5eb63e 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -138,69 +138,25 @@ static struct i2c_algorithm i2c_dw_algo = {
 	.functionality	= i2c_dw_func,
 };
 
+#ifdef CONFIG_PM
 static int i2c_dw_pci_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
-	struct dw_i2c_dev *i2c = pci_get_drvdata(pdev);
-	int err;
-
-
-	i2c_dw_disable(i2c);
-
-	err = pci_save_state(pdev);
-	if (err) {
-		dev_err(&pdev->dev, "pci_save_state failed\n");
-		return err;
-	}
-
-	err = pci_set_power_state(pdev, PCI_D3hot);
-	if (err) {
-		dev_err(&pdev->dev, "pci_set_power_state failed\n");
-		return err;
-	}
 
+	i2c_dw_disable(pci_get_drvdata(pdev));
 	return 0;
 }
 
 static int i2c_dw_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
-	struct dw_i2c_dev *i2c = pci_get_drvdata(pdev);
-	int err;
-	u32 enabled;
-
-	enabled = i2c_dw_is_enabled(i2c);
-	if (enabled)
-		return 0;
-
-	err = pci_set_power_state(pdev, PCI_D0);
-	if (err) {
-		dev_err(&pdev->dev, "pci_set_power_state() failed\n");
-		return err;
-	}
 
-	pci_restore_state(pdev);
-
-	i2c_dw_init(i2c);
-	return 0;
+	return i2c_dw_init(pci_get_drvdata(pdev));
 }
+#endif
 
-static int i2c_dw_pci_runtime_idle(struct device *dev)
-{
-	int err = pm_schedule_suspend(dev, 500);
-	dev_dbg(dev, "runtime_idle called\n");
-
-	if (err != 0)
-		return 0;
-	return -EBUSY;
-}
-
-static const struct dev_pm_ops i2c_dw_pm_ops = {
-	.resume         = i2c_dw_pci_resume,
-	.suspend        = i2c_dw_pci_suspend,
-	SET_RUNTIME_PM_OPS(i2c_dw_pci_suspend, i2c_dw_pci_resume,
-			   i2c_dw_pci_runtime_idle)
-};
+static UNIVERSAL_DEV_PM_OPS(i2c_dw_pm_ops, i2c_dw_pci_suspend,
+			    i2c_dw_pci_resume, NULL);
 
 static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
 {
@@ -290,6 +246,7 @@ static int i2c_dw_pci_probe(struct pci_dev *pdev,
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
 	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
 	pm_runtime_allow(&pdev->dev);
 
 	return 0;
-- 
1.8.5.2

