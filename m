Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaFVIkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:40:43 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51928 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaFVIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:37:40 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 23/42] staging: rtl8188eu: Replace _rtw_queue_empty() with list_empty()
Date: Sun, 22 Jun 2014 14:06:29 +0530
Message-Id: <1403426208-12413-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
References: <1403426208-12413-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_ioctl_set.c    |    2 +-
 drivers/staging/rtl8188eu/core/rtw_mlme.c         |    6 +++---
 drivers/staging/rtl8188eu/core/rtw_recv.c         |    4 ++--
 drivers/staging/rtl8188eu/core/rtw_sta_mgt.c      |    2 +-
 drivers/staging/rtl8188eu/core/rtw_xmit.c         |   16 ++++++++--------
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    1 -
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |    5 -----
 8 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
index 7426d00..a97da87 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ioctl_set.c
@@ -85,7 +85,7 @@ u8 rtw_do_join(struct adapter *padapter)
 
 	pmlmepriv->to_join = true;
 
-	if (_rtw_queue_empty(queue)) {
+	if (list_empty(&queue->queue)) {
 		spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_LINKING);
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 20b180a..c03442d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -149,7 +149,7 @@ struct	wlan_network *_rtw_dequeue_network(struct __queue *queue)
 
 	spin_lock_bh(&queue->lock);
 
-	if (_rtw_queue_empty(queue)) {
+	if (list_empty(&queue->queue)) {
 		pnetwork = NULL;
 	} else {
 		pnetwork = container_of((&queue->queue)->next, struct wlan_network, list);
@@ -170,7 +170,7 @@ struct	wlan_network *_rtw_alloc_network(struct	mlme_priv *pmlmepriv)/* _queue *f
 
 	spin_lock_bh(&free_queue->lock);
 
-	if (_rtw_queue_empty(free_queue) == true) {
+	if (list_empty(&free_queue->queue)) {
 		pnetwork = NULL;
 		goto exit;
 	}
@@ -535,7 +535,7 @@ void rtw_update_scanned_network(struct adapter *adapter, struct wlan_bssid_ex *t
 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information */
 	if (phead == plist) {
-		if (_rtw_queue_empty(&(pmlmepriv->free_bss_pool)) == true) {
+		if (list_empty(&(pmlmepriv->free_bss_pool.queue))) {
 			/* If there are no more slots, expire the oldest */
 			pnetwork = oldest;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_recv.c b/drivers/staging/rtl8188eu/core/rtw_recv.c
index e2be938..56aa886 100644
--- a/drivers/staging/rtl8188eu/core/rtw_recv.c
+++ b/drivers/staging/rtl8188eu/core/rtw_recv.c
@@ -131,7 +131,7 @@ struct recv_frame *_rtw_alloc_recvframe (struct __queue *pfree_recv_queue)
 	struct adapter *padapter;
 	struct recv_priv *precvpriv;
 
-	if (_rtw_queue_empty(pfree_recv_queue)) {
+	if (list_empty(&pfree_recv_queue->queue)) {
 		hdr = NULL;
 	} else {
 		phead = get_list_head(pfree_recv_queue);
@@ -1563,7 +1563,7 @@ struct recv_frame *recvframe_chk_defrag(struct adapter *padapter,
 		if (pdefrag_q != NULL) {
 			if (fragnum == 0) {
 				/* the first fragment */
-				if (_rtw_queue_empty(pdefrag_q) == false) {
+				if (!list_empty(&pdefrag_q->queue)) {
 					/* free current defrag_q */
 					rtw_free_recvframe_queue(pdefrag_q, pfree_recv_queue);
 				}
diff --git a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
index c6a249d..e1dc8fa 100644
--- a/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8188eu/core/rtw_sta_mgt.c
@@ -223,7 +223,7 @@ struct	sta_info *rtw_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 
 	spin_lock_bh(&(pfree_sta_queue->lock));
 
-	if (_rtw_queue_empty(pfree_sta_queue) == true) {
+	if (list_empty(&pfree_sta_queue->queue)) {
 		spin_unlock_bh(&pfree_sta_queue->lock);
 		psta = NULL;
 	} else {
diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index ddc712f..3a40b2a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -901,10 +901,10 @@ s32 rtw_txframes_pending(struct adapter *padapter)
 {
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 
-	return ((_rtw_queue_empty(&pxmitpriv->be_pending) == false) ||
-			 (_rtw_queue_empty(&pxmitpriv->bk_pending) == false) ||
-			 (_rtw_queue_empty(&pxmitpriv->vi_pending) == false) ||
-			 (_rtw_queue_empty(&pxmitpriv->vo_pending) == false));
+	return (!list_empty(&pxmitpriv->be_pending.queue) ||
+			!list_empty(&pxmitpriv->bk_pending.queue) ||
+			!list_empty(&pxmitpriv->vi_pending.queue) ||
+			!list_empty(&pxmitpriv->vo_pending.queue));
 }
 
 s32 rtw_txframes_sta_ac_pending(struct adapter *padapter, struct pkt_attrib *pattrib)
@@ -1222,7 +1222,7 @@ struct xmit_buf *rtw_alloc_xmitbuf_ext(struct xmit_priv *pxmitpriv)
 
 	spin_lock_irqsave(&pfree_queue->lock, irql);
 
-	if (_rtw_queue_empty(pfree_queue) == true) {
+	if (list_empty(&pfree_queue->queue)) {
 		pxmitbuf = NULL;
 	} else {
 		phead = get_list_head(pfree_queue);
@@ -1286,7 +1286,7 @@ struct xmit_buf *rtw_alloc_xmitbuf(struct xmit_priv *pxmitpriv)
 
 	spin_lock_irqsave(&pfree_xmitbuf_queue->lock, irql);
 
-	if (_rtw_queue_empty(pfree_xmitbuf_queue) == true) {
+	if (list_empty(&pfree_xmitbuf_queue->queue)) {
 		pxmitbuf = NULL;
 	} else {
 		phead = get_list_head(pfree_xmitbuf_queue);
@@ -1369,7 +1369,7 @@ struct xmit_frame *rtw_alloc_xmitframe(struct xmit_priv *pxmitpriv)/* _queue *pf
 
 	spin_lock_bh(&pfree_xmit_queue->lock);
 
-	if (_rtw_queue_empty(pfree_xmit_queue) == true) {
+	if (list_empty(&pfree_xmit_queue->queue)) {
 		RT_TRACE(_module_rtl871x_xmit_c_, _drv_info_, ("rtw_alloc_xmitframe:%d\n", pxmitpriv->free_xmitframe_cnt));
 		pxframe =  NULL;
 	} else {
@@ -1539,7 +1539,7 @@ struct xmit_frame *rtw_dequeue_xframe(struct xmit_priv *pxmitpriv, struct hw_xmi
 				phwxmit->accnt--;
 
 				/* Remove sta node when there are no pending packets. */
-				if (_rtw_queue_empty(pframe_queue)) /* must be done after get_next and before break */
+				if (list_empty(&pframe_queue->queue)) /* must be done after get_next and before break */
 					list_del_init(&ptxservq->tx_pending);
 				goto exit;
 			}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index c0f23aa..ba8beb8 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -583,7 +583,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 		}
 	} /* end while (aggregate same priority and same DA(AP or STA) frames) */
 
-	if (_rtw_queue_empty(&ptxservq->sta_pending) == true)
+	if (list_empty(&ptxservq->sta_pending.queue))
 		list_del_init(&ptxservq->tx_pending);
 
 	spin_unlock_bh(&pxmitpriv->lock);
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 9f42d21..a55b786 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -171,7 +171,6 @@ void _rtw_memcpy(void *dec, void *sour, u32 sz);
 u32  _rtw_down_sema(struct semaphore *sema);
 
 void _rtw_init_queue(struct __queue *pqueue);
-u32  _rtw_queue_empty(struct __queue *pqueue);
 
 u32  rtw_systime_to_ms(u32 systime);
 u32  rtw_ms_to_systime(u32 ms);
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index ff6ee5b..de0efe2 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -77,11 +77,6 @@ void	_rtw_init_queue(struct __queue *pqueue)
 	spin_lock_init(&(pqueue->lock));
 }
 
-u32	  _rtw_queue_empty(struct __queue *pqueue)
-{
-	return list_empty(&(pqueue->queue));
-}
-
 inline u32 rtw_systime_to_ms(u32 systime)
 {
 	return systime * 1000 / HZ;
-- 
1.7.10.4

