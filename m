Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaFYCxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:53:12 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:54630 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaFYCxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:10 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 1/8] staging: rtl8712: remove wrapper function _init_listhead
Date: Tue, 24 Jun 2014 22:52:34 -0400
Message-Id: <1403664761-15728-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_init_listhead is just an inline wrapper around INIT_LIST_HEAD.  This
patch removes the wrapper and directly uses INIT_LIST_HEAD instead.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h   |    7 +------
 drivers/staging/rtl8712/rtl8712_recv.c    |    4 ++--
 drivers/staging/rtl8712/rtl871x_cmd.c     |    8 ++++----
 drivers/staging/rtl8712/rtl871x_cmd.h     |    2 +-
 drivers/staging/rtl8712/rtl871x_io.c      |    8 ++++----
 drivers/staging/rtl8712/rtl871x_mlme.c    |    6 +++---
 drivers/staging/rtl8712/rtl871x_mp.c      |    2 +-
 drivers/staging/rtl8712/rtl871x_recv.c    |    2 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c |   14 +++++++-------
 drivers/staging/rtl8712/rtl871x_xmit.c    |   12 ++++++------
 10 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 09e1561..17c28c8 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -54,7 +54,7 @@ struct	__queue	{
 
 #define _init_queue(pqueue)				\
 	do {						\
-		_init_listhead(&((pqueue)->queue));	\
+		INIT_LIST_HEAD(&((pqueue)->queue));	\
 		spin_lock_init(&((pqueue)->lock));	\
 	} while (0)
 
@@ -137,11 +137,6 @@ static inline u32 _down_sema(struct semaphore *sema)
 		return _SUCCESS;
 }
 
-static inline void _init_listhead(struct list_head *list)
-{
-	INIT_LIST_HEAD(list);
-}
-
 static inline u32 _queue_empty(struct  __queue *pqueue)
 {
 	return is_list_empty(&(pqueue->queue));
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 1f70017..f87a8fd 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -66,7 +66,7 @@ int r8712_init_recv_priv(struct recv_priv *precvpriv, struct _adapter *padapter)
 			      ((addr_t) (precvpriv->pallocated_recv_buf) & 3);
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		_init_listhead(&precvbuf->list);
+		INIT_LIST_HEAD(&precvbuf->list);
 		spin_lock_init(&precvbuf->recvbuf_lock);
 		res = r8712_os_recvbuf_resource_alloc(padapter, precvbuf);
 		if (res == _FAIL)
@@ -1061,7 +1061,7 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		precvframe = r8712_alloc_recvframe(pfree_recv_queue);
 		if (precvframe == NULL)
 			goto  _exit_recvbuf2recvframe;
-		_init_listhead(&precvframe->u.hdr.list);
+		INIT_LIST_HEAD(&precvframe->u.hdr.list);
 		precvframe->u.hdr.precvbuf = NULL; /*can't access the precvbuf*/
 		precvframe->u.hdr.len = 0;
 		tmp_len = pkt_len + drvinfo_sz + RXDESC_SIZE;
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 1775462..646c5cd 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -413,7 +413,7 @@ u8 r8712_getrfreg_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 		kfree((u8 *) ph2c);
 		return _FAIL;
 	}
-	_init_listhead(&ph2c->list);
+	INIT_LIST_HEAD(&ph2c->list);
 	ph2c->cmdcode = GEN_CMD_CODE(_GetRFReg);
 	ph2c->parmbuf = (unsigned char *)prdrfparm;
 	ph2c->cmdsz =  sizeof(struct readRF_parm);
@@ -452,7 +452,7 @@ u8 r8712_createbss_cmd(struct _adapter *padapter)
 	pcmd = kmalloc(sizeof(*pcmd), GFP_ATOMIC);
 	if (pcmd == NULL)
 		return _FAIL;
-	_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	pcmd->cmdcode = _CreateBss_CMD_;
 	pcmd->parmbuf = (unsigned char *)pdev_network;
 	pcmd->cmdsz = r8712_get_ndis_wlan_bssid_ex_sz((
@@ -606,7 +606,7 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 				psecnetwork->InfrastructureMode);
 	psecnetwork->IELength = cpu_to_le32(psecnetwork->IELength);
 #endif
-	_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	pcmd->cmdcode = _JoinBss_CMD_;
 	pcmd->parmbuf = (unsigned char *)psecnetwork;
 	pcmd->rsp = NULL;
@@ -758,7 +758,7 @@ u8 r8712_gettssi_cmd(struct _adapter *padapter, u8 offset, u8 *pval)
 		kfree((unsigned char *) ph2c);
 		return _FAIL;
 	}
-	_init_listhead(&ph2c->list);
+	INIT_LIST_HEAD(&ph2c->list);
 	ph2c->cmdcode = GEN_CMD_CODE(_ReadTSSI);
 	ph2c->parmbuf = (unsigned char *)prdtssiparm;
 	ph2c->cmdsz = sizeof(struct readTSSI_parm);
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.h b/drivers/staging/rtl8712/rtl871x_cmd.h
index 0ce79b1..cb8225b 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.h
+++ b/drivers/staging/rtl8712/rtl871x_cmd.h
@@ -83,7 +83,7 @@ struct	evt_priv {
 
 #define init_h2fwcmd_w_parm_no_rsp(pcmd, pparm, code) \
 do {\
-	_init_listhead(&pcmd->list);\
+	INIT_LIST_HEAD(&pcmd->list);\
 	pcmd->cmdcode = code;\
 	pcmd->parmbuf = (u8 *)(pparm);\
 	pcmd->cmdsz = sizeof(*pparm);\
diff --git a/drivers/staging/rtl8712/rtl871x_io.c b/drivers/staging/rtl8712/rtl871x_io.c
index e881b0d..c42a578 100644
--- a/drivers/staging/rtl8712/rtl871x_io.c
+++ b/drivers/staging/rtl8712/rtl871x_io.c
@@ -115,9 +115,9 @@ uint r8712_alloc_io_queue(struct _adapter *adapter)
 	pio_queue = kmalloc(sizeof(*pio_queue), GFP_ATOMIC);
 	if (pio_queue == NULL)
 		goto alloc_io_queue_fail;
-	_init_listhead(&pio_queue->free_ioreqs);
-	_init_listhead(&pio_queue->processing);
-	_init_listhead(&pio_queue->pending);
+	INIT_LIST_HEAD(&pio_queue->free_ioreqs);
+	INIT_LIST_HEAD(&pio_queue->processing);
+	INIT_LIST_HEAD(&pio_queue->pending);
 	spin_lock_init(&pio_queue->lock);
 	pio_queue->pallocated_free_ioreqs_buf = kmalloc(NUM_IOREQ *
 							(sizeof(struct io_req)) + 4,
@@ -131,7 +131,7 @@ uint r8712_alloc_io_queue(struct _adapter *adapter)
 			& 3);
 	pio_req = (struct io_req *)(pio_queue->free_ioreqs_buf);
 	for (i = 0; i < NUM_IOREQ; i++) {
-		_init_listhead(&pio_req->list);
+		INIT_LIST_HEAD(&pio_req->list);
 		list_insert_tail(&pio_req->list, &pio_queue->free_ioreqs);
 		pio_req++;
 	}
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 26b8f37..3000b2a 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -69,7 +69,7 @@ static sint _init_mlme_priv(struct _adapter *padapter)
 	pmlmepriv->free_bss_buf = pbuf;
 	pnetwork = (struct wlan_network *)pbuf;
 	for (i = 0; i < MAX_BSS_CNT; i++) {
-		_init_listhead(&(pnetwork->list));
+		INIT_LIST_HEAD(&(pnetwork->list));
 		list_insert_tail(&(pnetwork->list),
 				 &(pmlmepriv->free_bss_pool.queue));
 		pnetwork++;
@@ -1227,7 +1227,7 @@ sint r8712_set_auth(struct _adapter *adapter,
 	pcmd->cmdsz = sizeof(struct setauth_parm);
 	pcmd->rsp = NULL;
 	pcmd->rspsz = 0;
-	_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	r8712_enqueue_cmd(pcmdpriv, pcmd);
 	return _SUCCESS;
 }
@@ -1299,7 +1299,7 @@ sint r8712_set_key(struct _adapter *adapter,
 	pcmd->cmdsz =  (sizeof(struct setkey_parm));
 	pcmd->rsp = NULL;
 	pcmd->rspsz = 0;
-	_init_listhead(&pcmd->list);
+	INIT_LIST_HEAD(&pcmd->list);
 	r8712_enqueue_cmd(pcmdpriv, pcmd);
 	return ret;
 
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index e48486c..594d023 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -65,7 +65,7 @@ static int init_mp_priv(struct mp_priv *pmp_priv)
 			 ((addr_t)(pmp_priv->pallocated_mp_xmitframe_buf) & 3);
 	pmp_xmitframe = (struct mp_xmit_frame *)pmp_priv->pmp_xmtframe_buf;
 	for (i = 0; i < NR_MP_XMITFRAME; i++) {
-		_init_listhead(&(pmp_xmitframe->list));
+		INIT_LIST_HEAD(&(pmp_xmitframe->list));
 		list_insert_tail(&(pmp_xmitframe->list),
 				 &(pmp_priv->free_mp_xmitqueue.queue));
 		pmp_xmitframe->pkt = NULL;
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index eb77587..269c872 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -86,7 +86,7 @@ sint _r8712_init_recv_priv(struct recv_priv *precvpriv,
 				    (RXFRAME_ALIGN_SZ-1));
 	precvframe = (union recv_frame *)precvpriv->precv_frame_buf;
 	for (i = 0; i < NR_RECVFRAME; i++) {
-		_init_listhead(&(precvframe->u.list));
+		INIT_LIST_HEAD(&(precvframe->u.list));
 		list_insert_tail(&(precvframe->u.list),
 				 &(precvpriv->free_recv_queue.queue));
 		r8712_os_recv_resource_alloc(padapter, precvframe);
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 6c64984..8dd5e35 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -38,12 +38,12 @@ static void _init_stainfo(struct sta_info *psta)
 {
 	memset((u8 *)psta, 0, sizeof(struct sta_info));
 	 spin_lock_init(&psta->lock);
-	_init_listhead(&psta->list);
-	_init_listhead(&psta->hash_list);
+	INIT_LIST_HEAD(&psta->list);
+	INIT_LIST_HEAD(&psta->hash_list);
 	_r8712_init_sta_xmit_priv(&psta->sta_xmitpriv);
 	_r8712_init_sta_recv_priv(&psta->sta_recvpriv);
-	_init_listhead(&psta->asoc_list);
-	_init_listhead(&psta->auth_list);
+	INIT_LIST_HEAD(&psta->asoc_list);
+	INIT_LIST_HEAD(&psta->auth_list);
 }
 
 u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
@@ -65,13 +65,13 @@ u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
 	psta = (struct sta_info *)(pstapriv->pstainfo_buf);
 	for (i = 0; i < NUM_STA; i++) {
 		_init_stainfo(psta);
-		_init_listhead(&(pstapriv->sta_hash[i]));
+		INIT_LIST_HEAD(&(pstapriv->sta_hash[i]));
 		list_insert_tail(&psta->list,
 				 get_list_head(&pstapriv->free_sta_queue));
 		psta++;
 	}
-	_init_listhead(&pstapriv->asoc_list);
-	_init_listhead(&pstapriv->auth_list);
+	INIT_LIST_HEAD(&pstapriv->asoc_list);
+	INIT_LIST_HEAD(&pstapriv->auth_list);
 	return _SUCCESS;
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 230681a..68bfab0 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -43,7 +43,7 @@ static void free_hwxmits(struct _adapter *padapter);
 
 static void _init_txservq(struct tx_servq *ptxservq)
 {
-	_init_listhead(&ptxservq->tx_pending);
+	INIT_LIST_HEAD(&ptxservq->tx_pending);
 	_init_queue(&ptxservq->sta_pending);
 	ptxservq->qcnt = 0;
 }
@@ -57,8 +57,8 @@ void _r8712_init_sta_xmit_priv(struct sta_xmit_priv *psta_xmitpriv)
 	_init_txservq(&psta_xmitpriv->bk_q);
 	_init_txservq(&psta_xmitpriv->vi_q);
 	_init_txservq(&psta_xmitpriv->vo_q);
-	_init_listhead(&psta_xmitpriv->legacy_dz);
-	_init_listhead(&psta_xmitpriv->apsd);
+	INIT_LIST_HEAD(&psta_xmitpriv->legacy_dz);
+	INIT_LIST_HEAD(&psta_xmitpriv->apsd);
 }
 
 sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
@@ -97,7 +97,7 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 			((addr_t) (pxmitpriv->pallocated_frame_buf) & 3);
 	pxframe = (struct xmit_frame *) pxmitpriv->pxmit_frame_buf;
 	for (i = 0; i < NR_XMITFRAME; i++) {
-		_init_listhead(&(pxframe->list));
+		INIT_LIST_HEAD(&(pxframe->list));
 		pxframe->padapter = padapter;
 		pxframe->frame_tag = DATA_FRAMETAG;
 		pxframe->pkt = NULL;
@@ -134,7 +134,7 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 			      ((addr_t)(pxmitpriv->pallocated_xmitbuf) & 3);
 	pxmitbuf = (struct xmit_buf *)pxmitpriv->pxmitbuf;
 	for (i = 0; i < NR_XMITBUFF; i++) {
-		_init_listhead(&pxmitbuf->list);
+		INIT_LIST_HEAD(&pxmitbuf->list);
 		pxmitbuf->pallocated_buf = kmalloc(MAX_XMITBUF_SZ + XMITBUF_ALIGN_SZ,
 						   GFP_ATOMIC);
 		if (pxmitbuf->pallocated_buf == NULL)
@@ -1005,7 +1005,7 @@ static void init_hwxmits(struct hw_xmit *phwxmit, sint entry)
 
 	for (i = 0; i < entry; i++, phwxmit++) {
 		spin_lock_init(&phwxmit->xmit_lock);
-		_init_listhead(&phwxmit->pending);
+		INIT_LIST_HEAD(&phwxmit->pending);
 		phwxmit->txcmdcnt = 0;
 		phwxmit->accnt = 0;
 	}
-- 
1.7.9.5

