Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab3GKO0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:26:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43082 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab3GKO0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Maier <maier@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 54/98] [SCSI] zfcp: status read buffers on first adapter open with link down
Date: Thu, 11 Jul 2013 15:24:24 +0100
Message-Id: <1373552708-15235-55-git-send-email-luis.henriques@canonical.com>
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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/scsi/zfcp_aux.c |  5 ++++-
 drivers/s390/scsi/zfcp_fsf.c | 23 ++++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 4f1b10b..3743ac9 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -3,7 +3,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corporation 2002, 2010
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
index 5fdf70b..961e327 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corporation 2002, 2010
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

