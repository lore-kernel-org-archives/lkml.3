Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbaLOO2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:28:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38704 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaLOO2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 102/168] PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
Date: Mon, 15 Dec 2014 14:25:56 +0000
Message-Id: <1418653622-21105-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit f144d1496b47e7450f41b767d0d91c724c2198bc upstream.

This can be set by quirks/drivers to be used by the architecture code
that assigns the MSI addresses.

We additionally add verification in the core MSI code that the values
assigned by the architecture do satisfy the limitation in order to fail
gracefully if they don't (ie. the arch hasn't been updated to deal with
that quirk yet).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/msi.c   | 26 ++++++++++++++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 13f3d3037272..1d6c61ad7da7 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -594,6 +594,20 @@ error_attrs:
 	return ret;
 }
 
+static int msi_verify_entries(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		if (!dev->no_64bit_msi || !entry->msg.address_hi)
+			continue;
+		dev_err(&dev->dev, "Device has broken 64-bit MSI but arch"
+			" tried to assign one above 4G\n");
+		return -EIO;
+	}
+	return 0;
+}
+
 /**
  * msi_capability_init - configure device's MSI capability structure
  * @dev: pointer to the pci_dev data structure of MSI device function
@@ -647,6 +661,13 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 		return ret;
 	}
 
+	ret = msi_verify_entries(dev);
+	if (ret) {
+		msi_mask_irq(entry, mask, ~mask);
+		free_msi_irqs(dev);
+		return ret;
+	}
+
 	ret = populate_msi_sysfs(dev);
 	if (ret) {
 		msi_mask_irq(entry, mask, ~mask);
@@ -762,6 +783,11 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (ret)
 		goto out_avail;
 
+	/* Check if all MSI entries honor device restrictions */
+	ret = msi_verify_entries(dev);
+	if (ret)
+		goto out_free;
+
 	/*
 	 * Some devices require MSI-X to be enabled before we can touch the
 	 * MSI-X registers.  We need to mask all the vectors to prevent
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 97fe7ebf2e25..04fdc409eec6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -331,6 +331,7 @@ struct pci_dev {
 	unsigned int	is_added:1;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
+	unsigned int	no_64bit_msi:1; /* device may only use 32-bit MSIs */
 	unsigned int	block_cfg_access:1;	/* config space access is blocked */
 	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
 	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting variant */
-- 
2.1.3

