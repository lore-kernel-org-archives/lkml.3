Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaFYCyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:54:25 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:35716 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaFYCxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:32 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 5/8] staging: rtl8712: remove wrapper function get_next
Date: Tue, 24 Jun 2014 22:52:38 -0400
Message-Id: <1403664761-15728-5-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-4-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
 <1403664761-15728-4-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_next is just an inline wrapper around return list->next.  This
patch removes the wrapper and directly uses list->next where
applicable.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h       |    5 -----
 drivers/staging/rtl8712/rtl8712_recv.c        |   14 +++++++-------
 drivers/staging/rtl8712/rtl8712_xmit.c        |   10 ++++++----
 drivers/staging/rtl8712/rtl871x_cmd.c         |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |   16 ++++++++--------
 drivers/staging/rtl8712/rtl871x_ioctl_set.c   |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c        |   22 +++++++++++-----------
 drivers/staging/rtl8712/rtl871x_recv.c        |    6 +++---
 drivers/staging/rtl8712/rtl871x_sta_mgt.c     |   14 +++++++-------
 drivers/staging/rtl8712/rtl871x_xmit.c        |    8 ++++----
 10 files changed, 48 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 1a137ce..4f30c4c 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -58,11 +58,6 @@ struct	__queue	{
 		spin_lock_init(&((pqueue)->lock));	\
 	} while (0)
 
-static inline struct list_head *get_next(struct list_head *list)
-{
-	return list->next;
-}
-
 static inline struct list_head *get_list_head(struct  __queue *queue)
 {
 	return &(queue->queue);
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 3c9d2e0..a5f41f4 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -209,7 +209,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 
 	pfree_recv_queue = &adapter->recvpriv.free_recv_queue;
 	phead = get_list_head(defrag_q);
-	plist = get_next(phead);
+	plist = phead->next;
 	prframe = LIST_CONTAINOR(plist, union recv_frame, u);
 	list_del_init(&prframe->u.list);
 	pfhdr = &prframe->u.hdr;
@@ -223,7 +223,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 	}
 	curfragnum++;
 	plist = get_list_head(defrag_q);
-	plist = get_next(plist);
+	plist = plist->next;
 	data = get_recvframe_data(prframe);
 	while (end_of_queue_search(phead, plist) == false) {
 		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
@@ -247,7 +247,7 @@ static union recv_frame *recvframe_defrag(struct _adapter *adapter,
 		memcpy(pfhdr->rx_tail, pnfhdr->rx_data, pnfhdr->len);
 		recvframe_put(prframe, pnfhdr->len);
 		pfhdr->attrib.icv_len = pnfhdr->attrib.icv_len;
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 	/* free the defrag_q queue and return the prframe */
 	r8712_free_recvframe_queue(defrag_q, pfree_recv_queue);
@@ -500,12 +500,12 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 	struct rx_pkt_attrib *pattrib = &prframe->u.hdr.attrib;
 
 	phead = get_list_head(ppending_recvframe_queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		pnextrframe = LIST_CONTAINOR(plist, union recv_frame, u);
 		pnextattrib = &pnextrframe->u.hdr.attrib;
 		if (SN_LESS(pnextattrib->seq_num, pattrib->seq_num))
-			plist = get_next(plist);
+			plist = plist->next;
 		else if (SN_EQUAL(pnextattrib->seq_num, pattrib->seq_num))
 			return false;
 		else
@@ -529,7 +529,7 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 			 &preorder_ctrl->pending_recvframe_queue;
 
 	phead = get_list_head(ppending_recvframe_queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	/* Handling some condition for forced indicate case.*/
 	if (bforced == true) {
 		if (list_empty(phead))
@@ -546,7 +546,7 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 		prframe = LIST_CONTAINOR(plist, union recv_frame, u);
 		pattrib = &prframe->u.hdr.attrib;
 		if (!SN_LESS(preorder_ctrl->indicate_seq, pattrib->seq_num)) {
-			plist = get_next(plist);
+			plist = plist->next;
 			list_del_init(&(prframe->u.hdr.list));
 			if (SN_EQUAL(preorder_ctrl->indicate_seq,
 			    pattrib->seq_num))
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index 56aa209..c4078fa 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -167,7 +167,7 @@ static struct xmit_frame *dequeue_one_xmitframe(struct xmit_priv *pxmitpriv,
 	struct	xmit_frame *pxmitframe = NULL;
 
 	xmitframe_phead = get_list_head(pframe_queue);
-	xmitframe_plist = get_next(xmitframe_phead);
+	xmitframe_plist = xmitframe_phead->next;
 	if ((end_of_queue_search(xmitframe_phead, xmitframe_plist)) == false) {
 		pxmitframe = LIST_CONTAINOR(xmitframe_plist,
 			     struct xmit_frame, list);
@@ -211,7 +211,7 @@ static struct xmit_frame *dequeue_xframe_ex(struct xmit_priv *pxmitpriv,
 	for (i = 0; i < entry; i++) {
 		phwxmit = phwxmit_i + inx[i];
 		sta_phead = get_list_head(phwxmit->sta_queue);
-		sta_plist = get_next(sta_phead);
+		sta_plist = sta_phead->next;
 		while ((end_of_queue_search(sta_phead, sta_plist)) == false) {
 			ptxservq = LIST_CONTAINOR(sta_plist, struct tx_servq,
 				  tx_pending);
@@ -222,10 +222,12 @@ static struct xmit_frame *dequeue_xframe_ex(struct xmit_priv *pxmitpriv,
 				phwxmit->accnt--;
 				goto exit_dequeue_xframe_ex;
 			}
-			sta_plist = get_next(sta_plist);
+			sta_plist = sta_plist->next;
 			/*Remove sta node when there are no pending packets.*/
 			if (_queue_empty(pframe_queue)) {
-				/*must be done after get_next and before break*/
+				/* must be done after sta_plist->next
+				 * and before break
+				 */
 				list_del_init(&ptxservq->tx_pending);
 			}
 		}
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 338bb14..d9c1561 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -140,7 +140,7 @@ static struct cmd_obj *_dequeue_cmd(struct  __queue *queue)
 	if (list_empty(&(queue->queue)))
 		obj = NULL;
 	else {
-		obj = LIST_CONTAINOR(get_next(&(queue->queue)),
+		obj = LIST_CONTAINOR(queue->queue.next,
 				     struct cmd_obj, list);
 		list_del_init(&obj->list);
 	}
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 6d6f15d..cd7d370 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1079,13 +1079,13 @@ static int r8711_wx_set_wap(struct net_device *dev,
 	authmode = padapter->securitypriv.ndisauthtype;
 	spin_lock_irqsave(&queue->lock, irqL);
 	phead = get_list_head(queue);
-	pmlmepriv->pscanned = get_next(phead);
+	pmlmepriv->pscanned = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, pmlmepriv->pscanned) == true)
 			break;
 		pnetwork = LIST_CONTAINOR(pmlmepriv->pscanned,
 			   struct wlan_network, list);
-		pmlmepriv->pscanned = get_next(pmlmepriv->pscanned);
+		pmlmepriv->pscanned = pmlmepriv->pscanned->next;
 		dst_bssid = pnetwork->network.MacAddress;
 		if (!memcmp(dst_bssid, temp->sa_data, ETH_ALEN)) {
 			r8712_set_802_11_infrastructure_mode(padapter,
@@ -1228,7 +1228,7 @@ static int r8711_wx_get_scan(struct net_device *dev,
 	}
 	spin_lock_irqsave(&queue->lock, irqL);
 	phead = get_list_head(queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, plist) == true)
 			break;
@@ -1238,7 +1238,7 @@ static int r8711_wx_get_scan(struct net_device *dev,
 		}
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
 		ev = translate_scan(padapter, a, pnetwork, ev, stop);
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 	spin_unlock_irqrestore(&queue->lock, irqL);
 	wrqu->data.length = ev - extra;
@@ -1287,13 +1287,13 @@ static int r8711_wx_set_essid(struct net_device *dev,
 		memcpy(ndis_ssid.Ssid, extra, len);
 		src_ssid = ndis_ssid.Ssid;
 		phead = get_list_head(queue);
-		pmlmepriv->pscanned = get_next(phead);
+		pmlmepriv->pscanned = phead->next;
 		while (1) {
 			if (end_of_queue_search(phead, pmlmepriv->pscanned))
 				break;
 			pnetwork = LIST_CONTAINOR(pmlmepriv->pscanned,
 				   struct wlan_network, list);
-			pmlmepriv->pscanned = get_next(pmlmepriv->pscanned);
+			pmlmepriv->pscanned = pmlmepriv->pscanned->next;
 			dst_ssid = pnetwork->network.Ssid.Ssid;
 			if ((!memcmp(dst_ssid, src_ssid, ndis_ssid.SsidLength))
 			    && (pnetwork->network.Ssid.SsidLength ==
@@ -2003,7 +2003,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 		 return -EINVAL;
 	spin_lock_irqsave(&(pmlmepriv->scanned_queue.lock), irqL);
 	phead = get_list_head(queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, plist) == true)
 			break;
@@ -2031,7 +2031,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 				break;
 			}
 		}
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 	spin_unlock_irqrestore(&(pmlmepriv->scanned_queue.lock), irqL);
 	if (pdata->length >= 34) {
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index 53a7c8c..87dce03 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -63,7 +63,7 @@ static u8 do_join(struct _adapter *padapter)
 	struct  __queue	*queue	= &(pmlmepriv->scanned_queue);
 
 	phead = get_list_head(queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	pmlmepriv->cur_network.join_res = -2;
 	pmlmepriv->fw_state |= _FW_UNDER_LINKING;
 	pmlmepriv->pscanned = plist;
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 943d25a..7ca13b9 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -92,7 +92,7 @@ struct wlan_network *_r8712_alloc_network(struct mlme_priv *pmlmepriv)
 	if (_queue_empty(free_queue) == true)
 		return NULL;
 	spin_lock_irqsave(&free_queue->lock, irqL);
-	plist = get_next(&(free_queue->queue));
+	plist = free_queue->queue.next;
 	pnetwork = LIST_CONTAINOR(plist , struct wlan_network, list);
 	list_del_init(&pnetwork->list);
 	pnetwork->last_scanned = jiffies;
@@ -154,10 +154,10 @@ static struct wlan_network *_r8712_find_network(struct  __queue *scanned_queue,
 		return NULL;
 	spin_lock_irqsave(&scanned_queue->lock, irqL);
 	phead = get_list_head(scanned_queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (plist != phead) {
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
-		plist = get_next(plist);
+		plist = plist->next;
 		if (!memcmp(addr, pnetwork->network.MacAddress, ETH_ALEN))
 			break;
 	}
@@ -175,10 +175,10 @@ static void _free_network_queue(struct _adapter *padapter)
 
 	spin_lock_irqsave(&scanned_queue->lock, irqL);
 	phead = get_list_head(scanned_queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
-		plist = get_next(plist);
+		plist = plist->next;
 		_free_network(pmlmepriv, pnetwork);
 	}
 	spin_unlock_irqrestore(&scanned_queue->lock, irqL);
@@ -316,7 +316,7 @@ struct	wlan_network *r8712_get_oldest_wlan_network(
 	struct	wlan_network	*oldest = NULL;
 
 	phead = get_list_head(scanned_queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, plist) ==  true)
 			break;
@@ -327,7 +327,7 @@ struct	wlan_network *r8712_get_oldest_wlan_network(
 			    (unsigned long)pwlan->last_scanned))
 				oldest = pwlan;
 		}
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 	return oldest;
 }
@@ -399,7 +399,7 @@ static void update_scanned_network(struct _adapter *adapter,
 	struct wlan_network *oldest = NULL;
 
 	phead = get_list_head(queue);
-	plist = get_next(phead);
+	plist = phead->next;
 
 	while (1) {
 		if (end_of_queue_search(phead, plist) == true)
@@ -413,7 +413,7 @@ static void update_scanned_network(struct _adapter *adapter,
 				(unsigned long)pnetwork->last_scanned))
 			oldest = pnetwork;
 
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 
 
@@ -1139,7 +1139,7 @@ int r8712_select_and_join_from_scan(struct mlme_priv *pmlmepriv)
 	adapter = (struct _adapter *)pmlmepriv->nic_hdl;
 	queue = &pmlmepriv->scanned_queue;
 	phead = get_list_head(queue);
-	pmlmepriv->pscanned = get_next(phead);
+	pmlmepriv->pscanned = phead->next;
 	while (1) {
 		if (end_of_queue_search(phead, pmlmepriv->pscanned) == true) {
 			if ((pmlmepriv->assoc_by_rssi == true) &&
@@ -1153,7 +1153,7 @@ int r8712_select_and_join_from_scan(struct mlme_priv *pmlmepriv)
 					  struct wlan_network, list);
 		if (pnetwork == NULL)
 			return _FAIL;
-		pmlmepriv->pscanned = get_next(pmlmepriv->pscanned);
+		pmlmepriv->pscanned = pmlmepriv->pscanned->next;
 		if (pmlmepriv->assoc_by_bssid == true) {
 			dst_ssid = pnetwork->network.MacAddress;
 			src_ssid = pmlmepriv->assoc_bssid;
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 246b8ce..114e9f3 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -116,7 +116,7 @@ union recv_frame *r8712_alloc_recvframe(struct  __queue *pfree_recv_queue)
 		precvframe = NULL;
 	else {
 		phead = get_list_head(pfree_recv_queue);
-		plist = get_next(phead);
+		plist = phead->next;
 		precvframe = LIST_CONTAINOR(plist, union recv_frame, u);
 		list_del_init(&precvframe->u.hdr.list);
 		padapter = precvframe->u.hdr.adapter;
@@ -146,10 +146,10 @@ void r8712_free_recvframe_queue(struct  __queue *pframequeue,
 
 	spin_lock(&pframequeue->lock);
 	phead = get_list_head(pframequeue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		precvframe = LIST_CONTAINOR(plist, union recv_frame, u);
-		plist = get_next(plist);
+		plist = plist->next;
 		r8712_free_recvframe(precvframe, pfree_recv_queue);
 	}
 	spin_unlock(&pframequeue->lock);
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 92d5327..7db8921 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -84,10 +84,10 @@ static void mfree_all_stainfo(struct sta_priv *pstapriv)
 
 	spin_lock_irqsave(&pstapriv->sta_hash_lock, irqL);
 	phead = get_list_head(&pstapriv->free_sta_queue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while ((end_of_queue_search(phead, plist)) == false) {
 		psta = LIST_CONTAINOR(plist, struct sta_info, list);
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 
 	spin_unlock_irqrestore(&pstapriv->sta_hash_lock, irqL);
@@ -125,7 +125,7 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 	if (_queue_empty(pfree_sta_queue) == true)
 		psta = NULL;
 	else {
-		psta = LIST_CONTAINOR(get_next(&pfree_sta_queue->queue),
+		psta = LIST_CONTAINOR(pfree_sta_queue->queue.next,
 				      struct sta_info, list);
 		list_del_init(&(psta->list));
 		tmp_aid = psta->aid;
@@ -227,11 +227,11 @@ void r8712_free_all_stainfo(struct _adapter *padapter)
 	spin_lock_irqsave(&pstapriv->sta_hash_lock, irqL);
 	for (index = 0; index < NUM_STA; index++) {
 		phead = &(pstapriv->sta_hash[index]);
-		plist = get_next(phead);
+		plist = phead->next;
 		while ((end_of_queue_search(phead, plist)) == false) {
 			psta = LIST_CONTAINOR(plist,
 					      struct sta_info, hash_list);
-			plist = get_next(plist);
+			plist = plist->next;
 			if (pbcmc_stainfo != psta)
 				r8712_free_stainfo(padapter , psta);
 		}
@@ -252,7 +252,7 @@ struct sta_info *r8712_get_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 	index = wifi_mac_hash(hwaddr);
 	spin_lock_irqsave(&pstapriv->sta_hash_lock, irqL);
 	phead = &(pstapriv->sta_hash[index]);
-	plist = get_next(phead);
+	plist = phead->next;
 	while ((end_of_queue_search(phead, plist)) == false) {
 		psta = LIST_CONTAINOR(plist, struct sta_info, hash_list);
 		if ((!memcmp(psta->hwaddr, hwaddr, ETH_ALEN))) {
@@ -260,7 +260,7 @@ struct sta_info *r8712_get_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 			break;
 		}
 		psta = NULL;
-		plist = get_next(plist);
+		plist = plist->next;
 	}
 	spin_unlock_irqrestore(&pstapriv->sta_hash_lock, irqL);
 	return psta;
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 2e79e4e..29a9f50 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -748,7 +748,7 @@ struct xmit_buf *r8712_alloc_xmitbuf(struct xmit_priv *pxmitpriv)
 		pxmitbuf = NULL;
 	else {
 		phead = get_list_head(pfree_xmitbuf_queue);
-		plist = get_next(phead);
+		plist = phead->next;
 		pxmitbuf = LIST_CONTAINOR(plist, struct xmit_buf, list);
 		list_del_init(&(pxmitbuf->list));
 	}
@@ -802,7 +802,7 @@ struct xmit_frame *r8712_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 		pxframe =  NULL;
 	else {
 		phead = get_list_head(pfree_xmit_queue);
-		plist = get_next(phead);
+		plist = phead->next;
 		pxframe = LIST_CONTAINOR(plist, struct xmit_frame, list);
 		list_del_init(&(pxframe->list));
 	}
@@ -858,10 +858,10 @@ void r8712_free_xmitframe_queue(struct xmit_priv *pxmitpriv,
 
 	spin_lock_irqsave(&(pframequeue->lock), irqL);
 	phead = get_list_head(pframequeue);
-	plist = get_next(phead);
+	plist = phead->next;
 	while (end_of_queue_search(phead, plist) == false) {
 		pxmitframe = LIST_CONTAINOR(plist, struct xmit_frame, list);
-		plist = get_next(plist);
+		plist = plist->next;
 		r8712_free_xmitframe(pxmitpriv, pxmitframe);
 	}
 	spin_unlock_irqrestore(&(pframequeue->lock), irqL);
-- 
1.7.9.5

