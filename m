Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbaCEPSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:18:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977AbaCEOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 048/131] ahci: disable NCQ on Samsung pci-e SSDs on macbooks
Date: Wed,  5 Mar 2014 14:22:52 +0000
Message-Id: <1394029455-23128-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Levente Kurusa <levex@linux.com>

commit 67809f85d31eac600f6b28defa5386c9d2a13b1d upstream.

Samsung's pci-e SSDs with device ID 0x1600 which are found on some
macbooks time out on NCQ commands.  Blacklist NCQ on the device so
that the affected machines can at least boot.

Original-patch-by: Levente Kurusa <levex@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60731
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 54bf3f8..75979cd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,6 +61,7 @@ enum board_ids {
 	/* board IDs by feature in alphabetical order */
 	board_ahci,
 	board_ahci_ign_iferr,
+	board_ahci_noncq,
 	board_ahci_nosntf,
 	board_ahci_yes_fbs,
 
@@ -119,6 +120,13 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_noncq] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	[board_ahci_nosntf] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
 		.flags		= AHCI_FLAG_COMMON,
@@ -450,6 +458,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/*
+	 * Samsung SSDs found on some macbooks.  NCQ times out.
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=60731
+	 */
+	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_noncq },
+
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
 
-- 
1.9.0

