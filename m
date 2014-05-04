Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaEDQmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:42:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaEDPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Moni Shoua <monis@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 087/158] IB/core: Dont resolve passive side RoCE L2 address in CMA REQ handler
Date: Sun,  4 May 2014 11:39:56 -0400
Message-Id: <20140504154041.718112657@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moni Shoua <monis@mellanox.com>

commit b2853fd6c2d0f383dbdf7427e263eb576a633867 upstream.

The code that resolves the passive side source MAC within the rdma_cm
connection request handler was both redundant and buggy, so remove it.

It was redundant since later, when an RC QP is modified to RTR state,
the resolution will take place in the ib_core module.  It was buggy
because this callback also deals with UD SIDR exchange, for which we
incorrectly looked at the REQ member of the CM event and dereferenced
a random value.

Fixes: dd5f03beb4f7 ("IB/core: Ethernet L2 attributes in verbs/cm structures")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cm.c  |   17 -----------------
 drivers/infiniband/core/cma.c |   26 --------------------------
 include/rdma/ib_cm.h          |    1 -
 3 files changed, 44 deletions(-)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -349,23 +349,6 @@ static void cm_init_av_for_response(stru
 			   grh, &av->ah_attr);
 }
 
-int ib_update_cm_av(struct ib_cm_id *id, const u8 *smac, const u8 *alt_smac)
-{
-	struct cm_id_private *cm_id_priv;
-
-	cm_id_priv = container_of(id, struct cm_id_private, id);
-
-	if (smac != NULL)
-		memcpy(cm_id_priv->av.smac, smac, sizeof(cm_id_priv->av.smac));
-
-	if (alt_smac != NULL)
-		memcpy(cm_id_priv->alt_av.smac, alt_smac,
-		       sizeof(cm_id_priv->alt_av.smac));
-
-	return 0;
-}
-EXPORT_SYMBOL(ib_update_cm_av);
-
 static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 {
 	struct cm_device *cm_dev;
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1284,15 +1284,6 @@ static int cma_req_handler(struct ib_cm_
 	struct rdma_id_private *listen_id, *conn_id;
 	struct rdma_cm_event event;
 	int offset, ret;
-	u8 smac[ETH_ALEN];
-	u8 alt_smac[ETH_ALEN];
-	u8 *psmac = smac;
-	u8 *palt_smac = alt_smac;
-	int is_iboe = ((rdma_node_get_transport(cm_id->device->node_type) ==
-			RDMA_TRANSPORT_IB) &&
-		       (rdma_port_get_link_layer(cm_id->device,
-			ib_event->param.req_rcvd.port) ==
-			IB_LINK_LAYER_ETHERNET));
 
 	listen_id = cm_id->context;
 	if (!cma_check_req_qp_type(&listen_id->id, ib_event))
@@ -1336,28 +1327,11 @@ static int cma_req_handler(struct ib_cm_
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret)
 		goto err3;
-
-	if (is_iboe) {
-		if (ib_event->param.req_rcvd.primary_path != NULL)
-			rdma_addr_find_smac_by_sgid(
-				&ib_event->param.req_rcvd.primary_path->sgid,
-				psmac, NULL);
-		else
-			psmac = NULL;
-		if (ib_event->param.req_rcvd.alternate_path != NULL)
-			rdma_addr_find_smac_by_sgid(
-				&ib_event->param.req_rcvd.alternate_path->sgid,
-				palt_smac, NULL);
-		else
-			palt_smac = NULL;
-	}
 	/*
 	 * Acquire mutex to prevent user executing rdma_destroy_id()
 	 * while we're accessing the cm_id.
 	 */
 	mutex_lock(&lock);
-	if (is_iboe)
-		ib_update_cm_av(cm_id, psmac, palt_smac);
 	if (cma_comp(conn_id, RDMA_CM_CONNECT) &&
 	    (conn_id->id.qp_type != IB_QPT_UD))
 		ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -601,5 +601,4 @@ struct ib_cm_sidr_rep_param {
 int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id,
 			struct ib_cm_sidr_rep_param *param);
 
-int ib_update_cm_av(struct ib_cm_id *id, const u8 *smac, const u8 *alt_smac);
 #endif /* IB_CM_H */


