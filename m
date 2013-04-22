Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3DVOeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:34:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51674 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab3DVOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Garzik" <jgarzik@redhat.com>,
        "Youquan Song" <youquan.song@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.726537958@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [22/75] ata_piix: Fix DVD not dectected at some Haswell platforms
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Youquan Song <youquan.song@intel.com>

commit b55f84e2d527182e7c611d466cd0bb6ddce201de upstream.

There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d
"ata_piix: make DVD Drive recognisable on systems with Intel Sandybridge
 chipsets(v2)" fixing the 4 ports IDE controller 32bit PIO mode.

We've hit a problem with DVD not recognized on Haswell Desktop platform which
includes Lynx Point 2-port SATA controller.

This quirk patch disables 32bit PIO on this controller in IDE mode.

v2: Change spelling error in statememnt pointed by Sergei Shtylyov.
v3: Change comment statememnt and spliting line over 80 characters pointed by
    Libor Pechacek and also rebase the patch against 3.8-rc7 kernel.

Tested-by: Lee, Chun-Yi <jlee@suse.com>
Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ata_piix.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -150,6 +150,7 @@ enum piix_controller_ids {
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
+	ich8_2port_sata_snb,
 };
 
 struct piix_map_db {
@@ -326,7 +327,7 @@ static const struct pci_device_id piix_p
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
-	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point-LP) */
@@ -519,6 +520,7 @@ static const struct piix_map_db *piix_ma
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -657,6 +659,16 @@ static struct ata_port_info piix_port_in
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
+
+	[ich8_2port_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR
+					| PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
 

