Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbaKSW1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:27:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894AbaKSUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, dorin@i51.org,
        Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH 3.17 051/141] ahci: disable MSI instead of NCQ on Samsung pci-e SSDs on macbooks
Date: Wed, 19 Nov 2014 12:51:14 -0800
Message-Id: <20141119205152.355648126@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -60,6 +60,7 @@ enum board_ids {
 	/* board IDs by feature in alphabetical order */
 	board_ahci,
 	board_ahci_ign_iferr,
+	board_ahci_nomsi,
 	board_ahci_noncq,
 	board_ahci_nosntf,
 	board_ahci_yes_fbs,
@@ -121,6 +122,13 @@ static const struct ata_port_info ahci_p
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
@@ -480,10 +488,10 @@ static const struct pci_device_id ahci_p
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


