Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab3DBBxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 21:53:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:7883 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3DBBxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 21:53:19 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH -v2] PCI/VFIO: use pcie_flags_reg instead of access PCI-E Capabilities Register
Date: Tue, 2 Apr 2013 09:52:27 +0800
Message-ID: <1364867547-15300-1-git-send-email-wangyijing@huawei.com>
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
use pcie_caps_reg() instead of another access PCI-E Capabilities Register.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/vfio/pci/vfio_pci_config.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index aeb00fc..12a81f7 100644
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
+		if ((pcie_caps_reg(pdev) & PCI_EXP_FLAGS_VERS) == 1)
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
 		else
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;
-- 
1.7.1


