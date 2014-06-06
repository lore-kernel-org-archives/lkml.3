Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaFFPwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:52:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:34975 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbaFFPwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:52:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="scan'208";a="552911682"
Subject: [boot regression PATCH] libata: allow xgene-ahci to opt-out of tag
 ordered submission
From: Dan Williams <dan.j.williams@intel.com>
To: tj@kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>, Ming Lei <ming.lei@canonical.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Loc Ho <lho@apm.com>, Suman Tripathi <stripathi@apm.com>,
        Tuan Phan <tphan@apm.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>
Date: Fri, 06 Jun 2014 08:52:34 -0700
Message-ID: <20140606155126.27059.76543.stgit@viggo.jf.intel.com>
User-Agent: StGit/0.17.1-5-g6888
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei reports:
  "Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
   controllers) causes below sata failure on APM AHCI controller.

   And the error does disappear after reverting the commit.

     ata4.00: exception Emask 0x40 SAct 0xff00 SErr 0x800 action 0x6 frozen
     ata4: SError: { HostInt }
     ata4.00: failed command: READ FPDMA QUEUED
     ata4.00: cmd 60/08:40:e0:a4:88/00:00:04:00:00/40 tag 8 ncq 4096 in
              res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44 (timeout)"

http://marc.info/?l=linux-kernel&m=140195842716315&w=2

Maintain tag ordered submission as the default, but allow xgene-ahci to
continue with the old behavior.

Cc: Loc Ho <lho@apm.com>
Cc: <stable@vger.kernel.org>
Cc: Tuan Phan <tphan@apm.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Suman Tripathi <stripathi@apm.com>
Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Tested-by: Ming Lei <ming.lei@canonical.com>
Reported-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/ahci_xgene.c  |    2 ++
 drivers/ata/libata-core.c |   42 +++++++++++++++++++++++++++++++++++++++---
 drivers/ata/libata.h      |    2 ++
 include/linux/libata.h    |    1 +
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf171f1..33de8d23de8a 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -28,6 +28,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/phy/phy.h>
+#include "libata.h"
 #include "ahci.h"
 
 /* Max # of disk per a controller */
@@ -300,6 +301,7 @@ static struct ata_port_operations xgene_ahci_ops = {
 	.host_stop = xgene_ahci_host_stop,
 	.hardreset = xgene_ahci_hardreset,
 	.read_id = xgene_ahci_read_id,
+	.qc_new = ata_qc_new_fifo_order,
 };
 
 static const struct ata_port_info xgene_ahci_port_info = {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 943cc8b83e59..dd554354791f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -83,6 +83,7 @@ const struct ata_port_operations ata_base_port_ops = {
 	.error_handler		= ata_std_error_handler,
 	.sched_eh		= ata_std_sched_eh,
 	.end_eh			= ata_std_end_eh,
+	.qc_new			= ata_qc_new_tag_order,
 };
 
 const struct ata_port_operations sata_port_ops = {
@@ -4784,14 +4785,17 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 }
 
 /**
- *	ata_qc_new - Request an available ATA command, for queueing
+ *	ata_qc_new_tag_order - Request an available ATA command, for queueing
  *	@ap: target port
  *
+ *	Accomodates controllers that issue commands in tag order rather
+ *	than FIFO order (Intel AHCI).
+ *
  *	LOCKING:
  *	None.
  */
 
-static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
+struct ata_queued_cmd *ata_qc_new_tag_order(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
 	unsigned int i, tag;
@@ -4819,6 +4823,38 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 }
 
 /**
+ *	ata_qc_new_fifo_order - Request an available ATA command, for queueing
+ *	@ap: target port
+ *
+ *	Allocate first available tag, for hosts that maintain fifo issue
+ *	order on the wire, or otherwise cannot handle tag order.
+ *
+ *	LOCKING:
+ *	None.
+ */
+
+struct ata_queued_cmd *ata_qc_new_fifo_order(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc = NULL;
+	unsigned int i;
+
+	/* no command while frozen */
+	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
+		return NULL;
+
+	/* the last tag is reserved for internal command. */
+	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
+		if (!test_and_set_bit(i, &ap->qc_allocated)) {
+			qc = __ata_qc_from_tag(ap, i);
+			qc->tag = i;
+			break;
+		}
+
+	return qc;
+}
+EXPORT_SYMBOL_GPL(ata_qc_new_fifo_order);
+
+/**
  *	ata_qc_new_init - Request an available ATA command, and initialize it
  *	@dev: Device from whom we request an available command structure
  *
@@ -4831,7 +4867,7 @@ struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev)
 	struct ata_port *ap = dev->link->ap;
 	struct ata_queued_cmd *qc;
 
-	qc = ata_qc_new(ap);
+	qc = ap->ops->qc_new(ap);
 	if (qc) {
 		qc->scsicmd = NULL;
 		qc->ap = ap;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 45b5ab3a95d5..381ba41de464 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -90,6 +90,8 @@ extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
 extern unsigned int ata_dev_set_feature(struct ata_device *dev,
 					u8 enable, u8 feature);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
+extern struct ata_queued_cmd *ata_qc_new_tag_order(struct ata_port *ap);
+extern struct ata_queued_cmd *ata_qc_new_fifo_order(struct ata_port *ap);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
 extern void __ata_qc_complete(struct ata_queued_cmd *qc);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5ab4e3a76721..852686837d1c 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -880,6 +880,7 @@ struct ata_port_operations {
 	void (*qc_prep)(struct ata_queued_cmd *qc);
 	unsigned int (*qc_issue)(struct ata_queued_cmd *qc);
 	bool (*qc_fill_rtf)(struct ata_queued_cmd *qc);
+	struct ata_queued_cmd *(*qc_new)(struct ata_port *ap);
 
 	/*
 	 * Configuration and exception handling

