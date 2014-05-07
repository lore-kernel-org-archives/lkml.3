Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933933AbaEGNcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:32:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855AbaEGNOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jiang <dave.jiang@intel.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 16/70] libata/ahci: accommodate tag ordered controllers
Date: Wed,  7 May 2014 14:12:19 +0100
Message-Id: <1399468393-10140-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/libata-core.c | 21 +++++++++++++--------
 include/linux/libata.h    |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ac04311..908c07c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4765,21 +4765,26 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
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
index 611d733..d0c64ab 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -773,6 +773,7 @@ struct ata_port {
 	unsigned long		qc_allocated;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
+	unsigned int		last_tag;	/* track next tag hw expects */
 
 	struct ata_link		link;		/* host default link */
 	struct ata_link		*slave_link;	/* see ata_slave_link_init() */
-- 
1.9.1

