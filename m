Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937481Ab3DJXA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:00:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937457Ab3DJWuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, Youquan Song <youquan.song@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 15/29] ata_piix: Fix DVD not dectected at some Haswell platforms
Date: Wed, 10 Apr 2013 15:49:33 -0700
Message-Id: <20130410224805.680267274@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ata_piix.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

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
 	/* SATA Controller IDE (DH89xxCC) */
@@ -511,6 +512,7 @@ static const struct piix_map_db *piix_ma
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -652,6 +654,15 @@ static struct ata_port_info piix_port_in
 		.port_ops	= &piix_sata_ops,
 	},
 
+	[ich8_2port_sata_snb] =
+	{
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR
+					| PIIX_FLAG_PIO16,
+		.pio_mask	= ATA_PIO4,
+		.mwdma_mask	= ATA_MWDMA2,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {


