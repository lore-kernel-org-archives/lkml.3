Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaLCL5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:57:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaLCL1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 025/101] ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks
Date: Wed,  3 Dec 2014 12:25:47 +0100
Message-Id: <9c599f2b9b023abcff31e49dca754bf92170a023.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 66a7cbc303f4d28f201529b06061944d51ab530c upstream.

Samsung pci-e SSDs on macbooks failed miserably on NCQ commands, so
67809f85d31e ("ahci: disable NCQ on Samsung pci-e SSDs on macbooks")
disabled NCQ on them.  It turns out that NCQ is fine as long as MSI is
not used, so let's turn off MSI and leave NCQ on.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=60731
Tested-by: <dorin@i51.org>
Tested-by: Imre Kaloz <kaloz@openwrt.org>
Fixes: 67809f85d31e ("ahci: disable NCQ on Samsung pci-e SSDs on macbooks")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/ahci.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 0fc168c3a574..4432c9dc9c7a 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,6 +61,7 @@ enum board_ids {
 	/* board IDs by feature in alphabetical order */
 	board_ahci,
 	board_ahci_ign_iferr,
+	board_ahci_nomsi,
 	board_ahci_noncq,
 	board_ahci_nosntf,
 	board_ahci_yes_fbs,
@@ -120,6 +121,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_nomsi] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_MSI),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	[board_ahci_noncq] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
@@ -479,10 +487,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
 	/*
-	 * Samsung SSDs found on some macbooks.  NCQ times out.
-	 * https://bugzilla.kernel.org/show_bug.cgi?id=60731
+	 * Samsung SSDs found on some macbooks.  NCQ times out if MSI is
+	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=60731
 	 */
-	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_noncq },
+	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
-- 
2.1.3

