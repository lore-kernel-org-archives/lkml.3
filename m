Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3C0JGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:06:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:52688 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3C0JGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:06:08 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH] PCI/VFIO: use pcie_flags_reg instead of access PCI-E Capabilities Register
Date: Wed, 27 Mar 2013 17:05:40 +0800
Message-ID: <1364375140-6388-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use pcie_flags_reg to cache PCI-E Capabilities Register,
because PCI-E Capabilities Register bits are almost read-only. This patch
use pcie_flags_reg instead of another access PCI-E Capabilities Register.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/vfio/pci/vfio_pci_config.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index aeb00fc..afc6ca4 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1017,13 +1017,9 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 		return byte;
 	case PCI_CAP_ID_EXP:
 		/* length based on version */
-		ret = pci_read_config_word(pdev, pos + PCI_EXP_FLAGS, &word);
-		if (ret)
-			return pcibios_err_to_errno(ret);
-
 		vdev->extended_caps = true;
 
-		if ((word & PCI_EXP_FLAGS_VERS) == 1)
+		if ((pdev->pcie_flags_reg & PCI_EXP_FLAGS_VERS) == 1)
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
 		else
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;
-- 
1.7.1


