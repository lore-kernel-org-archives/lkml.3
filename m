Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaFVIhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:37:48 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65454 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaFVIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:25 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 21/42] staging: rtl8188eu: Replace rtw_list_delete() with list_del_init()
Date: Sun, 22 Jun 2014 14:06:27 +0530
Message-Id: <1403426208-12413-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c           |   12 +++----
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |   10 +++---
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c     |   10 +++---
 drivers/staging/rtl8188eu/core/rtw_recv.c         |   14 ++++----
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |   16 ++++-----
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |   36 ++++++++++-----------
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    4 +--
 drivers/staging/rtl8188eu/include/osdep_service.h |    7 ----
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    2 +-
 10 files changed, 53 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index c3c4649..1987185 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -295,7 +295,7 @@ void	expire_timeout_chk(struct adapter *padapter)
 		if (psta->expire_to > 0) {
 			psta->expire_to--;
 			if (psta->expire_to == 0) {
-				rtw_list_delete(&psta->auth_list);
+				list_del_init(&psta->auth_list);
 				pstapriv->auth_list_cnt--;
 
 				DBG_88E("auth expire %6ph\n",
@@ -365,7 +365,7 @@ void	expire_timeout_chk(struct adapter *padapter)
 				continue;
 			}
 
-			rtw_list_delete(&psta->asoc_list);
+			list_del_init(&psta->asoc_list);
 			pstapriv->asoc_list_cnt--;
 
 			DBG_88E("asoc expire %pM, state = 0x%x\n", (psta->hwaddr), psta->state);
@@ -421,7 +421,7 @@ void	expire_timeout_chk(struct adapter *padapter)
 
 			DBG_88E("asoc expire %pM, state = 0x%x\n", (psta->hwaddr), psta->state);
 			spin_lock_bh(&pstapriv->asoc_list_lock);
-			rtw_list_delete(&psta->asoc_list);
+			list_del_init(&psta->asoc_list);
 			pstapriv->asoc_list_cnt--;
 			updated = ap_free_sta(padapter, psta, true, WLAN_REASON_DEAUTH_LEAVING);
 			spin_unlock_bh(&pstapriv->asoc_list_lock);
@@ -1215,7 +1215,7 @@ int rtw_acl_remove_sta(struct adapter *padapter, u8 *addr)
 			if (paclnode->valid) {
 				paclnode->valid = false;
 
-				rtw_list_delete(&paclnode->list);
+				list_del_init(&paclnode->list);
 
 				pacl_list->num--;
 			}
@@ -1818,7 +1818,7 @@ int rtw_sta_flush(struct adapter *padapter)
 
 		plist = plist->next;
 
-		rtw_list_delete(&psta->asoc_list);
+		list_del_init(&psta->asoc_list);
 		pstapriv->asoc_list_cnt--;
 
 		ap_free_sta(padapter, psta, true, WLAN_REASON_DEAUTH_LEAVING);
@@ -1949,7 +1949,7 @@ void stop_ap_mode(struct adapter *padapter)
 		if (paclnode->valid) {
 			paclnode->valid = false;
 
-			rtw_list_delete(&paclnode->list);
+			list_del_init(&paclnode->list);
 
 			pacl_list->num--;
 		}
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 3f37927..8d36e2c 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -159,7 +159,7 @@ struct	cmd_obj	*_rtw_dequeue_cmd(struct __queue *queue)
 		obj = NULL;
 	} else {
 		obj = container_of((&queue->queue)->next, struct cmd_obj, list);
-		rtw_list_delete(&obj->list);
+		list_del_init(&obj->list);
 	}
 
 	spin_unlock_irqrestore(&queue->lock, irqL);
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index f619829..20b180a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -154,7 +154,7 @@ struct	wlan_network *_rtw_dequeue_network(struct __queue *queue)
 	} else {
 		pnetwork = container_of((&queue->queue)->next, struct wlan_network, list);
 
-		rtw_list_delete(&(pnetwork->list));
+		list_del_init(&(pnetwork->list));
 	}
 
 	spin_unlock_bh(&queue->lock);
@@ -178,7 +178,7 @@ struct	wlan_network *_rtw_alloc_network(struct	mlme_priv *pmlmepriv)/* _queue *f
 
 	pnetwork = container_of(plist , struct wlan_network, list);
 
-	rtw_list_delete(&pnetwork->list);
+	list_del_init(&pnetwork->list);
 
 	RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("_rtw_alloc_network: ptr=%p\n", plist));
 	pnetwork->network_type = 0;
@@ -216,7 +216,7 @@ void _rtw_free_network(struct	mlme_priv *pmlmepriv , struct wlan_network *pnetwo
 			return;
 	}
 	spin_lock_bh(&free_queue->lock);
-	rtw_list_delete(&(pnetwork->list));
+	list_del_init(&(pnetwork->list));
 	list_add_tail(&(pnetwork->list), &(free_queue->queue));
 	pmlmepriv->num_of_scanned--;
 	spin_unlock_bh(&free_queue->lock);
@@ -230,7 +230,7 @@ void _rtw_free_network_nolock(struct	mlme_priv *pmlmepriv, struct wlan_network *
 		return;
 	if (pnetwork->fixed)
 		return;
-	rtw_list_delete(&(pnetwork->list));
+	list_del_init(&(pnetwork->list));
 	list_add_tail(&(pnetwork->list), get_list_head(free_queue));
 	pmlmepriv->num_of_scanned--;
 }
@@ -826,7 +826,7 @@ static void free_scanqueue(struct	mlme_priv *pmlmepriv)
 
 	while (plist != phead) {
 		ptemp = plist->next;
-		rtw_list_delete(plist);
+		list_del_init(plist);
 		list_add_tail(plist, &free_queue->queue);
 		plist = ptemp;
 		pmlmepriv->num_of_scanned--;
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
index 08b5620..480c6de 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme_ext.c
@@ -818,7 +818,7 @@ unsigned int OnAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 	} else {
 		spin_lock_bh(&pstapriv->asoc_list_lock);
 		if (!list_empty(&pstat->asoc_list)) {
-			rtw_list_delete(&pstat->asoc_list);
+			list_del_init(&pstat->asoc_list);
 			pstapriv->asoc_list_cnt--;
 		}
 		spin_unlock_bh(&pstapriv->asoc_list_lock);
@@ -1408,7 +1408,7 @@ unsigned int OnAssocReq(struct adapter *padapter, struct recv_frame *precv_frame
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
 	if (!list_empty(&pstat->auth_list)) {
-		rtw_list_delete(&pstat->auth_list);
+		list_del_init(&pstat->auth_list);
 		pstapriv->auth_list_cnt--;
 	}
 	spin_unlock_bh(&pstapriv->auth_list_lock);
@@ -1601,7 +1601,7 @@ unsigned int OnDeAuth(struct adapter *padapter, struct recv_frame *precv_frame)
 
 			spin_lock_bh(&pstapriv->asoc_list_lock);
 			if (!list_empty(&psta->asoc_list)) {
-				rtw_list_delete(&psta->asoc_list);
+				list_del_init(&psta->asoc_list);
 				pstapriv->asoc_list_cnt--;
 				updated = ap_free_sta(padapter, psta, false, reason);
 			}
@@ -1665,7 +1665,7 @@ unsigned int OnDisassoc(struct adapter *padapter, struct recv_frame *precv_frame
 
 			spin_lock_bh(&pstapriv->asoc_list_lock);
 			if (!list_empty(&psta->asoc_list)) {
-				rtw_list_delete(&psta->asoc_list);
+				list_del_init(&psta->asoc_list);
 				pstapriv->asoc_list_cnt--;
 				updated = ap_free_sta(padapter, psta, false, reason);
 			}
@@ -8379,7 +8379,7 @@ u8 tx_beacon_hdl(struct adapter *padapter, unsigned char *pbuf)
 
 				xmitframe_plist = xmitframe_plist->next;
 
-				rtw_list_delete(&pxmitframe->list);
+				list_del_init(&pxmitframe->list);
 
 				psta_bmc->sleepq_len--;
 				if (psta_bmc->sleepq_len > 0)
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index a2bdcd7..e2be938 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -140,7 +140,7 @@ struct recv_frame *_rtw_alloc_recvframe (struct __queue *pfree_recv_queue)
 
 		hdr = container_of(plist, struct recv_frame, list);
 
-		rtw_list_delete(&hdr->list);
+		list_del_init(&hdr->list);
 		padapter = hdr->adapter;
 		if (padapter != NULL) {
 			precvpriv = &padapter->recvpriv;
@@ -191,7 +191,7 @@ int rtw_free_recvframe(struct recv_frame *precvframe,
 
 	spin_lock_bh(&pfree_recv_queue->lock);
 
-	rtw_list_delete(&(precvframe->list));
+	list_del_init(&(precvframe->list));
 
 	precvframe->len = 0;
 
@@ -214,7 +214,7 @@ int _rtw_enqueue_recvframe(struct recv_frame *precvframe, struct __queue *queue)
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 
 
-	rtw_list_delete(&(precvframe->list));
+	list_del_init(&(precvframe->list));
 	list_add_tail(&(precvframe->list), get_list_head(queue));
 
 	if (padapter != NULL) {
@@ -1044,7 +1044,7 @@ static int validate_recv_ctrl_frame(struct adapter *padapter,
 
 				xmitframe_plist = xmitframe_plist->next;
 
-				rtw_list_delete(&pxmitframe->list);
+				list_del_init(&pxmitframe->list);
 
 				psta->sleepq_len--;
 
@@ -1454,7 +1454,7 @@ static struct recv_frame *recvframe_defrag(struct adapter *adapter,
 	plist = phead->next;
 	pfhdr = container_of(plist, struct recv_frame, list);
 	prframe = (struct recv_frame *)pfhdr;
-	rtw_list_delete(&(prframe->list));
+	list_del_init(&(prframe->list));
 
 	if (curfragnum != pfhdr->attrib.frag_num) {
 		/* the first fragment number must be 0 */
@@ -1789,7 +1789,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 			break;
 	}
 
-	rtw_list_delete(&(prframe->list));
+	list_del_init(&(prframe->list));
 
 	list_add_tail(&(prframe->list), plist);
 	return true;
@@ -1830,7 +1830,7 @@ static int recv_indicatepkts_in_order(struct adapter *padapter, struct recv_reor
 				 ("recv_indicatepkts_in_order: indicate=%d seq=%d amsdu=%d\n",
 				  preorder_ctrl->indicate_seq, pattrib->seq_num, pattrib->amsdu));
 			plist = plist->next;
-			rtw_list_delete(&(prframe->list));
+			list_del_init(&(prframe->list));
 
 			if (SN_EQUAL(preorder_ctrl->indicate_seq, pattrib->seq_num))
 				preorder_ctrl->indicate_seq = (preorder_ctrl->indicate_seq + 1) & 0xFFF;
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index 60f2482..c6a249d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -228,7 +228,7 @@ struct	sta_info *rtw_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 		psta = NULL;
 	} else {
 		psta = container_of((&pfree_sta_queue->queue)->next, struct sta_info, list);
-		rtw_list_delete(&(psta->list));
+		list_del_init(&(psta->list));
 		spin_unlock_bh(&pfree_sta_queue->lock);
 		_rtw_init_stainfo(psta);
 		memcpy(psta->hwaddr, hwaddr, ETH_ALEN);
@@ -317,23 +317,23 @@ u32	rtw_free_stainfo(struct adapter *padapter , struct sta_info *psta)
 
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->vo_q.sta_pending);
 
-	rtw_list_delete(&(pstaxmitpriv->vo_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->vo_q.tx_pending));
 
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->vi_q.sta_pending);
 
-	rtw_list_delete(&(pstaxmitpriv->vi_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->vi_q.tx_pending));
 
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->bk_q.sta_pending);
 
-	rtw_list_delete(&(pstaxmitpriv->bk_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->bk_q.tx_pending));
 
 	rtw_free_xmitframe_queue(pxmitpriv, &pstaxmitpriv->be_q.sta_pending);
 
-	rtw_list_delete(&(pstaxmitpriv->be_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->be_q.tx_pending));
 
 	spin_unlock_bh(&pxmitpriv->lock);
 
-	rtw_list_delete(&psta->hash_list);
+	list_del_init(&psta->hash_list);
 	RT_TRACE(_module_rtl871x_sta_mgt_c_, _drv_err_, ("\n free number_%d stainfo  with hwaddr=0x%.2x 0x%.2x 0x%.2x 0x%.2x 0x%.2x 0x%.2x\n", pstapriv->asoc_sta_count , psta->hwaddr[0], psta->hwaddr[1], psta->hwaddr[2], psta->hwaddr[3], psta->hwaddr[4], psta->hwaddr[5]));
 	pstapriv->asoc_sta_count--;
 
@@ -368,7 +368,7 @@ u32	rtw_free_stainfo(struct adapter *padapter , struct sta_info *psta)
 
 			plist = plist->next;
 
-			rtw_list_delete(&(prframe->list));
+			list_del_init(&(prframe->list));
 
 			rtw_free_recvframe(prframe, pfree_recv_queue);
 		}
@@ -383,7 +383,7 @@ u32	rtw_free_stainfo(struct adapter *padapter , struct sta_info *psta)
 
 	spin_lock_bh(&pstapriv->auth_list_lock);
 	if (!list_empty(&psta->auth_list)) {
-		rtw_list_delete(&psta->auth_list);
+		list_del_init(&psta->auth_list);
 		pstapriv->auth_list_cnt--;
 	}
 	spin_unlock_bh(&pstapriv->auth_list_lock);
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index d358651..ddc712f 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -1231,7 +1231,7 @@ struct xmit_buf *rtw_alloc_xmitbuf_ext(struct xmit_priv *pxmitpriv)
 
 		pxmitbuf = container_of(plist, struct xmit_buf, list);
 
-		rtw_list_delete(&(pxmitbuf->list));
+		list_del_init(&(pxmitbuf->list));
 	}
 
 	if (pxmitbuf !=  NULL) {
@@ -1263,7 +1263,7 @@ s32 rtw_free_xmitbuf_ext(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 
 	spin_lock_irqsave(&pfree_queue->lock, irql);
 
-	rtw_list_delete(&pxmitbuf->list);
+	list_del_init(&pxmitbuf->list);
 
 	list_add_tail(&(pxmitbuf->list), get_list_head(pfree_queue));
 	pxmitpriv->free_xmit_extbuf_cnt++;
@@ -1295,7 +1295,7 @@ struct xmit_buf *rtw_alloc_xmitbuf(struct xmit_priv *pxmitpriv)
 
 		pxmitbuf = container_of(plist, struct xmit_buf, list);
 
-		rtw_list_delete(&(pxmitbuf->list));
+		list_del_init(&(pxmitbuf->list));
 	}
 
 	if (pxmitbuf !=  NULL) {
@@ -1330,7 +1330,7 @@ s32 rtw_free_xmitbuf(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 	} else {
 		spin_lock_irqsave(&pfree_xmitbuf_queue->lock, irql);
 
-		rtw_list_delete(&pxmitbuf->list);
+		list_del_init(&pxmitbuf->list);
 
 		list_add_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
 
@@ -1379,7 +1379,7 @@ struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)/* _queue *pf
 
 		pxframe = container_of(plist, struct xmit_frame, list);
 
-		rtw_list_delete(&(pxframe->list));
+		list_del_init(&(pxframe->list));
 	}
 
 	if (pxframe !=  NULL) { /* default value setting */
@@ -1422,7 +1422,7 @@ s32 rtw_free_xmitframe(struct xmit_priv *pxmitpriv, struct xmit_frame *pxmitfram
 
 	spin_lock_bh(&pfree_xmit_queue->lock);
 
-	rtw_list_delete(&pxmitframe->list);
+	list_del_init(&pxmitframe->list);
 
 	if (pxmitframe->pkt) {
 		pndis_pkt = pxmitframe->pkt;
@@ -1492,7 +1492,7 @@ static struct xmit_frame *dequeue_one_xmitframe(struct xmit_priv *pxmitpriv, str
 
 		xmitframe_plist = xmitframe_plist->next;
 
-		rtw_list_delete(&pxmitframe->list);
+		list_del_init(&pxmitframe->list);
 
 		ptxservq->qcnt--;
 	}
@@ -1540,7 +1540,7 @@ struct xmit_frame *rtw_dequeue_xframe(struct xmit_priv *pxmitpriv, struct hw_xmi
 
 				/* Remove sta node when there are no pending packets. */
 				if (_rtw_queue_empty(pframe_queue)) /* must be done after get_next and before break */
-					rtw_list_delete(&ptxservq->tx_pending);
+					list_del_init(&ptxservq->tx_pending);
 				goto exit;
 			}
 
@@ -1800,7 +1800,7 @@ int xmitframe_enqueue_for_sleeping_sta(struct adapter *padapter, struct xmit_fra
 		spin_lock_bh(&psta->sleep_q.lock);
 
 		if (pstapriv->sta_dz_bitmap) {/* if any one sta is in ps mode */
-			rtw_list_delete(&pxmitframe->list);
+			list_del_init(&pxmitframe->list);
 
 			list_add_tail(&pxmitframe->list, get_list_head(&psta->sleep_q));
 
@@ -1825,7 +1825,7 @@ int xmitframe_enqueue_for_sleeping_sta(struct adapter *padapter, struct xmit_fra
 		u8 wmmps_ac = 0;
 
 		if (pstapriv->sta_dz_bitmap&BIT(psta->aid)) {
-			rtw_list_delete(&pxmitframe->list);
+			list_del_init(&pxmitframe->list);
 
 			list_add_tail(&pxmitframe->list, get_list_head(&psta->sleep_q));
 
@@ -1919,21 +1919,21 @@ void stop_sta_xmit(struct adapter *padapter, struct sta_info *psta)
 	pstapriv->sta_dz_bitmap |= BIT(psta->aid);
 
 	dequeue_xmitframes_to_sleeping_queue(padapter, psta, &pstaxmitpriv->vo_q.sta_pending);
-	rtw_list_delete(&(pstaxmitpriv->vo_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->vo_q.tx_pending));
 
 	dequeue_xmitframes_to_sleeping_queue(padapter, psta, &pstaxmitpriv->vi_q.sta_pending);
-	rtw_list_delete(&(pstaxmitpriv->vi_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->vi_q.tx_pending));
 
 	dequeue_xmitframes_to_sleeping_queue(padapter, psta, &pstaxmitpriv->be_q.sta_pending);
-	rtw_list_delete(&(pstaxmitpriv->be_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->be_q.tx_pending));
 
 	dequeue_xmitframes_to_sleeping_queue(padapter, psta, &pstaxmitpriv->bk_q.sta_pending);
-	rtw_list_delete(&(pstaxmitpriv->bk_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->bk_q.tx_pending));
 
 	/* for BC/MC Frames */
 	pstaxmitpriv = &psta_bmc->sta_xmitpriv;
 	dequeue_xmitframes_to_sleeping_queue(padapter, psta_bmc, &pstaxmitpriv->be_q.sta_pending);
-	rtw_list_delete(&(pstaxmitpriv->be_q.tx_pending));
+	list_del_init(&(pstaxmitpriv->be_q.tx_pending));
 
 	spin_unlock_bh(&pxmitpriv->lock);
 }
@@ -1956,7 +1956,7 @@ void wakeup_sta_to_xmit(struct adapter *padapter, struct sta_info *psta)
 
 		xmitframe_plist = xmitframe_plist->next;
 
-		rtw_list_delete(&pxmitframe->list);
+		list_del_init(&pxmitframe->list);
 
 		switch (pxmitframe->attrib.priority) {
 		case 1:
@@ -2037,7 +2037,7 @@ void wakeup_sta_to_xmit(struct adapter *padapter, struct sta_info *psta)
 
 			xmitframe_plist = xmitframe_plist->next;
 
-			rtw_list_delete(&pxmitframe->list);
+			list_del_init(&pxmitframe->list);
 
 			psta_bmc->sleepq_len--;
 			if (psta_bmc->sleepq_len > 0)
@@ -2107,7 +2107,7 @@ void xmit_delivery_enabled_frames(struct adapter *padapter, struct sta_info *pst
 		if (!wmmps_ac)
 			continue;
 
-		rtw_list_delete(&pxmitframe->list);
+		list_del_init(&pxmitframe->list);
 
 		psta->sleepq_len--;
 		psta->sleepq_ac_len--;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 1b2e4b2..c0f23aa 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -549,7 +549,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 			pxmitframe->pkt_offset = 1;
 			break;
 		}
-		rtw_list_delete(&pxmitframe->list);
+		list_del_init(&pxmitframe->list);
 		ptxservq->qcnt--;
 		phwxmit->accnt--;
 
@@ -584,7 +584,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 	} /* end while (aggregate same priority and same DA(AP or STA) frames) */
 
 	if (_rtw_queue_empty(&ptxservq->sta_pending) == true)
-		rtw_list_delete(&ptxservq->tx_pending);
+		list_del_init(&ptxservq->tx_pending);
 
 	spin_unlock_bh(&pxmitpriv->lock);
 	if ((pfirstframe->attrib.ether_type != 0x0806) &&
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 294b234..9f42d21 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -76,11 +76,6 @@ static inline int _enter_critical_mutex(struct mutex *pmutex,
 	return ret;
 }
 
-static inline void rtw_list_delete(struct list_head *plist)
-{
-	list_del_init(plist);
-}
-
 static inline void _init_timer(struct timer_list *ptimer,
 			       struct  net_device *nic_hdl,
 			       void *pfunc, void *cntx)
@@ -173,8 +168,6 @@ void *rtw_malloc2d(int h, int w, int size);
 
 void _rtw_memcpy(void *dec, void *sour, u32 sz);
 
-void rtw_list_delete(struct list_head *plist);
-
 u32  _rtw_down_sema(struct semaphore *sema);
 
 void _rtw_init_queue(struct __queue *pqueue);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 284a28e..128efc4 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -5177,7 +5177,7 @@ static int rtw_del_sta(struct net_device *dev, struct ieee_param *param)
 	if (psta) {
 		spin_lock_bh(&pstapriv->asoc_list_lock);
 		if (!list_empty(&psta->asoc_list)) {
-			rtw_list_delete(&psta->asoc_list);
+			list_del_init(&psta->asoc_list);
 			pstapriv->asoc_list_cnt--;
 			updated = ap_free_sta(padapter, psta, true, WLAN_REASON_DEAUTH_LEAVING);
 		}
-- 
1.7.10.4

