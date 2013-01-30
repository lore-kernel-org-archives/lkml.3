Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3A3FMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:12:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:24012 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3A3FML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:12:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,565,1355126400"; 
   d="scan'208";a="250117218"
From: Youquan Song <youquan.song@intel.com>
To: htejun@gmail.com, ming.lei@canonical.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: seth.heasley@intel.com, jlee@suse.com, james.d.ralston@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] ata: Fix DVD not dectected at some Haswell platforms
Date: Wed, 30 Jan 2013 12:19:33 -0500
Message-Id: <1359566374-27286-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d fix the 4 ports
IDE controller 32bit PIO mode. 
Recently, the problem was showed at Haswell platform which includes 2 ports 
IDE controller.

So introduce a qurik patch to disable 32bit PIO at this IDE controller. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/ata/ata_piix.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ef773e1..1993e52 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -150,6 +150,7 @@ enum piix_controller_ids {
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
+	ich8_2port_sata_snb,
 };
 
 struct piix_map_db {
@@ -326,7 +327,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
-	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point-LP) */
@@ -502,6 +503,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -643,6 +645,16 @@ static struct ata_port_info piix_port_info[] = {
 		.port_ops	= &piix_sata_ops,
 	},
 
+	[ich8_2port_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR | PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+
 };
 
 static struct pci_bits piix_enable_bits[] = {
-- 
1.6.4.2

