Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaCNBpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 21:45:21 -0400
Received: from mailout.micron.com ([137.201.242.129]:41849 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaCNBpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 21:45:20 -0400
Message-ID: <53225F2B.4020709@micron.com>
Date: Thu, 13 Mar 2014 18:45:15 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on
 AMD systems
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20564.002
X-TM-AS-Result: No--3.573100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A hardware quirk in P320h/P420m interfere with PCIe transactions on some
AMD chipsets, making P320h/P420m unusable. This workaround is to disable
ERO and NoSnoop bits in the parent and root complex for normal functioning
of these devices

NOTE: This workaround is specific to AMD chipset with a PCIe upstream
device with device id 0x5aXX

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   53 +++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 624e9d9..8c462d3 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4479,6 +4479,57 @@ static DEFINE_HANDLER(5);
 static DEFINE_HANDLER(6);
 static DEFINE_HANDLER(7);
 
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
@@ -4630,6 +4681,8 @@ static int mtip_pci_probe(struct pci_dev *pdev,
 		goto msi_initialize_err;
 	}
 
+	mtip_fix_ero_nosnoop(dd, pdev);
+
 	/* Initialize the block layer. */
 	rv = mtip_block_initialize(dd);
 	if (rv < 0) {
-- 
1.7.1

