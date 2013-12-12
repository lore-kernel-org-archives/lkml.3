Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3LLXtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:49:05 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:46743 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3LLXtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:49:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,475,1384300800"; 
   d="scan'208";a="81618621"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next v2 9/9] xen-netback: Aggregate TX unmap operations
Date: Thu, 12 Dec 2013 23:48:17 +0000
Message-ID: <1386892097-15502-10-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com>
References: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unmapping causes TLB flushing, therefore we should make it in the largest
possible batches. However we shouldn't starve the guest for too long. So if
the guest has space for at least two big packets and we don't have at least a
quarter ring to unmap, delay it for at most 1 milisec.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 drivers/net/xen-netback/common.h  |    2 ++
 drivers/net/xen-netback/netback.c |   30 +++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 05fa6be..a834818 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -111,6 +111,8 @@ struct xenvif {
 	u16 dealloc_ring[MAX_PENDING_REQS];
 	struct task_struct *dealloc_task;
 	wait_queue_head_t dealloc_wq;
+	struct timer_list dealloc_delay;
+	bool dealloc_delay_timed_out;
 
 	/* Use kthread for guest RX */
 	struct task_struct *task;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 5252416..f4a9876 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -136,6 +136,11 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif *vif)
 		vif->pending_prod + vif->pending_cons;
 }
 
+static inline pending_ring_idx_t nr_free_slots(struct xen_netif_tx_back_ring *ring)
+{
+	return ring->nr_ents -	(ring->sring->req_prod - ring->rsp_prod_pvt);
+}
+
 bool xenvif_rx_ring_slots_available(struct xenvif *vif, int needed)
 {
 	RING_IDX prod, cons;
@@ -1898,10 +1903,33 @@ static inline int tx_work_todo(struct xenvif *vif)
 	return 0;
 }
 
+static void xenvif_dealloc_delay(unsigned long data)
+{
+	struct xenvif *vif = (struct xenvif *)data;
+
+	vif->dealloc_delay_timed_out = true;
+	wake_up(&vif->dealloc_wq);
+}
+
 static inline int tx_dealloc_work_todo(struct xenvif *vif)
 {
-	if (vif->dealloc_cons != vif->dealloc_prod)
+	if (vif->dealloc_cons != vif->dealloc_prod) {
+		if ((nr_free_slots(&vif->tx) > 2 * XEN_NETBK_LEGACY_SLOTS_MAX) &&
+			(vif->dealloc_prod - vif->dealloc_cons < MAX_PENDING_REQS / 4) &&
+			!vif->dealloc_delay_timed_out) {
+			if (!timer_pending(&vif->dealloc_delay)) {
+				vif->dealloc_delay.function = xenvif_dealloc_delay;
+				vif->dealloc_delay.data = (unsigned long)vif;
+				mod_timer(&vif->dealloc_delay,
+					jiffies + msecs_to_jiffies(1));
+
+			}
+			return 0;
+		}
+		del_timer_sync(&vif->dealloc_delay);
+		vif->dealloc_delay_timed_out = false;
 		return 1;
+	}
 
 	return 0;
 }
