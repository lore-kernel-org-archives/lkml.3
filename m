Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaFYCyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:54:49 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:36592 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbaFYCxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:24 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 3/8] staging: rtl8712: remove wrapper function list_insert_tail
Date: Tue, 24 Jun 2014 22:52:36 -0400
Message-Id: <1403664761-15728-3-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-2-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_insert_tail is just an inline wrapper around list_add_tail.  This
patch removes the wrapper and directly uses list_add_tail.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h   |    6 ------
 drivers/staging/rtl8712/rtl8712_recv.c    |   10 +++++-----
 drivers/staging/rtl8712/rtl871x_cmd.c     |    6 +++---
 drivers/staging/rtl8712/rtl871x_io.c      |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c    |    8 ++++----
 drivers/staging/rtl8712/rtl871x_mp.c      |    2 +-
 drivers/staging/rtl8712/rtl871x_recv.c    |    2 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c |    6 +++---
 drivers/staging/rtl8712/rtl871x_xmit.c    |   12 ++++++------
 9 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 58f2090..bc5e922 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -115,12 +115,6 @@ For the following list_xxx operations,
 caller must guarantee the atomic context.
 Otherwise, there will be racing condition.
 */
-static inline void list_insert_tail(struct list_head *plist,
-				    struct list_head *phead)
-{
-	list_add_tail(plist, phead);
-}
-
 static inline u32 _down_sema(struct semaphore *sema)
 {
 	if (down_interruptible(sema))
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 22840a1..b510312 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -73,7 +73,7 @@ int r8712_init_recv_priv(struct recv_priv *precvpriv, struct _adapter *padapter)
 			break;
 		precvbuf->ref_cnt = 0;
 		precvbuf->adapter = padapter;
-		list_insert_tail(&precvbuf->list,
+		list_add_tail(&precvbuf->list,
 				 &(precvpriv->free_recv_buf_queue.queue));
 		precvbuf++;
 	}
@@ -146,7 +146,7 @@ int r8712_free_recvframe(union recv_frame *precvframe,
 	}
 	spin_lock_irqsave(&pfree_recv_queue->lock, irqL);
 	list_delete(&(precvframe->u.hdr.list));
-	list_insert_tail(&(precvframe->u.hdr.list),
+	list_add_tail(&(precvframe->u.hdr.list),
 			 get_list_head(pfree_recv_queue));
 	if (padapter != NULL) {
 		if (pfree_recv_queue == &precvpriv->free_recv_queue)
@@ -297,7 +297,7 @@ union recv_frame *r8712_recvframe_chk_defrag(struct _adapter *padapter,
 			}
 			/* Then enqueue the 0~(n-1) fragment to the defrag_q */
 			phead = get_list_head(pdefrag_q);
-			list_insert_tail(&pfhdr->list, phead);
+			list_add_tail(&pfhdr->list, phead);
 			prtnframe = NULL;
 		} else {
 			/* can't find this ta's defrag_queue, so free this
@@ -312,7 +312,7 @@ union recv_frame *r8712_recvframe_chk_defrag(struct _adapter *padapter,
 		 * enqueue the last fragment */
 		if (pdefrag_q != NULL) {
 			phead = get_list_head(pdefrag_q);
-			list_insert_tail(&pfhdr->list, phead);
+			list_add_tail(&pfhdr->list, phead);
 			/*call recvframe_defrag to defrag*/
 			precv_frame = recvframe_defrag(padapter, pdefrag_q);
 			prtnframe = precv_frame;
@@ -512,7 +512,7 @@ static int enqueue_reorder_recvframe(struct recv_reorder_ctrl *preorder_ctrl,
 			break;
 	}
 	list_delete(&(prframe->u.hdr.list));
-	list_insert_tail(&(prframe->u.hdr.list), plist);
+	list_add_tail(&(prframe->u.hdr.list), plist);
 	return true;
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 689364d..cae8ee6 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -126,7 +126,7 @@ static sint _enqueue_cmd(struct  __queue *queue, struct cmd_obj *obj)
 	if (obj == NULL)
 		return _SUCCESS;
 	spin_lock_irqsave(&queue->lock, irqL);
-	list_insert_tail(&obj->list, &queue->queue);
+	list_add_tail(&obj->list, &queue->queue);
 	spin_unlock_irqrestore(&queue->lock, irqL);
 	return _SUCCESS;
 }
@@ -190,7 +190,7 @@ u32 r8712_enqueue_cmd_ex(struct cmd_priv *pcmdpriv, struct cmd_obj *obj)
 		return _FAIL;
 	queue = &pcmdpriv->cmd_queue;
 	spin_lock_irqsave(&queue->lock, irqL);
-	list_insert_tail(&obj->list, &queue->queue);
+	list_add_tail(&obj->list, &queue->queue);
 	spin_unlock_irqrestore(&queue->lock, irqL);
 	up(&pcmdpriv->cmd_queue_sema);
 	return _SUCCESS;
@@ -956,7 +956,7 @@ void r8712_createbss_cmd_callback(struct _adapter *padapter,
 				goto createbss_cmd_fail;
 			pwlan->last_scanned = jiffies;
 		} else
-			list_insert_tail(&(pwlan->list),
+			list_add_tail(&(pwlan->list),
 					 &pmlmepriv->scanned_queue.queue);
 		pnetwork->Length = r8712_get_ndis_wlan_bssid_ex_sz(pnetwork);
 		memcpy(&(pwlan->network), pnetwork, pnetwork->Length);
diff --git a/drivers/staging/rtl8712/rtl871x_io.c b/drivers/staging/rtl8712/rtl871x_io.c
index c42a578..8858687 100644
--- a/drivers/staging/rtl8712/rtl871x_io.c
+++ b/drivers/staging/rtl8712/rtl871x_io.c
@@ -132,7 +132,7 @@ uint r8712_alloc_io_queue(struct _adapter *adapter)
 	pio_req = (struct io_req *)(pio_queue->free_ioreqs_buf);
 	for (i = 0; i < NUM_IOREQ; i++) {
 		INIT_LIST_HEAD(&pio_req->list);
-		list_insert_tail(&pio_req->list, &pio_queue->free_ioreqs);
+		list_add_tail(&pio_req->list, &pio_queue->free_ioreqs);
 		pio_req++;
 	}
 	if ((register_intf_hdl((u8 *)adapter, &(pio_queue->intf))) == _FAIL)
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 3000b2a..05ff7dd 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -70,7 +70,7 @@ static sint _init_mlme_priv(struct _adapter *padapter)
 	pnetwork = (struct wlan_network *)pbuf;
 	for (i = 0; i < MAX_BSS_CNT; i++) {
 		INIT_LIST_HEAD(&(pnetwork->list));
-		list_insert_tail(&(pnetwork->list),
+		list_add_tail(&(pnetwork->list),
 				 &(pmlmepriv->free_bss_pool.queue));
 		pnetwork++;
 	}
@@ -118,7 +118,7 @@ static void _free_network(struct mlme_priv *pmlmepriv,
 		return;
 	spin_lock_irqsave(&free_queue->lock, irqL);
 	list_delete(&pnetwork->list);
-	list_insert_tail(&pnetwork->list, &free_queue->queue);
+	list_add_tail(&pnetwork->list, &free_queue->queue);
 	pmlmepriv->num_of_scanned--;
 	spin_unlock_irqrestore(&free_queue->lock, irqL);
 }
@@ -133,7 +133,7 @@ static void _free_network_nolock(struct mlme_priv *pmlmepriv,
 	if (pnetwork->fixed == true)
 		return;
 	list_delete(&pnetwork->list);
-	list_insert_tail(&pnetwork->list, get_list_head(free_queue));
+	list_add_tail(&pnetwork->list, get_list_head(free_queue));
 	pmlmepriv->num_of_scanned--;
 }
 
@@ -437,7 +437,7 @@ static void update_scanned_network(struct _adapter *adapter,
 			bssid_ex_sz = r8712_get_ndis_wlan_bssid_ex_sz(target);
 			target->Length = bssid_ex_sz;
 			memcpy(&pnetwork->network, target, bssid_ex_sz);
-			list_insert_tail(&pnetwork->list, &queue->queue);
+			list_add_tail(&pnetwork->list, &queue->queue);
 		}
 	} else {
 		/* we have an entry and we are going to update it. But
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index 594d023..aae77f0 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -66,7 +66,7 @@ static int init_mp_priv(struct mp_priv *pmp_priv)
 	pmp_xmitframe = (struct mp_xmit_frame *)pmp_priv->pmp_xmtframe_buf;
 	for (i = 0; i < NR_MP_XMITFRAME; i++) {
 		INIT_LIST_HEAD(&(pmp_xmitframe->list));
-		list_insert_tail(&(pmp_xmitframe->list),
+		list_add_tail(&(pmp_xmitframe->list),
 				 &(pmp_priv->free_mp_xmitqueue.queue));
 		pmp_xmitframe->pkt = NULL;
 		pmp_xmitframe->frame_tag = MP_FRAMETAG;
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index 269c872..cd31982 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -87,7 +87,7 @@ sint _r8712_init_recv_priv(struct recv_priv *precvpriv,
 	precvframe = (union recv_frame *)precvpriv->precv_frame_buf;
 	for (i = 0; i < NR_RECVFRAME; i++) {
 		INIT_LIST_HEAD(&(precvframe->u.list));
-		list_insert_tail(&(precvframe->u.list),
+		list_add_tail(&(precvframe->u.list),
 				 &(precvpriv->free_recv_queue.queue));
 		r8712_os_recv_resource_alloc(padapter, precvframe);
 		precvframe->u.hdr.adapter = padapter;
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 8dd5e35..e7f3cdb 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -66,7 +66,7 @@ u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
 	for (i = 0; i < NUM_STA; i++) {
 		_init_stainfo(psta);
 		INIT_LIST_HEAD(&(pstapriv->sta_hash[i]));
-		list_insert_tail(&psta->list,
+		list_add_tail(&psta->list,
 				 get_list_head(&pstapriv->free_sta_queue));
 		psta++;
 	}
@@ -137,7 +137,7 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 			goto exit;
 		}
 		phash_list = &(pstapriv->sta_hash[index]);
-		list_insert_tail(&psta->hash_list, phash_list);
+		list_add_tail(&psta->hash_list, phash_list);
 		pstapriv->asoc_sta_count++;
 
 /* For the SMC router, the sequence number of first packet of WPS handshake
@@ -208,7 +208,7 @@ void r8712_free_stainfo(struct _adapter *padapter, struct sta_info *psta)
 	}
 	spin_lock(&(pfree_sta_queue->lock));
 	/* insert into free_sta_queue; 20061114 */
-	list_insert_tail(&psta->list, get_list_head(pfree_sta_queue));
+	list_add_tail(&psta->list, get_list_head(pfree_sta_queue));
 	spin_unlock(&(pfree_sta_queue->lock));
 }
 
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 989fb67..71d0d0d 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -103,7 +103,7 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 		pxframe->pkt = NULL;
 		pxframe->buf_addr = NULL;
 		pxframe->pxmitbuf = NULL;
-		list_insert_tail(&(pxframe->list),
+		list_add_tail(&(pxframe->list),
 				 &(pxmitpriv->free_xmit_queue.queue));
 		pxframe++;
 	}
@@ -143,7 +143,7 @@ sint _r8712_init_xmit_priv(struct xmit_priv *pxmitpriv,
 				 ((addr_t) (pxmitbuf->pallocated_buf) &
 				 (XMITBUF_ALIGN_SZ - 1));
 		r8712_xmit_resource_alloc(padapter, pxmitbuf);
-		list_insert_tail(&pxmitbuf->list,
+		list_add_tail(&pxmitbuf->list,
 				 &(pxmitpriv->free_xmitbuf_queue.queue));
 		pxmitbuf++;
 	}
@@ -767,7 +767,7 @@ int r8712_free_xmitbuf(struct xmit_priv *pxmitpriv, struct xmit_buf *pxmitbuf)
 		return _FAIL;
 	spin_lock_irqsave(&pfree_xmitbuf_queue->lock, irqL);
 	list_delete(&pxmitbuf->list);
-	list_insert_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
+	list_add_tail(&(pxmitbuf->list), get_list_head(pfree_xmitbuf_queue));
 	pxmitpriv->free_xmitbuf_cnt++;
 	spin_unlock_irqrestore(&pfree_xmitbuf_queue->lock, irqL);
 	return _SUCCESS;
@@ -833,7 +833,7 @@ void r8712_free_xmitframe(struct xmit_priv *pxmitpriv,
 		pndis_pkt = pxmitframe->pkt;
 		pxmitframe->pkt = NULL;
 	}
-	list_insert_tail(&pxmitframe->list, get_list_head(pfree_xmit_queue));
+	list_add_tail(&pxmitframe->list, get_list_head(pfree_xmit_queue));
 	pxmitpriv->free_xmitframe_cnt++;
 	spin_unlock_irqrestore(&pfree_xmit_queue->lock, irqL);
 	if (netif_queue_stopped(padapter->pnetdev))
@@ -940,9 +940,9 @@ sint r8712_xmit_classifier(struct _adapter *padapter,
 		   psta, pattrib->priority);
 	spin_lock_irqsave(&pstapending->lock, irqL0);
 	if (list_empty(&ptxservq->tx_pending))
-		list_insert_tail(&ptxservq->tx_pending,
+		list_add_tail(&ptxservq->tx_pending,
 				 get_list_head(pstapending));
-	list_insert_tail(&pxmitframe->list,
+	list_add_tail(&pxmitframe->list,
 			 get_list_head(&ptxservq->sta_pending));
 	ptxservq->qcnt++;
 	spin_unlock_irqrestore(&pstapending->lock, irqL0);
-- 
1.7.9.5

