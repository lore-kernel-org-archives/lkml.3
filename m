Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab3GKO0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab3GKO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 53/98] [SCSI] zfcp: block queue limits with data router
Date: Thu, 11 Jul 2013 15:24:23 +0100
Message-Id: <1373552708-15235-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index b79576b..7b35364 100644
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
@@ -311,8 +311,12 @@ static struct scsi_host_template zfcp_scsi_host_template = {
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
-- 
1.8.1.2

