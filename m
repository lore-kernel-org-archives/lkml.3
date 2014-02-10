Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbaBJTxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:53:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaBJTrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 071/124] libata: disable LPM for some WD SATA-I devices
Date: Mon, 10 Feb 2014 11:40:11 -0800
Message-Id: <1392061264-28124-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ecd75ad514d73efc1bbcc5f10a13566c3ace5f53 upstream.

For some reason, some early WD drives spin up and down drives
erratically when the link is put into slumber mode which can reduce
the life expectancy of the device significantly.  Unfortunately, we
don't have full list of devices and given the nature of the issue it'd
be better to err on the side of false positives than the other way
around.  Let's disable LPM on all WD devices which match one of the
known problematic model prefixes and are SATA-I.

As horkage list doesn't support matching SATA capabilities, this is
implemented as two horkages - WD_BROKEN_LPM and NOLPM.  The former is
set for the known prefixes and sets the latter if the matched device
is SATA-I.

Note that this isn't optimal as this disables all LPM operations and
partial link power state reportedly works fine on these; however, the
way LPM is implemented in libata makes it difficult to precisely map
libata LPM setting to specific link power state.  Well, these devices
are already fairly outdated.  Let's just disable whole LPM for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-tested-by: Nikos Barkas <levelwol@gmail.com>
Reported-and-tested-by: Ioannis Barkas <risc4all@yahoo.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=57211
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-core.c | 27 +++++++++++++++++++++++++++
 drivers/ata/libata-scsi.c | 18 +++++++++++++++---
 include/linux/libata.h    |  2 ++
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d6534f5..0dbb6c4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2199,6 +2199,16 @@ int ata_dev_configure(struct ata_device *dev)
 	if (rc)
 		return rc;
 
+	/* some WD SATA-1 drives have issues with LPM, turn on NOLPM for them */
+	if ((dev->horkage & ATA_HORKAGE_WD_BROKEN_LPM) &&
+	    (id[ATA_ID_SATA_CAPABILITY] & 0xe) == 0x2)
+		dev->horkage |= ATA_HORKAGE_NOLPM;
+
+	if (dev->horkage & ATA_HORKAGE_NOLPM) {
+		ata_dev_warn(dev, "LPM support broken, forcing max_power\n");
+		dev->link->ap->target_lpm_policy = ATA_LPM_MAX_POWER;
+	}
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
@@ -4187,6 +4197,23 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
+	/*
+	 * Some WD SATA-I drives spin up and down erratically when the link
+	 * is put into the slumber mode.  We don't have full list of the
+	 * affected devices.  Disable LPM if the device matches one of the
+	 * known prefixes and is SATA-1.  As a side effect LPM partial is
+	 * lost too.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=57211
+	 */
+	{ "WDC WD800JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD1200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD1600JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD2000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD2500JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD3000JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+	{ "WDC WD3200JD-*",		NULL,	ATA_HORKAGE_WD_BROKEN_LPM },
+
 	/* End Marker */
 	{ }
 };
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2b628d6..9072fdb 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -111,12 +111,14 @@ static const char *ata_lpm_policy_names[] = {
 	[ATA_LPM_MIN_POWER]	= "min_power",
 };
 
-static ssize_t ata_scsi_lpm_store(struct device *dev,
+static ssize_t ata_scsi_lpm_store(struct device *device,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
-	struct Scsi_Host *shost = class_to_shost(dev);
+	struct Scsi_Host *shost = class_to_shost(device);
 	struct ata_port *ap = ata_shost_to_port(shost);
+	struct ata_link *link;
+	struct ata_device *dev;
 	enum ata_lpm_policy policy;
 	unsigned long flags;
 
@@ -132,10 +134,20 @@ static ssize_t ata_scsi_lpm_store(struct device *dev,
 		return -EINVAL;
 
 	spin_lock_irqsave(ap->lock, flags);
+
+	ata_for_each_link(link, ap, EDGE) {
+		ata_for_each_dev(dev, &ap->link, ENABLED) {
+			if (dev->horkage & ATA_HORKAGE_NOLPM) {
+				count = -EOPNOTSUPP;
+				goto out_unlock;
+			}
+		}
+	}
+
 	ap->target_lpm_policy = policy;
 	ata_port_schedule_eh(ap);
+out_unlock:
 	spin_unlock_irqrestore(ap->lock, flags);
-
 	return count;
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 0621bca..a55de7b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -399,6 +399,8 @@ enum {
 	ATA_HORKAGE_BROKEN_FPDMA_AA	= (1 << 15),	/* skip AA */
 	ATA_HORKAGE_DUMP_ID	= (1 << 16),	/* dump IDENTIFY data */
 	ATA_HORKAGE_MAX_SEC_LBA48 = (1 << 17),	/* Set max sects to 65535 */
+	ATA_HORKAGE_NOLPM	= (1 << 20),	/* don't use LPM */
+	ATA_HORKAGE_WD_BROKEN_LPM = (1 << 21),	/* some WDs have broken LPM */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
-- 
1.8.3.2

