Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbaGVWyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:54:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbaGVWWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, Jens Axboe <axboe@fb.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 008/116] mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems
Date: Tue, 22 Jul 2014 15:20:19 -0700
Message-Id: <1406067727-19683-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asai Thambi S P <asamymuthupa@micron.com>

commit d1e714db8129a1d3670e449b87719c78e2c76f9f upstream.

A hardware quirk in P320h/P420m interfere with PCIe transactions on some
AMD chipsets, making P320h/P420m unusable. This workaround is to disable
ERO and NoSnoop bits in the parent and root complex for normal
functioning of these devices

NOTE: This workaround is specific to AMD chipset with a PCIe upstream
device with device id 0x5aXX

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index f01adbc..d2a3f3d 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3968,6 +3968,57 @@ static int mtip_block_resume(struct driver_data *dd)
 	return 0;
 }
 
+static void mtip_disable_link_opts(struct driver_data *dd, struct pci_dev *pdev)
+{
+	int pos;
+	unsigned short pcie_dev_ctrl;
+
+	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	if (pos) {
+		pci_read_config_word(pdev,
+			pos + PCI_EXP_DEVCTL,
+			&pcie_dev_ctrl);
+		if (pcie_dev_ctrl & (1 << 11) ||
+		    pcie_dev_ctrl & (1 << 4)) {
+			dev_info(&dd->pdev->dev,
+				"Disabling ERO/No-Snoop on bridge device %04x:%04x\n",
+					pdev->vendor, pdev->device);
+			pcie_dev_ctrl &= ~(PCI_EXP_DEVCTL_NOSNOOP_EN |
+						PCI_EXP_DEVCTL_RELAX_EN);
+			pci_write_config_word(pdev,
+				pos + PCI_EXP_DEVCTL,
+				pcie_dev_ctrl);
+		}
+	}
+}
+
+static void mtip_fix_ero_nosnoop(struct driver_data *dd, struct pci_dev *pdev)
+{
+	/*
+	 * This workaround is specific to AMD/ATI chipset with a PCI upstream
+	 * device with device id 0x5aXX
+	 */
+	if (pdev->bus && pdev->bus->self) {
+		if (pdev->bus->self->vendor == PCI_VENDOR_ID_ATI &&
+		    ((pdev->bus->self->device & 0xff00) == 0x5a00)) {
+			mtip_disable_link_opts(dd, pdev->bus->self);
+		} else {
+			/* Check further up the topology */
+			struct pci_dev *parent_dev = pdev->bus->self;
+			if (parent_dev->bus &&
+				parent_dev->bus->parent &&
+				parent_dev->bus->parent->self &&
+				parent_dev->bus->parent->self->vendor ==
+					 PCI_VENDOR_ID_ATI &&
+				(parent_dev->bus->parent->self->device &
+					0xff00) == 0x5a00) {
+				mtip_disable_link_opts(dd,
+					parent_dev->bus->parent->self);
+			}
+		}
+	}
+}
+
 /*
  * Called for each supported PCI device detected.
  *
@@ -4029,11 +4080,14 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 		goto block_initialize_err;
 	}
 
+
 	/* Copy the info we may need later into the private data structure. */
 	dd->major	= mtip_major;
 	dd->instance	= instance;
 	dd->pdev	= pdev;
 
+	mtip_fix_ero_nosnoop(dd, pdev);
+
 	/* Initialize the block layer. */
 	rv = mtip_block_initialize(dd);
 	if (rv < 0) {
-- 
1.9.1

