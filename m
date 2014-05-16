Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaEPMxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:53:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49569 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753741AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Dan Williams" <dan.j.williams@intel.com>,
        "Tejun Heo" <tj@kernel.org>, "Dave Jiang" <dave.jiang@intel.com>,
        "Ed Ciechanowski" <ed.ciechanowski@intel.com>,
        "Matthew Wilcox" <matthew.r.wilcox@intel.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.429349907@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 15/34] libata/ahci: accommodate tag ordered controllers
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/libata-core.c | 21 +++++++++++++--------
 include/linux/libata.h    |  1 +
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4718,21 +4718,26 @@ void swap_buf_le16(u16 *buf, unsigned in
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
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -763,6 +763,7 @@ struct ata_port {
 	unsigned long		qc_allocated;
 	unsigned int		qc_active;
 	int			nr_active_links; /* #links with active qcs */
+	unsigned int		last_tag;	/* track next tag hw expects */
 
 	struct ata_link		link;		/* host default link */
 	struct ata_link		*slave_link;	/* see ata_slave_link_init() */

