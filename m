Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaAUPBC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:01:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361AbaAUPAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:00:47 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/1] libata: Get rid of ata_port::qc_allocated bitmask
Date: Tue, 21 Jan 2014 16:02:26 +0100
Message-Id: <b6f797f22591ef592bf17aefa0b359bd03953a2e.1390315528.git.agordeev@redhat.com>
In-Reply-To: <cover.1390315528.git.agordeev@redhat.com>
References: <cover.1390315528.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scanning ata_port::qc_allocated bitmask for free tags has
been a performance bottleneck due to the cache line bouncing.
This update replaces ata_port::qc_allocated bitmask with
optimized for parallel access percpu_ida tags allocator.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/libata-core.c |   82 +++++++++++++++++++++++++++++++-------------
 include/linux/libata.h    |    6 ++-
 2 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 75b9367..88af198 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -68,6 +68,7 @@
 #include <linux/ratelimit.h>
 #include <linux/pm_runtime.h>
 #include <linux/platform_device.h>
+#include <linux/percpu_ida.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -1519,6 +1520,34 @@ static void ata_qc_complete_internal(struct ata_queued_cmd *qc)
 	complete(waiting);
 }
 
+static unsigned int __ata_get_internal_tag(struct ata_port *ap)
+{
+	int tag = percpu_ida_alloc(&ap->qc_internal, GFP_NOWAIT);
+
+	if (unlikely(tag < 0))
+		return -1;
+
+	return ATA_TAG_INTERNAL;
+}
+
+static unsigned int __ata_get_tag(struct ata_port *ap)
+{
+	int tag = percpu_ida_alloc(&ap->qc_tags, GFP_NOWAIT);
+
+	if (unlikely(tag < 0))
+		return -1;
+
+	return (unsigned int)tag + (ATA_TAG_INTERNAL + 1);
+}
+
+static void __ata_put_tag(struct ata_port *ap, unsigned int tag)
+{
+	if (unlikely(tag == ATA_TAG_INTERNAL))
+		percpu_ida_free(&ap->qc_internal, 0);
+	else
+		percpu_ida_free(&ap->qc_tags, tag - (ATA_TAG_INTERNAL + 1));
+}
+
 /**
  *	ata_exec_internal_sg - execute libata internal command
  *	@dev: Device to which the command is sent
@@ -1569,18 +1598,8 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 
 	/* initialize internal qc */
 
-	/* XXX: Tag 0 is used for drivers with legacy EH as some
-	 * drivers choke if any other tag is given.  This breaks
-	 * ata_tag_internal() test for those drivers.  Don't use new
-	 * EH stuff without converting to it.
-	 */
-	if (ap->ops->error_handler)
-		tag = ATA_TAG_INTERNAL;
-	else
-		tag = 0;
-
-	if (test_and_set_bit(tag, &ap->qc_allocated))
-		BUG();
+	tag = __ata_get_internal_tag(ap);
+	BUG_ON(!ata_tag_internal(tag));
 	qc = __ata_qc_from_tag(ap, tag);
 
 	qc->tag = tag;
@@ -4750,21 +4769,17 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
-	unsigned int i;
+	unsigned int tag;
 
 	/* no command while frozen */
 	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
 		return NULL;
 
-	/* the last tag is reserved for internal command. */
-	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
-		if (!test_and_set_bit(i, &ap->qc_allocated)) {
-			qc = __ata_qc_from_tag(ap, i);
-			break;
-		}
+	tag = __ata_get_tag(ap);
+	qc = __ata_qc_from_tag(ap, tag);
 
 	if (qc)
-		qc->tag = i;
+		qc->tag = tag;
 
 	return qc;
 }
@@ -4816,7 +4831,7 @@ void ata_qc_free(struct ata_queued_cmd *qc)
 	tag = qc->tag;
 	if (likely(ata_tag_valid(tag))) {
 		qc->tag = ATA_TAG_POISON;
-		clear_bit(tag, &ap->qc_allocated);
+		__ata_put_tag(ap, tag);
 	}
 }
 
@@ -5656,6 +5671,18 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	if (!ap)
 		return NULL;
 
+	if (__percpu_ida_init(&ap->qc_tags,
+			      ATA_MAX_QUEUE - 1, 4, 2) < 0) {
+		kfree(ap);
+		return NULL;
+	}
+
+	if (__percpu_ida_init(&ap->qc_internal, 1, 1, 1) < 0) {
+		percpu_ida_destroy(&ap->qc_tags);
+		kfree(ap);
+		return NULL;
+	}
+
 	ap->pflags |= ATA_PFLAG_INITIALIZING | ATA_PFLAG_FROZEN;
 	ap->lock = &host->lock;
 	ap->print_id = -1;
@@ -5695,6 +5722,15 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	return ap;
 }
 
+static void ata_port_free(struct ata_port *ap)
+{
+	kfree(ap->pmp_link);
+	kfree(ap->slave_link);
+	percpu_ida_destroy(&ap->qc_tags);
+	percpu_ida_destroy(&ap->qc_internal);
+	kfree(ap);
+}
+
 static void ata_host_release(struct device *gendev, void *res)
 {
 	struct ata_host *host = dev_get_drvdata(gendev);
@@ -5709,9 +5745,7 @@ static void ata_host_release(struct device *gendev, void *res)
 		if (ap->scsi_host)
 			scsi_host_put(ap->scsi_host);
 
-		kfree(ap->pmp_link);
-		kfree(ap->slave_link);
-		kfree(ap);
+		ata_port_free(ap);
 		host->ports[i] = NULL;
 	}
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 0e23c26..d673e91 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -38,6 +38,7 @@
 #include <linux/acpi.h>
 #include <linux/cdrom.h>
 #include <linux/sched.h>
+#include <linux/percpu_ida.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -126,7 +127,7 @@ enum {
 	ATA_DEF_QUEUE		= 1,
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
 	ATA_MAX_QUEUE		= 32,
-	ATA_TAG_INTERNAL	= ATA_MAX_QUEUE - 1,
+	ATA_TAG_INTERNAL	= 0,
 	ATA_SHORT_PAUSE		= 16,
 
 	ATAPI_MAX_DRAIN		= 16 << 10,
@@ -816,7 +817,8 @@ struct ata_port {
 	unsigned int		cbl;	/* cable type; ATA_CBL_xxx */
 
 	struct ata_queued_cmd	qcmd[ATA_MAX_QUEUE];
-	unsigned long		qc_allocated;
+	struct percpu_ida	qc_internal;
+	struct percpu_ida	qc_tags;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
 
-- 
1.7.7.6

