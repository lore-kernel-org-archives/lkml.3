Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaFYCxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:53:38 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:48460 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaFYCxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:34 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 6/8] staging: rtl8712: remove function get_list_head
Date: Tue, 24 Jun 2014 22:52:39 -0400
Message-Id: <1403664761-15728-6-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-5-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
 <1403664761-15728-4-git-send-email-shack@linux.com>
 <1403664761-15728-5-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_list_head is an inline that returns &list->head.  This patch removes this
inline and directly applies &list->head where applicable.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h       |    5 -----
 drivers/staging/rtl8712/rtl8712_recv.c        |   15 +++++++--------
 drivers/staging/rtl8712/rtl8712_xmit.c        |    4 ++--
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    8 ++++----
 drivers/staging/rtl8712/rtl871x_ioctl_set.c   |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c        |   12 ++++++------
 drivers/staging/rtl8712/rtl871x_recv.c        |    4 ++--
 drivers/staging/rtl8712/rtl871x_sta_mgt.c     |    7 +++----
 drivers/staging/rtl8712/rtl871x_xmit.c        |   16 +++++++---------
 9 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 4f30c4c..cb279b9 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -58,11 +58,6 @@ struct	__queue	{
 		spin_lock_init(&((pqueue)->lock));	\
 	} while (0)
 
-static inline struct list_head *get_list_head(struct  __queue *queue)
-{
-	return &(queue->queue);
-}
-
 #define LIST_CONTAINOR(ptr, type, member) \
 	((type *)((char *)(ptr)-(SIZE_T)(&((type *)0)->member)))
 
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index a5f41f4..b759c9b 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -146,8 +146,7 @@ int r8712_free_recvframe(union recv_frame *precvframe,
 	}
 	spin_lock_irqsave(&pfree_recv_queue->lock, irqL);
 	list_del_init(&(precvframe->u.hdr.list));
-	list_add_tail(&(precvframe->u.hdr.list),
-			 get_list_head(pfree_recv_queue));
+	list_add_tail(&(precvframe->u.hdr.list), &pfree_recv_queue->queue);
 	if (padapter != NULL) {
 		if (pfree_recv_queue == &precvpriv->free_recv_queue)
 				precvpriv->free_recvframe_cnt++;
@@ -208,7 +207,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 	struct  __queue	*pfree_recv_queue;
 
 	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
-	phead = get_list_head(defrag_q);
+	phead = &defrag_q->queue;
 	plist = phead->next;
 	prframe = LIST_CONTAINOR(plist, union recv_frame, u);
 	list_del_init(&prframe->u.list);
@@ -222,7 +221,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 		return NULL;
 	}
 	curfragnum++;
-	plist = get_list_head(defrag_q);
+	plist = &defrag_q->queue;
 	plist = plist->next;
 	data = get_recvframe_data(prframe);
 	while (end_of_queue_search(phead, plist) == false) {
@@ -296,7 +295,7 @@ union recv_frame *r8712_recvframe_chk_defrag(struct _adapter *padapter,
 				}
 			}
 			/* Then enqueue the 0~(n-1) fragment to the defrag_q */
-			phead = get_list_head(pdefrag_q);
+			phead = &pdefrag_q->queue;
 			list_add_tail(&pfhdr->list, phead);
 			prtnframe = NULL;
 		} else {
@@ -311,7 +310,7 @@ union recv_frame *r8712_recvframe_chk_defrag(struct _adapter *padapter,
 		/* the last fragment frame
 		 * enqueue the last fragment */
 		if (pdefrag_q != NULL) {
-			phead = get_list_head(pdefrag_q);
+			phead = &pdefrag_q->queue;
 			list_add_tail(&pfhdr->list, phead);
 			/*call recvframe_defrag to defrag*/
 			precv_frame = recvframe_defrag(padapter, pdefrag_q);
@@ -499,7 +498,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 					&preorder_ctrl->pending_recvframe_queue;
 	struct rx_pkt_attrib *pattrib = &prframe->u.hdr.attrib;
 
-	phead = get_list_head(ppending_recvframe_queue);
+	phead = &ppending_recvframe_queue->queue;
 	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
@@ -528,7 +527,7 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 	struct  __queue *ppending_recvframe_queue =
 			 &preorder_ctrl->pending_recvframe_queue;
 
-	phead = get_list_head(ppending_recvframe_queue);
+	phead = &ppending_recvframe_queue->queue;
 	plist = phead->next;
 	/* Handling some condition for forced indicate case.*/
 	if (bforced == true) {
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index c4078fa..f3d2998 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -166,7 +166,7 @@ static struct xmit_frame *dequeue_one_xmitframe(struct xmit_priv *pxmitpriv,
 	struct list_head *xmitframe_plist, *xmitframe_phead;
 	struct	xmit_frame *pxmitframe = NULL;
 
-	xmitframe_phead = get_list_head(pframe_queue);
+	xmitframe_phead = &pframe_queue->queue;
 	xmitframe_plist = xmitframe_phead->next;
 	if ((end_of_queue_search(xmitframe_phead, xmitframe_plist)) == false) {
 		pxmitframe = LIST_CONTAINOR(xmitframe_plist,
@@ -210,7 +210,7 @@ static struct xmit_frame *dequeue_xframe_ex(struct xmit_priv *pxmitpriv,
 	spin_lock_irqsave(&pxmitpriv->lock, irqL0);
 	for (i = 0; i < entry; i++) {
 		phwxmit = phwxmit_i + inx[i];
-		sta_phead = get_list_head(phwxmit->sta_queue);
+		sta_phead = &phwxmit->sta_queue->queue;
 		sta_plist = sta_phead->next;
 		while ((end_of_queue_search(sta_phead, sta_plist)) == false) {
 			ptxservq = LIST_CONTAINOR(sta_plist, struct tx_servq,
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index cd7d370..e1e95cf 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1078,7 +1078,7 @@ static int r8711_wx_set_wap(struct net_device *dev,
 		return -EINVAL;
 	authmode = padapter->securitypriv.ndisauthtype;
 	spin_lock_irqsave(&queue->lock, irqL);
-	phead = get_list_head(queue);
+	phead = &queue->queue;
 	pmlmepriv->pscanned = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, pmlmepriv->pscanned) == true)
@@ -1227,7 +1227,7 @@ static int r8711_wx_get_scan(struct net_device *dev,
 			break;
 	}
 	spin_lock_irqsave(&queue->lock, irqL);
-	phead = get_list_head(queue);
+	phead = &queue->queue;
 	plist = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, plist) == true)
@@ -1286,7 +1286,7 @@ static int r8711_wx_set_essid(struct net_device *dev,
 		ndis_ssid.SsidLength = len;
 		memcpy(ndis_ssid.Ssid, extra, len);
 		src_ssid = ndis_ssid.Ssid;
-		phead = get_list_head(queue);
+		phead = &queue->queue;
 		pmlmepriv->pscanned = phead->next;
 		while (1) {
 			if (end_of_queue_search(phead, pmlmepriv->pscanned))
@@ -2002,7 +2002,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 	} else
 		 return -EINVAL;
 	spin_lock_irqsave(&(pmlmepriv->scanned_queue.lock), irqL);
-	phead = get_list_head(queue);
+	phead = &queue->queue;
 	plist = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, plist) == true)
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index 87dce03..226f247 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -62,7 +62,7 @@ static u8 do_join(struct _adapter *padapter)
 	struct	mlme_priv	*pmlmepriv = &(padapter->mlmepriv);
 	struct  __queue	*queue	= &(pmlmepriv->scanned_queue);
 
-	phead = get_list_head(queue);
+	phead = &queue->queue;
 	plist = phead->next;
 	pmlmepriv->cur_network.join_res = -2;
 	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 7ca13b9..d37ba7b 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -133,7 +133,7 @@ static void _free_network_nolock(struct mlme_priv *pmlmepriv,
 	if (pnetwork->fixed == true)
 		return;
 	list_del_init(&pnetwork->list);
-	list_add_tail(&pnetwork->list, get_list_head(free_queue));
+	list_add_tail(&pnetwork->list, &free_queue->queue);
 	pmlmepriv->num_of_scanned--;
 }
 
@@ -153,7 +153,7 @@ static struct wlan_network *_r8712_find_network(struct  __queue *scanned_queue,
 	if (is_zero_ether_addr(addr))
 		return NULL;
 	spin_lock_irqsave(&scanned_queue->lock, irqL);
-	phead = get_list_head(scanned_queue);
+	phead = &scanned_queue->queue;
 	plist = phead->next;
 	while (plist != phead) {
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
@@ -174,7 +174,7 @@ static void _free_network_queue(struct _adapter *padapter)
 	struct  __queue *scanned_queue = &pmlmepriv->scanned_queue;
 
 	spin_lock_irqsave(&scanned_queue->lock, irqL);
-	phead = get_list_head(scanned_queue);
+	phead = &scanned_queue->queue;
 	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
@@ -315,7 +315,7 @@ struct	wlan_network *r8712_get_oldest_wlan_network(
 	struct	wlan_network	*pwlan = NULL;
 	struct	wlan_network	*oldest = NULL;
 
-	phead = get_list_head(scanned_queue);
+	phead = &scanned_queue->queue;
 	plist = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, plist) ==  true)
@@ -398,7 +398,7 @@ static void update_scanned_network(struct _adapter *adapter,
 	struct wlan_network *pnetwork = NULL;
 	struct wlan_network *oldest = NULL;
 
-	phead = get_list_head(queue);
+	phead = &queue->queue;
 	plist = phead->next;
 
 	while (1) {
@@ -1138,7 +1138,7 @@ int r8712_select_and_join_from_scan(struct mlme_priv *pmlmepriv)
 
 	adapter = (struct _adapter *)pmlmepriv->nic_hdl;
 	queue = &pmlmepriv->scanned_queue;
-	phead = get_list_head(queue);
+	phead = &queue->queue;
 	pmlmepriv->pscanned = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, pmlmepriv->pscanned) == true) {
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 114e9f3..cc2ca11 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -115,7 +115,7 @@ union recv_frame *r8712_alloc_recvframe(struct  __queue *pfree_recv_queue)
 	if (_queue_empty(pfree_recv_queue) == true)
 		precvframe = NULL;
 	else {
-		phead = get_list_head(pfree_recv_queue);
+		phead = &pfree_recv_queue->queue;
 		plist = phead->next;
 		precvframe = LIST_CONTAINOR(plist, union recv_frame, u);
 		list_del_init(&precvframe->u.hdr.list);
@@ -145,7 +145,7 @@ void r8712_free_recvframe_queue(struct  __queue *pframequeue,
 	struct list_head *plist, *phead;
 
 	spin_lock(&pframequeue->lock);
-	phead = get_list_head(pframequeue);
+	phead = &pframequeue->queue;
 	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		precvframe = LIST_CONTAINOR(plist, union recv_frame, u);
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 7db8921..73ca66e 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -66,8 +66,7 @@ u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
 	for (i = 0; i < NUM_STA; i++) {
 		_init_stainfo(psta);
 		INIT_LIST_HEAD(&(pstapriv->sta_hash[i]));
-		list_add_tail(&psta->list,
-				 get_list_head(&pstapriv->free_sta_queue));
+		list_add_tail(&psta->list, &pstapriv->free_sta_queue.queue);
 		psta++;
 	}
 	INIT_LIST_HEAD(&pstapriv->asoc_list);
@@ -83,7 +82,7 @@ static void mfree_all_stainfo(struct sta_priv *pstapriv)
 	struct sta_info *psta = NULL;
 
 	spin_lock_irqsave(&pstapriv->sta_hash_lock, irqL);
-	phead = get_list_head(&pstapriv->free_sta_queue);
+	phead = &pstapriv->free_sta_queue.queue;
 	plist = phead->next;
 	while ((end_of_queue_search(phead, plist)) == false) {
 		psta = LIST_CONTAINOR(plist, struct sta_info, list);
@@ -208,7 +207,7 @@ void r8712_free_stainfo(struct _adapter *padapter, struct sta_info *psta)
 	}
 	spin_lock(&(pfree_sta_queue->lock));
 	/* insert into free_sta_queue; 20061114 */
-	list_add_tail(&psta->list, get_list_head(pfree_sta_queue));
+	list_add_tail(&psta->list, &pfree_sta_queue->queue);
 	spin_unlock(&(pfree_sta_queue->lock));
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 29a9f50..4b3fa40 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -747,7 +747,7 @@ struct xmit_buf *r8712_alloc_xmitbuf(struct xmit_priv *pxmitpriv)
 	if (_queue_empty(pfree_xmitbuf_queue) == true)
 		pxmitbuf = NULL;
 	else {
-		phead = get_list_head(pfree_xmitbuf_queue);
+		phead = &pfree_xmitbuf_queue->queue;
 		plist = phead->next;
 		pxmitbuf = LIST_CONTAINOR(plist, struct xmit_buf, list);
 		list_del_init(&(pxmitbuf->list));
@@ -767,7 +767,7 @@ int r8712_free_xmitbuf(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 		return _FAIL;
 	spin_lock_irqsave(&pfree_xmitbuf_queue->lock, irqL);
 	list_del_init(&pxmitbuf->list);
-	list_add_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
+	list_add_tail(&(pxmitbuf->list), &pfree_xmitbuf_queue->queue);
 	pxmitpriv->free_xmitbuf_cnt++;
 	spin_unlock_irqrestore(&pfree_xmitbuf_queue->lock, irqL);
 	return _SUCCESS;
@@ -801,7 +801,7 @@ struct xmit_frame *r8712_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 	if (_queue_empty(pfree_xmit_queue) == true)
 		pxframe =  NULL;
 	else {
-		phead = get_list_head(pfree_xmit_queue);
+		phead = &pfree_xmit_queue->queue;
 		plist = phead->next;
 		pxframe = LIST_CONTAINOR(plist, struct xmit_frame, list);
 		list_del_init(&(pxframe->list));
@@ -833,7 +833,7 @@ void r8712_free_xmitframe(struct xmit_priv *pxmitpriv,
 		pndis_pkt = pxmitframe->pkt;
 		pxmitframe->pkt = NULL;
 	}
-	list_add_tail(&pxmitframe->list, get_list_head(pfree_xmit_queue));
+	list_add_tail(&pxmitframe->list, &pfree_xmit_queue->queue);
 	pxmitpriv->free_xmitframe_cnt++;
 	spin_unlock_irqrestore(&pfree_xmit_queue->lock, irqL);
 	if (netif_queue_stopped(padapter->pnetdev))
@@ -857,7 +857,7 @@ void r8712_free_xmitframe_queue(struct xmit_priv *pxmitpriv,
 	struct	xmit_frame	*pxmitframe;
 
 	spin_lock_irqsave(&(pframequeue->lock), irqL);
-	phead = get_list_head(pframequeue);
+	phead = &pframequeue->queue;
 	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		pxmitframe = LIST_CONTAINOR(plist, struct xmit_frame, list);
@@ -940,10 +940,8 @@ sint r8712_xmit_classifier(struct _adapter *padapter,
 		   psta, pattrib->priority);
 	spin_lock_irqsave(&pstapending->lock, irqL0);
 	if (list_empty(&ptxservq->tx_pending))
-		list_add_tail(&ptxservq->tx_pending,
-				 get_list_head(pstapending));
-	list_add_tail(&pxmitframe->list,
-			 get_list_head(&ptxservq->sta_pending));
+		list_add_tail(&ptxservq->tx_pending, &pstapending->queue);
+	list_add_tail(&pxmitframe->list, &ptxservq->sta_pending.queue);
 	ptxservq->qcnt++;
 	spin_unlock_irqrestore(&pstapending->lock, irqL0);
 	return _SUCCESS;
-- 
1.7.9.5

