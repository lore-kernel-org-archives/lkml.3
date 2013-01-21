Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3AUUQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:16:29 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46804 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797Ab3AUUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:16:26 -0500
X-Greylist: delayed 1695 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 15:16:26 EST
Date: Mon, 21 Jan 2013 14:48:11 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20130121194811.GA30605@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull 803739d25c2343da6d2f95eebdcbc08bf67097d4 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |  8 +++++++-
 drivers/ata/libahci.c     |  6 +++---
 drivers/ata/libata-core.c | 22 +++++++++++++---------
 drivers/ata/libata-eh.c   |  2 +-
 include/linux/ata.h       |  8 +++++---
 include/linux/libata.h    |  4 ++--
 6 files changed, 31 insertions(+), 19 deletions(-)

Bian Yu (1):
      [libata] ahci: Fix lack of command retry after a success error handler.

Hugh Daschbach (1):
      [libata] ahci: Add support for Enmotus Bobcat device.

Shane Huang (1):
      [libata] replace sata_settings with devslp_timing

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7862d17..4979127 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -53,6 +53,7 @@
 
 enum {
 	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_ENMOTUS	= 2,
 	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
@@ -410,6 +411,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1098,9 +1102,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
-	/* The Connext uses non-standard BAR */
+	/* Both Connext and Enmotus devices use non-standard BARs */
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
 		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
+		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 320712a..6cd7805 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1951,13 +1951,13 @@ static void ahci_set_aggressive_devslp(struct ata_port *ap, bool sleep)
 	/* Use the nominal value 10 ms if the read MDAT is zero,
 	 * the nominal value of DETO is 20 ms.
 	 */
-	if (dev->sata_settings[ATA_LOG_DEVSLP_VALID] &
+	if (dev->devslp_timing[ATA_LOG_DEVSLP_VALID] &
 	    ATA_LOG_DEVSLP_VALID_MASK) {
-		mdat = dev->sata_settings[ATA_LOG_DEVSLP_MDAT] &
+		mdat = dev->devslp_timing[ATA_LOG_DEVSLP_MDAT] &
 		       ATA_LOG_DEVSLP_MDAT_MASK;
 		if (!mdat)
 			mdat = 10;
-		deto = dev->sata_settings[ATA_LOG_DEVSLP_DETO];
+		deto = dev->devslp_timing[ATA_LOG_DEVSLP_DETO];
 		if (!deto)
 			deto = 20;
 	} else {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9e8b99a..46cd3f4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2325,24 +2325,28 @@ int ata_dev_configure(struct ata_device *dev)
 			}
 		}
 
-		/* check and mark DevSlp capability */
-		if (ata_id_has_devslp(dev->id))
-			dev->flags |= ATA_DFLAG_DEVSLP;
-
-		/* Obtain SATA Settings page from Identify Device Data Log,
-		 * which contains DevSlp timing variables etc.
-		 * Exclude old devices with ata_id_has_ncq()
+		/* Check and mark DevSlp capability. Get DevSlp timing variables
+		 * from SATA Settings page of Identify Device Data Log.
 		 */
-		if (ata_id_has_ncq(dev->id)) {
+		if (ata_id_has_devslp(dev->id)) {
+			u8 sata_setting[ATA_SECT_SIZE];
+			int i, j;
+
+			dev->flags |= ATA_DFLAG_DEVSLP;
 			err_mask = ata_read_log_page(dev,
 						     ATA_LOG_SATA_ID_DEV_DATA,
 						     ATA_LOG_SATA_SETTINGS,
-						     dev->sata_settings,
+						     sata_setting,
 						     1);
 			if (err_mask)
 				ata_dev_dbg(dev,
 					    "failed to get Identify Device Data, Emask 0x%x\n",
 					    err_mask);
+			else
+				for (i = 0; i < ATA_LOG_DEVSLP_SIZE; i++) {
+					j = ATA_LOG_DEVSLP_OFFSET + i;
+					dev->devslp_timing[i] = sata_setting[j];
+				}
 		}
 
 		dev->cdb_len = 16;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bf039b0..bcf4437 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2094,7 +2094,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
  */
 static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
 {
-	if (qc->flags & AC_ERR_MEDIA)
+	if (qc->err_mask & AC_ERR_MEDIA)
 		return 0;	/* don't retry media errors */
 	if (qc->flags & ATA_QCFLAG_IO)
 		return 1;	/* otherwise retry anything from fs stack */
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 408da95..8f7a3d6 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -297,10 +297,12 @@ enum {
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_SATA_ID_DEV_DATA  = 0x30,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
-	ATA_LOG_DEVSLP_MDAT	  = 0x30,
+	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
+	ATA_LOG_DEVSLP_SIZE	  = 0x08,
+	ATA_LOG_DEVSLP_MDAT	  = 0x00,
 	ATA_LOG_DEVSLP_MDAT_MASK  = 0x1F,
-	ATA_LOG_DEVSLP_DETO	  = 0x31,
-	ATA_LOG_DEVSLP_VALID	  = 0x37,
+	ATA_LOG_DEVSLP_DETO	  = 0x01,
+	ATA_LOG_DEVSLP_VALID	  = 0x07,
 	ATA_LOG_DEVSLP_VALID_MASK = 0x80,
 
 	/* READ/WRITE LONG (obsolete) */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 83ba0ab..649e5f8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -652,8 +652,8 @@ struct ata_device {
 		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
 	};
 
-	/* Identify Device Data Log (30h), SATA Settings (page 08h) */
-	u8			sata_settings[ATA_SECT_SIZE];
+	/* DEVSLP Timing Variables from Identify Device Data Log */
+	u8			devslp_timing[ATA_LOG_DEVSLP_SIZE];
 
 	/* error history */
 	int			spdn_cnt;
