Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbaEMKLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933488AbaEMKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 149/182] libata/ahci: accommodate tag ordered controllers
Date: Tue, 13 May 2014 11:28:21 +0200
Message-Id: <913edce37b73a3f5939d902ac910e628aa2b4015.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8a4aeec8d2d6a3edeffbdfae451cdf05cbf0fefd upstream.

The AHCI spec allows implementations to issue commands in tag order
rather than FIFO order:

	5.3.2.12 P:SelectCmd
	HBA sets pSlotLoc = (pSlotLoc + 1) mod (CAP.NCS + 1)
	or HBA selects the command to issue that has had the
	PxCI bit set to '1' longer than any other command
	pending to be issued.

The result is that commands posted sequentially (time-wise) may play out
of sequence when issued by hardware.

This behavior has likely been hidden by drives that arrange for commands
to complete in issue order.  However, it appears recent drives (two from
different vendors that we have found so far) inflict out-of-order
completions as a matter of course.  So, we need to take care to maintain
ordered submission, otherwise we risk triggering a drive to fall out of
sequential-io automation and back to random-io processing, which incurs
large latency and degrades throughput.

This issue was found in simple benchmarks where QD=2 seq-write
performance was 30-50% *greater* than QD=32 seq-write performance.

Tagging for -stable and making the change globally since it has a low
risk-to-reward ratio.  Also, word is that recent versions of an unnamed
OS also does it this way now.  So, drives in the field are already
experienced with this tag ordering scheme.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>
Reviewed-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/libata-core.c | 21 +++++++++++++--------
 include/linux/libata.h    |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c5d056e974f1..785b496c50bc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4792,21 +4792,26 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
-	unsigned int i;
+	unsigned int i, tag;
 
 	/* no command while frozen */
 	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
 		return NULL;
 
-	/* the last tag is reserved for internal command. */
-	for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
-		if (!test_and_set_bit(i, &ap->qc_allocated)) {
-			qc = __ata_qc_from_tag(ap, i);
+	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+		tag = (i + ap->last_tag + 1) % ATA_MAX_QUEUE;
+
+		/* the last tag is reserved for internal command. */
+		if (tag == ATA_TAG_INTERNAL)
+			continue;
+
+		if (!test_and_set_bit(tag, &ap->qc_allocated)) {
+			qc = __ata_qc_from_tag(ap, tag);
+			qc->tag = tag;
+			ap->last_tag = tag;
 			break;
 		}
-
-	if (qc)
-		qc->tag = i;
+	}
 
 	return qc;
 }
diff --git a/include/linux/libata.h b/include/linux/libata.h
index bec6dbe939a0..3fee55e73e5e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -822,6 +822,7 @@ struct ata_port {
 	unsigned long		qc_allocated;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
+	unsigned int		last_tag;	/* track next tag hw expects */
 
 	struct ata_link		link;		/* host default link */
 	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
-- 
1.9.3

