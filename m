Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3AXVff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:35:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:39953 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400Ab3AXVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <bp@alien8.de>, Shane Huang <shane.huang@amd.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 06/46] libata: replace sata_settings with devslp_timing
Date: Thu, 24 Jan 2013 13:12:44 -0800
Message-Id: <20130124211138.239368647@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit 803739d25c2343da6d2f95eebdcbc08bf67097d4 upstream.

NCQ capability was used to check availability of SATA Settings page
from Identify Device Data Log, which contains DevSlp timing variables.
It does not work on some HDDs and leads to error messages.

IDENTIFY word 78 bit 5(Hardware Feature Control) can't work either
because it is only the sufficient condition of Identify Device data
log, not the necessary condition.

This patch replaced ata_device->sata_settings with ->devslp_timing
to only save DevSlp timing variables(8 bytes), instead of the whole
SATA Settings page(512 bytes).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=51881

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Shane Huang <shane.huang@amd.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libahci.c     |    6 +++---
 drivers/ata/libata-core.c |   22 +++++++++++++---------
 include/linux/ata.h       |    8 +++++---
 include/linux/libata.h    |    4 ++--
 4 files changed, 23 insertions(+), 17 deletions(-)

--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1951,13 +1951,13 @@ static void ahci_set_aggressive_devslp(s
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
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2324,24 +2324,28 @@ int ata_dev_configure(struct ata_device
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


