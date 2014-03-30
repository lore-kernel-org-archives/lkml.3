Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaC3X4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:56:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbaC3Xn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Levente Kurusa" <levex@linux.com>,
        "Tejun Heo" <tj@kernel.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.770893551@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 125/200] ahci: disable NCQ on Samsung pci-e SSDs on
 macbooks
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Levente Kurusa <levex@linux.com>

commit 67809f85d31eac600f6b28defa5386c9d2a13b1d upstream.

Samsung's pci-e SSDs with device ID 0x1600 which are found on some
macbooks time out on NCQ commands.  Blacklist NCQ on the device so
that the affected machines can at least boot.

Original-patch-by: Levente Kurusa <levex@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60731
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -61,6 +61,7 @@ enum board_ids {
 	/* board IDs by feature in alphabetical order */
 	board_ahci,
 	board_ahci_ign_iferr,
+	board_ahci_noncq,
 	board_ahci_nosntf,
 	board_ahci_yes_fbs,
 
@@ -123,6 +124,13 @@ static const struct ata_port_info ahci_p
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
 	[board_ahci_nosntf] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
@@ -458,6 +466,12 @@ static const struct pci_device_id ahci_p
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
 

