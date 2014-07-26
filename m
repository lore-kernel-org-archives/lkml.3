Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbaGZCoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:07 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6657 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaGZCnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:49 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 05/11] PCI/MSI: Move populate_msi_sysfs() out of msi_capability_init()
Date: Sat, 26 Jul 2014 11:08:42 +0800
Message-ID: <1406344128-27055-6-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because some Non-PCI devices don't need to create sysfs object,
so move populate_msi_sysfs() out of generic MSI function
msi/x_capability_init().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/msi.c |   31 ++++++++++++++++++-------------
 1 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 116383c..21b16e0 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -646,13 +646,6 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 		return ret;
 	}
 
-	ret = populate_msi_sysfs(dev);
-	if (ret) {
-		msi_mask_irq(entry, mask, ~mask);
-		free_msi_irqs(dev);
-		return ret;
-	}
-
 	/* Set MSI enabled bits	 */
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 1);
@@ -760,10 +753,6 @@ static int msix_capability_init(struct pci_dev *dev, void __iomem *base,
 
 	msix_program_entries(dev, entries);
 
-	ret = populate_msi_sysfs(dev);
-	if (ret)
-		goto out_free;
-
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
 	dev->msix_enabled = 1;
@@ -789,7 +778,6 @@ out_avail:
 			ret = avail;
 	}
 
-out_free:
 	free_msi_irqs(dev);
 
 	return ret;
@@ -939,7 +927,7 @@ EXPORT_SYMBOL(pci_msix_vec_count);
 int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 {
 	int status, nr_entries;
-	int i, j;
+	int i, j, ret;
 	void __iomem *base;
 	u16 control;
 
@@ -980,6 +968,14 @@ int pci_enable_msix(struct pci_dev *dev, struct msix_entry *entries, int nvec)
 		return -ENOMEM;
 
 	status = msix_capability_init(dev, base, entries, nvec);
+	if (!status) {
+		ret = populate_msi_sysfs(dev);
+		if (ret) {
+			dev->msix_enabled = 0;
+			pci_intx_for_msi(dev, 1);
+			free_msi_irqs(dev);
+		}
+	}
 	return status;
 }
 EXPORT_SYMBOL(pci_enable_msix);
@@ -1109,6 +1105,15 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 		}
 	} while (rc);
 
+	rc = populate_msi_sysfs(dev);
+	if (rc) {
+		msi_set_enable(dev, 0);
+		pci_intx_for_msi(dev, 1);
+		dev->msi_enabled = 0;
+		free_msi_irqs(dev);
+		return rc;
+	}
+
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msi_range);
-- 
1.7.1

