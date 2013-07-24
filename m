Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab3GXJ03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 05:26:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:39177 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3GXJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 05:26:27 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH] PCI: update NumVFs register properly during enable/disable sriov
Date: Wed, 24 Jul 2013 17:26:12 +0800
Message-ID: <1374657972-2456-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we only update NumVFs register during sriov_enable().
This register should also be updated properly during sriov_disable.
Otherwise, we will get the stale "Number of VFs" info from lspci.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/iov.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index de8ffac..6e4844b 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -286,7 +286,6 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 	    (!(iov->cap & PCI_SRIOV_CAP_VFM) && (nr_virtfn > initial)))
 		return -EINVAL;
 
-	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_OFFSET, &offset);
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_STRIDE, &stride);
 	if (!offset || (nr_virtfn > 1 && !stride))
@@ -334,6 +333,7 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 			return rc;
 	}
 
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, nr_virtfn);
 	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
@@ -368,6 +368,7 @@ failed:
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, 0);
 	ssleep(1);
 	pci_cfg_access_unlock(dev);
 
@@ -401,6 +402,7 @@ static void sriov_disable(struct pci_dev *dev)
 		sysfs_remove_link(&dev->dev.kobj, "dep_link");
 
 	iov->num_VFs = 0;
+	pci_write_config_word(dev, iov->pos + PCI_SRIOV_NUM_VF, 0);
 }
 
 static int sriov_init(struct pci_dev *dev, int pos)
-- 
1.7.1


