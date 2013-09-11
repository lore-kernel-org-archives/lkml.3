Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab3IKE3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3IKE27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:59 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=FVNQfXxbE_IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sZFfnY3NIFEA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042856.121114201@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steffen Maier <maier@linux.vnet.ibm.com>,
        Martin Peschke <mpeschke@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [024/251] zfcp: block queue limits with data router
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0024-zfcp-block-queue-limits-with-data-router.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

[ Upstream commit 5fea4291deacd80188b996d2f555fc6a1940e5d4 ]

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
Cc: <stable@vger.kernel.org> #3.2+
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/s390/scsi/zfcp_scsi.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 7b31e3f..7b35364 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corp. 2002, 2010
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
1.7.10.4


