Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbbATVuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:50:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:8541 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbATVuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:50:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,437,1418112000"; 
   d="scan'208";a="673066798"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/4] x86: pmc_atom: save struct device pointer in pmc
Date: Tue, 20 Jan 2015 23:50:00 +0200
Message-Id: <1421790603-30097-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421790603-30097-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The change allows to use dev_printk() type of macros in the module functions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/kernel/pmc_atom.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index d66a4fe..d338222 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -26,6 +26,7 @@
 #include <asm/pmc_atom.h>
 
 struct pmc_dev {
+	struct device *dev;
 	u32 base_addr;
 	void __iomem *regmap;
 #ifdef CONFIG_DEBUG_FS
@@ -250,7 +251,7 @@ static void pmc_dbgfs_unregister(struct pmc_dev *pmc)
 	debugfs_remove_recursive(pmc->dbgfs_dir);
 }
 
-static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
+static int pmc_dbgfs_register(struct pmc_dev *pmc)
 {
 	struct dentry *dir, *f;
 
@@ -263,21 +264,21 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 	f = debugfs_create_file("dev_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_dev_state_ops);
 	if (!f) {
-		dev_err(&pdev->dev, "dev_state register failed\n");
+		dev_err(pmc->dev, "dev_state register failed\n");
 		goto err;
 	}
 
 	f = debugfs_create_file("pss_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_pss_state_ops);
 	if (!f) {
-		dev_err(&pdev->dev, "pss_state register failed\n");
+		dev_err(pmc->dev, "pss_state register failed\n");
 		goto err;
 	}
 
 	f = debugfs_create_file("sleep_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_sleep_tmr_ops);
 	if (!f) {
-		dev_err(&pdev->dev, "sleep_state register failed\n");
+		dev_err(pmc->dev, "sleep_state register failed\n");
 		goto err;
 	}
 
@@ -287,7 +288,7 @@ err:
 	return -ENODEV;
 }
 #else
-static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
+static int pmc_dbgfs_register(struct pmc_dev *pmc)
 {
 	return 0;
 }
@@ -315,10 +316,12 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 		return -ENOMEM;
 	}
 
+	pmc->dev = &pdev->dev;
+
 	/* PMC hardware registers setup */
 	pmc_hw_reg_setup(pmc);
 
-	ret = pmc_dbgfs_register(pmc, pdev);
+	ret = pmc_dbgfs_register(pmc);
 	if (ret) {
 		iounmap(pmc->regmap);
 	}
-- 
2.1.4

