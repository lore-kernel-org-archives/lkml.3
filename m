Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829Ab3DHUaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:30:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40505 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935930Ab3DHUaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:30:21 -0400
Date: Mon, 8 Apr 2013 16:30:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20130408203020.GA2919@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The HDIO_DRIVE_* fix is really the biggie.

Please pull 6d3bfc7be6f80d0c6ee6800d58d573343bf6e260 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

 drivers/ata/ata_piix.c    | 14 +++++++++++++-
 drivers/ata/libata-core.c |  6 +++++-
 drivers/ata/libata-scsi.c |  8 ++++----
 include/linux/ata.h       |  2 +-
 include/linux/libata.h    |  1 +
 5 files changed, 24 insertions(+), 7 deletions(-)

David Woodhouse (1):
      libata: fix DMA to stack in reading devslp_timing parameters

Krzysztof Mazur (1):
      [libata] Fix HDIO_DRIVE_* ioctl() Linux 3.9 regression

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index ffdd32d..2f48123 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -150,6 +150,7 @@ enum piix_controller_ids {
 	tolapai_sata,
 	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
 	ich8_sata_snb,
+	ich8_2port_sata_snb,
 };
 
 struct piix_map_db {
@@ -304,7 +305,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
-	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point-LP) */
@@ -439,6 +440,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
 	[ich8m_apple_sata]	= &ich8m_apple_map_db,
 	[tolapai_sata]		= &tolapai_map_db,
 	[ich8_sata_snb]		= &ich8_map_db,
+	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
 };
 
 static struct pci_bits piix_enable_bits[] = {
@@ -1242,6 +1244,16 @@ static struct ata_port_info piix_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &piix_sata_ops,
 	},
+
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
 
 #define AHCI_PCI_BAR 5
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 497adea..63c743b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2329,7 +2329,7 @@ int ata_dev_configure(struct ata_device *dev)
 		 * from SATA Settings page of Identify Device Data Log.
 		 */
 		if (ata_id_has_devslp(dev->id)) {
-			u8 sata_setting[ATA_SECT_SIZE];
+			u8 *sata_setting = ap->sector_buf;
 			int i, j;
 
 			dev->flags |= ATA_DFLAG_DEVSLP;
@@ -2439,6 +2439,9 @@ int ata_dev_configure(struct ata_device *dev)
 		dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
 					 dev->max_sectors);
 
+	if (dev->horkage & ATA_HORKAGE_MAX_SEC_LBA48)
+		dev->max_sectors = ATA_MAX_SECTORS_LBA48;
+
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
@@ -4100,6 +4103,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
 	{ "QUANTUM DAT    DAT72-000", NULL,	ATA_HORKAGE_ATAPI_MOD16_DMA },
+	{ "Slimtype DVD A  DS8A8SH", NULL,	ATA_HORKAGE_MAX_SEC_LBA48 },
 
 	/* Devices we expect to fail diagnostics */
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 318b413..ff44787 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -532,8 +532,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 					     &sshdr);
-			if (sshdr.sense_key == 0 &&
-			    sshdr.asc == 0 && sshdr.ascq == 0)
+			if (sshdr.sense_key == RECOVERED_ERROR &&
+			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
@@ -618,8 +618,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 						&sshdr);
-			if (sshdr.sense_key == 0 &&
-				sshdr.asc == 0 && sshdr.ascq == 0)
+			if (sshdr.sense_key == RECOVERED_ERROR &&
+			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 8f7a3d6..ee0bd95 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -954,7 +954,7 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 	}
 }
 
-static inline bool atapi_command_packet_set(const u16 *dev_id)
+static inline int atapi_command_packet_set(const u16 *dev_id)
 {
 	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 91c9d10..eae7a05 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -398,6 +398,7 @@ enum {
 	ATA_HORKAGE_NOSETXFER	= (1 << 14),	/* skip SETXFER, SATA only */
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
+	ATA_HORKAGE_MAX_SEC_LBA48 = (1 << 17),	/* Set max sects to 65535 */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
