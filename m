Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaLFPLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:11:49 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47763 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752310AbaLFPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 19/66] PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
Date: Sat,  6 Dec 2014 16:07:11 +0100
Message-Id: <5545f8b0fca9fa9efe65d8084dbb536aebabdb61.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f144d1496b47e7450f41b767d0d91c724c2198bc upstream.

This can be set by quirks/drivers to be used by the architecture code
that assigns the MSI addresses.

We additionally add verification in the core MSI code that the values
assigned by the architecture do satisfy the limitation in order to fail
gracefully if they don't (ie. the arch hasn't been updated to deal with
that quirk yet).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/msi.c   | 26 ++++++++++++++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b43f391dc8b6..89237c8eab1d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -553,6 +553,20 @@ out_unroll:
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
@@ -606,6 +620,13 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
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
@@ -721,6 +742,11 @@ static int msix_capability_init(struct pci_dev *dev,
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
index db4ce115705e..573c04929bd1 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -323,6 +323,7 @@ struct pci_dev {
 	unsigned int	is_added:1;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
+	unsigned int	no_64bit_msi:1; /* device may only use 32-bit MSIs */
 	unsigned int	block_cfg_access:1;	/* config space access is blocked */
 	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
 	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting variant */
-- 
2.1.3

