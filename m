Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab3CGO3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:29:38 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45147 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3CGO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:29:37 -0500
From: yxlraid@gmail.com
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
Date: Thu,  7 Mar 2013 22:29:16 +0800
Message-Id: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

Fix system hang issue: if first accessed resource file of BAR0 ~
BAR4, system will hang after executing lspci command
---
 drivers/pci/quirks.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0369fb6..d49f8dc 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -44,6 +44,21 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
 				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
 
+/* The BAR0 ~ BAR4 of Marvell 9125 device can't be accessed
+*  by IO resource file, and need to skip the files
+*/
+static void quirk_marvell_mask_bar(struct pci_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < 5; i++)
+		if (dev->resource[i].start)
+			dev->resource[i].start =
+				dev->resource[i].end = 0;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9125,
+				quirk_marvell_mask_bar);
+
 /* The Mellanox Tavor device gives false positive parity errors
  * Mark this device with a broken_parity_status, to allow
  * PCI scanning code to "skip" this now blacklisted device.
-- 
1.7.5.4

