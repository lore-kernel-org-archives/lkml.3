Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab3GQWuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:50:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab3GQWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:48:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 004/145] [SCSI] zfcp: status read buffers on first adapter open with link down
Date: Wed, 17 Jul 2013 15:45:36 -0700
Message-Id: <1374101277-7915-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit 9edf7d75ee5f21663a0183d21f702682d0ef132f upstream.

Commit 64deb6efdc5504ce97b5c1c6f281fffbc150bd93
"[SCSI] zfcp: Use status_read_buf_num provided by FCP channel"
started using a value returned by the channel but only evaluated the value
if the fabric link is up.
Commit 8d88cf3f3b9af4713642caeb221b6d6a42019001
"[SCSI] zfcp: Update status read mempool"
introduced mempool resizings based on the above value.
On setting an FCP device online for the very first time since boot, a new
zeroed adapter object is allocated. If the link is down, the number of
status read requests remains zero. Since just the config data exchange is
incomplete, we proceed with adapter open recovery. However, we
unconditionally call mempool_resize with adapter->stat_read_buf_num == 0 in
this case.

This causes a kernel message "kernel BUG at mm/mempool.c:131!" in process
"zfcperp<FCP-device-bus-ID>" with last function mempool_resize in Krnl PSW
and zfcp_erp_thread in the Call Trace.

Don't evaluate channel values which are invalid on link down. The number of
status read requests is always valid, evaluated, and set to a positive
minimum greater than zero. The adapter open recovery can proceed and the
channel has status read buffers to inform us on a future link up event.
While we are not aware of any other code path that could result in mempool
resize attempts of size zero, we still also initialize the number of status
read buffers to be posted to a static minimum number on adapter object
allocation.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/scsi/zfcp_aux.c |  5 ++++-
 drivers/s390/scsi/zfcp_fsf.c | 23 ++++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index f6adde4..3743ac9 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -3,7 +3,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 /*
@@ -23,6 +23,7 @@
  *            Christof Schmitt
  *            Martin Petermann
  *            Sven Schuetz
+ *            Steffen Maier
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -415,6 +416,8 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 	adapter->dma_parms.max_segment_size = ZFCP_QDIO_SBALE_LEN;
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
 
+	adapter->stat_read_buf_num = FSF_STATUS_READS_RECOM;
+
 	if (!zfcp_scsi_adapter_register(adapter))
 		return adapter;
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index ccff8b2..9a6f744 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2013
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -483,12 +483,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 
 	fc_host_port_name(shost) = nsp->fl_wwpn;
 	fc_host_node_name(shost) = nsp->fl_wwnn;
-	fc_host_port_id(shost) = ntoh24(bottom->s_id);
-	fc_host_speed(shost) =
-		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
-	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval & ZFCP_FSF_TIMER_INT_MASK;
 	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
 					 (u16)FSF_STATUS_READS_RECOM);
@@ -496,6 +492,19 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 	if (fc_host_permanent_port_name(shost) == -1)
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 
+	zfcp_scsi_set_prot(adapter);
+
+	/* no error return above here, otherwise must fix call chains */
+	/* do not evaluate invalid fields */
+	if (req->qtcb->header.fsf_status == FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE)
+		return 0;
+
+	fc_host_port_id(shost) = ntoh24(bottom->s_id);
+	fc_host_speed(shost) =
+		zfcp_fsf_convert_portspeed(bottom->fc_link_speed);
+
+	adapter->hydra_version = bottom->adapter_type;
+
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
 		adapter->peer_d_id = ntoh24(bottom->peer_d_id);
@@ -517,8 +526,6 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 		return -EIO;
 	}
 
-	zfcp_scsi_set_prot(adapter);
-
 	return 0;
 }
 
@@ -569,6 +576,8 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 				&adapter->status);
 		zfcp_fsf_link_down_info_eval(req,
 			&qtcb->header.fsf_status_qual.link_down_info);
+		if (zfcp_fsf_exchange_config_evaluate(req))
+			return;
 		break;
 	default:
 		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh3");
-- 
1.8.1.2

