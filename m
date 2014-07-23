Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbaGWO6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:58:40 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61891 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806AbaGWO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:58:38 -0400
Date: Wed, 23 Jul 2014 10:58:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] a libata regression fix for v3.16-rc6
Message-ID: <20140723145835.GB7103@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

The last libata/for-3.16-fixes pull contained a regression introduced
by 1871ee134b73 ("fb4cadab75752a7152ed2813c751") which in turn was a
fix for a regression introduced earlier while changing queue tag order
to accomodate hard drives which perform poorly if tags are not
allocated in circular order (ugh...).

The regression happens only for SAS controllers making use of libata
to serve ATA devices.  They don't fill an ata_host field which is used
by the new tag allocation function leading to NULL dereference.  This
patch adds a new intermediate field ata_host->n_tags which is
initialized for both SAS and !SAS cases to fix the issue.

Thanks.

The following changes since commit b32bfc06aefab61acc872dec3222624e6cd867ed:

  ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode) (2014-07-18 18:00:50 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.16-fixes

for you to fetch changes up to 1a112d10f03e83fb3a2fdc4c9165865dec8a3ca6:

  libata: introduce ata_host->n_tags to avoid oops on SAS controllers (2014-07-23 10:30:34 -0400)

----------------------------------------------------------------
Tejun Heo (1):
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers

 drivers/ata/libata-core.c | 16 ++++------------
 include/linux/libata.h    |  1 +
 2 files changed, 5 insertions(+), 12 deletions(-)
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d19c37a7..677c0c1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4798,9 +4798,8 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
-	unsigned int i, tag, max_queue;
-
-	max_queue = ap->scsi_host->can_queue;
+	unsigned int max_queue = ap->host->n_tags;
+	unsigned int i, tag;
 
 	/* no command while frozen */
 	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
@@ -6094,6 +6093,7 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 {
 	spin_lock_init(&host->lock);
 	mutex_init(&host->eh_mutex);
+	host->n_tags = ATA_MAX_QUEUE - 1;
 	host->dev = dev;
 	host->ops = ops;
 }
@@ -6175,15 +6175,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
 
-	/*
-	 * The max queue supported by hardware must not be greater than
-	 * ATA_MAX_QUEUE.
-	 */
-	if (sht->can_queue > ATA_MAX_QUEUE) {
-		dev_err(host->dev, "BUG: the hardware max queue is too large\n");
-		WARN_ON(1);
-		return -EINVAL;
-	}
+	host->n_tags = clamp(sht->can_queue, 1, ATA_MAX_QUEUE - 1);
 
 	/* host must have been started */
 	if (!(host->flags & ATA_HOST_STARTED)) {
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5ab4e3a..92abb49 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -593,6 +593,7 @@ struct ata_host {
 	struct device 		*dev;
 	void __iomem * const	*iomap;
 	unsigned int		n_ports;
+	unsigned int		n_tags;			/* nr of NCQ tags */
 	void			*private_data;
 	struct ata_port_operations *ops;
 	unsigned long		flags;
