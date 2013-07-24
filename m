Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3GXOZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:25:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45752 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab3GXOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steffen Maier" <maier@linux.vnet.ibm.com>,
        "Martin Peschke" <mpeschke@linux.vnet.ibm.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.309702674@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [04/85] [SCSI] zfcp: block queue limits with data router
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit 5fea4291deacd80188b996d2f555fc6a1940e5d4 upstream.

Commit 86a9668a8d29ea711613e1cb37efa68e7c4db564
"[SCSI] zfcp: support for hardware data router"
reduced the initial block queue limits in the scsi_host_template to the
absolute minimum and adjusted them later on. However, the adjustment was
too late for the BSG devices of Scsi_Host and fc_host.

Therefore, ioctl(..., SG_IO, ...) with request or response size > 4kB to a
BSG device of an fc_host or a Scsi_Host fails with EINVAL. As a result,
users of such ioctl such as HBA_SendCTPassThru() in libzfcphbaapi return
with error HBA_STATUS_ERROR.

Initialize the block queue limits in zfcp_scsi_host_template to the
greatest common denominator (GCD).

While we cannot exploit the slightly enlarged maximum request size with
data router, this should be neglectible. Doing so also avoids running into
trouble after live guest relocation (LGR) / migration from a data router
FCP device to an FCP device that does not support data router. In that
case, zfcp would figure out the new limits on adapter recovery, but the
fc_host and Scsi_Host (plus in fact all sdevs) still exist with the old and
now too large queue limits.

It should also OK, not to use half the size as in the DIX case, because
fc_host and Scsi_Host do not transport FCP requests including SCSI commands
using protection data.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: copyright notice changed slightly]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/scsi/zfcp_scsi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corporation 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -311,8 +311,12 @@ static struct scsi_host_template zfcp_sc
 	.proc_name		 = "zfcp",
 	.can_queue		 = 4096,
 	.this_id		 = -1,
-	.sg_tablesize		 = 1, /* adjusted later */
-	.max_sectors		 = 8, /* adjusted later */
+	.sg_tablesize		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2),
+				   /* GCD, adjusted later */
+	.max_sectors		 = (((QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+				     * ZFCP_QDIO_MAX_SBALS_PER_REQ) - 2) * 8,
+				   /* GCD, adjusted later */
 	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 	.cmd_per_lun		 = 1,
 	.use_clustering		 = 1,

