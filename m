Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab3HHNJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:09:47 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19805 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934238Ab3HHNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:09:46 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Jon Mason <jon.mason@intel.com>
CC: Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/16] ntb: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:09:34 +0800
Message-ID: <1375967374-28704-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org
---
 drivers/ntb/ntb_hw.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 2dacd19..090d1b2 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -758,16 +758,15 @@ static int ntb_setup_msix(struct ntb_device *ndev)
 	struct pci_dev *pdev = ndev->pdev;
 	struct msix_entry *msix;
 	int msix_entries;
-	int rc, i, pos;
+	int rc, i;
 	u16 val;
 
-	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
-	if (!pos) {
+	if (!pdev->msix_cap) {
 		rc = -EIO;
 		goto err;
 	}
 
-	rc = pci_read_config_word(pdev, pos + PCI_MSIX_FLAGS, &val);
+	rc = pci_read_config_word(pdev, pdev->msix_cap + PCI_MSIX_FLAGS, &val);
 	if (rc)
 		goto err;
 
-- 
1.7.1


