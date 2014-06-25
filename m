Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaFYCxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:53:33 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:37577 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaFYCx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:29 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 4/8] staging: rtl8712: remove wrapper function list_delete
Date: Tue, 24 Jun 2014 22:52:37 -0400
Message-Id: <1403664761-15728-4-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-3-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_delete is just an inline wrapper around list_del_init.  This patch
removes the wrapper and directly uses list_del_init.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h   |    5 -----
 drivers/staging/rtl8712/rtl8712_recv.c    |    8 ++++----
 drivers/staging/rtl8712/rtl8712_xmit.c    |    4 ++--
 drivers/staging/rtl8712/rtl871x_cmd.c     |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c    |    6 +++---
 drivers/staging/rtl8712/rtl871x_recv.c    |    2 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c |   12 ++++++------
 drivers/staging/rtl8712/rtl871x_xmit.c    |    8 ++++----
 8 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index bc5e922..1a137ce 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -71,11 +71,6 @@ static inline struct list_head *get_list_head(struct  __queue *queue)
 #define LIST_CONTAINOR(ptr, type, member) \
 	((type *)((char *)(ptr)-(SIZE_T)(&((type *)0)->member)))
 
-static inline void list_delete(struct list_head *plist)
-{
-	list_del_init(plist);
-}
-
 static inline void _init_timer(struct timer_list *ptimer,
 			       struct  net_device *padapter,
 			       void *pfunc, void *cntx)
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index b510312..3c9d2e0 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -145,7 +145,7 @@ int r8712_free_recvframe(union recv_frame *precvframe,
 		precvframe->u.hdr.pkt = NULL;
 	}
 	spin_lock_irqsave(&pfree_recv_queue->lock, irqL);
-	list_delete(&(precvframe->u.hdr.list));
+	list_del_init(&(precvframe->u.hdr.list));
 	list_add_tail(&(precvframe->u.hdr.list),
 			 get_list_head(pfree_recv_queue));
 	if (padapter != NULL) {
@@ -211,7 +211,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 	phead = get_list_head(defrag_q);
 	plist = get_next(phead);
 	prframe = LIST_CONTAINOR(plist, union recv_frame, u);
-	list_delete(&prframe->u.list);
+	list_del_init(&prframe->u.list);
 	pfhdr = &prframe->u.hdr;
 	curfragnum = 0;
 	if (curfragnum != pfhdr->attrib.frag_num) {
@@ -511,7 +511,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 		else
 			break;
 	}
-	list_delete(&(prframe->u.hdr.list));
+	list_del_init(&(prframe->u.hdr.list));
 	list_add_tail(&(prframe->u.hdr.list), plist);
 	return true;
 }
@@ -547,7 +547,7 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 		pattrib = &prframe->u.hdr.attrib;
 		if (!SN_LESS(preorder_ctrl->indicate_seq, pattrib->seq_num)) {
 			plist = get_next(plist);
-			list_delete(&(prframe->u.hdr.list));
+			list_del_init(&(prframe->u.hdr.list));
 			if (SN_EQUAL(preorder_ctrl->indicate_seq,
 			    pattrib->seq_num))
 				preorder_ctrl->indicate_seq =
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index 4e3f094..56aa209 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -171,7 +171,7 @@ static struct xmit_frame *dequeue_one_xmitframe(struct xmit_priv *pxmitpriv,
 	if ((end_of_queue_search(xmitframe_phead, xmitframe_plist)) == false) {
 		pxmitframe = LIST_CONTAINOR(xmitframe_plist,
 			     struct xmit_frame, list);
-		list_delete(&pxmitframe->list);
+		list_del_init(&pxmitframe->list);
 		ptxservq->qcnt--;
 		phwxmit->txcmdcnt++;
 	}
@@ -226,7 +226,7 @@ static struct xmit_frame *dequeue_xframe_ex(struct xmit_priv *pxmitpriv,
 			/*Remove sta node when there are no pending packets.*/
 			if (_queue_empty(pframe_queue)) {
 				/*must be done after get_next and before break*/
-				list_delete(&ptxservq->tx_pending);
+				list_del_init(&ptxservq->tx_pending);
 			}
 		}
 	}
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index cae8ee6..338bb14 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -142,7 +142,7 @@ static struct cmd_obj *_dequeue_cmd(struct  __queue *queue)
 	else {
 		obj = LIST_CONTAINOR(get_next(&(queue->queue)),
 				     struct cmd_obj, list);
-		list_delete(&obj->list);
+		list_del_init(&obj->list);
 	}
 	spin_unlock_irqrestore(&(queue->lock), irqL);
 	return obj;
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 05ff7dd..943d25a 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -94,7 +94,7 @@ struct wlan_network *_r8712_alloc_network(struct mlme_priv *pmlmepriv)
 	spin_lock_irqsave(&free_queue->lock, irqL);
 	plist = get_next(&(free_queue->queue));
 	pnetwork = LIST_CONTAINOR(plist , struct wlan_network, list);
-	list_delete(&pnetwork->list);
+	list_del_init(&pnetwork->list);
 	pnetwork->last_scanned = jiffies;
 	pmlmepriv->num_of_scanned++;
 	spin_unlock_irqrestore(&free_queue->lock, irqL);
@@ -117,7 +117,7 @@ static void _free_network(struct mlme_priv *pmlmepriv,
 	if (delta_time < SCANQUEUE_LIFETIME)
 		return;
 	spin_lock_irqsave(&free_queue->lock, irqL);
-	list_delete(&pnetwork->list);
+	list_del_init(&pnetwork->list);
 	list_add_tail(&pnetwork->list, &free_queue->queue);
 	pmlmepriv->num_of_scanned--;
 	spin_unlock_irqrestore(&free_queue->lock, irqL);
@@ -132,7 +132,7 @@ static void _free_network_nolock(struct mlme_priv *pmlmepriv,
 		return;
 	if (pnetwork->fixed == true)
 		return;
-	list_delete(&pnetwork->list);
+	list_del_init(&pnetwork->list);
 	list_add_tail(&pnetwork->list, get_list_head(free_queue));
 	pmlmepriv->num_of_scanned--;
 }
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index cd31982..246b8ce 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -118,7 +118,7 @@ union recv_frame *r8712_alloc_recvframe(struct  __queue *pfree_recv_queue)
 		phead = get_list_head(pfree_recv_queue);
 		plist = get_next(phead);
 		precvframe = LIST_CONTAINOR(plist, union recv_frame, u);
-		list_delete(&precvframe->u.hdr.list);
+		list_del_init(&precvframe->u.hdr.list);
 		padapter = precvframe->u.hdr.adapter;
 		if (padapter != NULL) {
 			precvpriv = &padapter->recvpriv;
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index e7f3cdb..92d5327 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -127,7 +127,7 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 	else {
 		psta = LIST_CONTAINOR(get_next(&pfree_sta_queue->queue),
 				      struct sta_info, list);
-		list_delete(&(psta->list));
+		list_del_init(&(psta->list));
 		tmp_aid = psta->aid;
 		_init_stainfo(psta);
 		memcpy(psta->hwaddr, hwaddr, ETH_ALEN);
@@ -181,21 +181,21 @@ void r8712_free_stainfo(struct _adapter *padapter, struct sta_info *psta)
 	pstaxmitpriv = &psta->sta_xmitpriv;
 	spin_lock_irqsave(&(pxmitpriv->vo_pending.lock), irqL0);
 	r8712_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->vo_q.sta_pending);
-	list_delete(&(pstaxmitpriv->vo_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->vo_q.tx_pending));
 	spin_unlock_irqrestore(&(pxmitpriv->vo_pending.lock), irqL0);
 	spin_lock_irqsave(&(pxmitpriv->vi_pending.lock), irqL0);
 	r8712_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->vi_q.sta_pending);
-	list_delete(&(pstaxmitpriv->vi_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->vi_q.tx_pending));
 	spin_unlock_irqrestore(&(pxmitpriv->vi_pending.lock), irqL0);
 	spin_lock_irqsave(&(pxmitpriv->bk_pending.lock), irqL0);
 	r8712_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->bk_q.sta_pending);
-	list_delete(&(pstaxmitpriv->bk_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->bk_q.tx_pending));
 	spin_unlock_irqrestore(&(pxmitpriv->bk_pending.lock), irqL0);
 	spin_lock_irqsave(&(pxmitpriv->be_pending.lock), irqL0);
 	r8712_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->be_q.sta_pending);
-	list_delete(&(pstaxmitpriv->be_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->be_q.tx_pending));
 	spin_unlock_irqrestore(&(pxmitpriv->be_pending.lock), irqL0);
-	list_delete(&psta->hash_list);
+	list_del_init(&psta->hash_list);
 	pstapriv->asoc_sta_count--;
 	/* re-init sta_info; 20061114 */
 	_r8712_init_sta_xmit_priv(&psta->sta_xmitpriv);
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 71d0d0d..2e79e4e 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -750,7 +750,7 @@ struct xmit_buf *r8712_alloc_xmitbuf(struct xmit_priv *pxmitpriv)
 		phead = get_list_head(pfree_xmitbuf_queue);
 		plist = get_next(phead);
 		pxmitbuf = LIST_CONTAINOR(plist, struct xmit_buf, list);
-		list_delete(&(pxmitbuf->list));
+		list_del_init(&(pxmitbuf->list));
 	}
 	if (pxmitbuf !=  NULL)
 		pxmitpriv->free_xmitbuf_cnt--;
@@ -766,7 +766,7 @@ int r8712_free_xmitbuf(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 	if (pxmitbuf == NULL)
 		return _FAIL;
 	spin_lock_irqsave(&pfree_xmitbuf_queue->lock, irqL);
-	list_delete(&pxmitbuf->list);
+	list_del_init(&pxmitbuf->list);
 	list_add_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
 	pxmitpriv->free_xmitbuf_cnt++;
 	spin_unlock_irqrestore(&pfree_xmitbuf_queue->lock, irqL);
@@ -804,7 +804,7 @@ struct xmit_frame *r8712_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 		phead = get_list_head(pfree_xmit_queue);
 		plist = get_next(phead);
 		pxframe = LIST_CONTAINOR(plist, struct xmit_frame, list);
-		list_delete(&(pxframe->list));
+		list_del_init(&(pxframe->list));
 	}
 	if (pxframe !=  NULL) {
 		pxmitpriv->free_xmitframe_cnt--;
@@ -828,7 +828,7 @@ void r8712_free_xmitframe(struct xmit_priv *pxmitpriv,
 	if (pxmitframe == NULL)
 		return;
 	spin_lock_irqsave(&pfree_xmit_queue->lock, irqL);
-	list_delete(&pxmitframe->list);
+	list_del_init(&pxmitframe->list);
 	if (pxmitframe->pkt) {
 		pndis_pkt = pxmitframe->pkt;
 		pxmitframe->pkt = NULL;
-- 
1.7.9.5

