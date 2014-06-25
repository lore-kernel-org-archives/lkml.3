Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaFYCyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:54:03 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59425 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbaFYCxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:36 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 7/8] staging: rtl8712: remove wrapper function _queue_empty
Date: Tue, 24 Jun 2014 22:52:40 -0400
Message-Id: <1403664761-15728-7-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-6-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
 <1403664761-15728-2-git-send-email-shack@linux.com>
 <1403664761-15728-3-git-send-email-shack@linux.com>
 <1403664761-15728-4-git-send-email-shack@linux.com>
 <1403664761-15728-5-git-send-email-shack@linux.com>
 <1403664761-15728-6-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_queue_empty is an inline wrapper around list_empty.  This patch removes this
wrapper function and instead calls list_empty directly.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h     |    5 -----
 drivers/staging/rtl8712/rtl8712_cmd.c       |    2 +-
 drivers/staging/rtl8712/rtl8712_recv.c      |    2 +-
 drivers/staging/rtl8712/rtl8712_xmit.c      |    2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_set.c |    2 +-
 drivers/staging/rtl8712/rtl871x_mlme.c      |    4 ++--
 drivers/staging/rtl8712/rtl871x_recv.c      |    2 +-
 drivers/staging/rtl8712/rtl871x_sta_mgt.c   |    2 +-
 drivers/staging/rtl8712/rtl871x_xmit.c      |    4 ++--
 9 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index cb279b9..77b1443 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -108,11 +108,6 @@ static inline u32 _down_sema(struct semaphore *sema)
 		return _SUCCESS;
 }
 
-static inline u32 _queue_empty(struct  __queue *pqueue)
-{
-	return list_empty(&(pqueue->queue));
-}
-
 static inline u32 end_of_queue_search(struct list_head *head,
 		struct list_head *plist)
 {
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 8ca7d7e..1d81d2c 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -410,7 +410,7 @@ _next:
 				}
 			}
 			r8712_free_cmd_obj(pcmd);
-			if (_queue_empty(&(pcmdpriv->cmd_queue))) {
+			if (list_empty(&pcmdpriv->cmd_queue.queue)) {
 				r8712_unregister_cmd_alive(padapter);
 				continue;
 			} else
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index b759c9b..f0ec89c 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -288,7 +288,7 @@ union recv_frame *r8712_recvframe_chk_defrag(struct _adapter *padapter,
 		if (pdefrag_q != NULL) {
 			if (fragnum == 0) {
 				/*the first fragment*/
-				if (_queue_empty(pdefrag_q) == false) {
+				if (!list_empty(&pdefrag_q->queue)) {
 					/*free current defrag_q */
 					r8712_free_recvframe_queue(pdefrag_q,
 							     pfree_recv_queue);
diff --git a/drivers/staging/rtl8712/rtl8712_xmit.c b/drivers/staging/rtl8712/rtl8712_xmit.c
index f3d2998..4ebedb4 100644
--- a/drivers/staging/rtl8712/rtl8712_xmit.c
+++ b/drivers/staging/rtl8712/rtl8712_xmit.c
@@ -224,7 +224,7 @@ static struct xmit_frame *dequeue_xframe_ex(struct xmit_priv *pxmitpriv,
 			}
 			sta_plist = sta_plist->next;
 			/*Remove sta node when there are no pending packets.*/
-			if (_queue_empty(pframe_queue)) {
+			if (list_empty(&pframe_queue->queue)) {
 				/* must be done after sta_plist->next
 				 * and before break
 				 */
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index 226f247..9d47eb4 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -71,7 +71,7 @@ static u8 do_join(struct _adapter *padapter)
 
 	/* adhoc mode will start with an empty queue, but skip checking */
 	if (!check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) &&
-	    _queue_empty(queue)) {
+	    list_empty(&queue->queue)) {
 		if (pmlmepriv->fw_state & _FW_UNDER_LINKING)
 			pmlmepriv->fw_state ^= _FW_UNDER_LINKING;
 		/* when set_ssid/set_bssid for do_join(), but scanning queue
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index d37ba7b..7b7fdec 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -89,7 +89,7 @@ struct wlan_network *_r8712_alloc_network(struct mlme_priv *pmlmepriv)
 	struct  __queue *free_queue = &pmlmepriv->free_bss_pool;
 	struct list_head *plist = NULL;
 
-	if (_queue_empty(free_queue) == true)
+	if (list_empty(&free_queue->queue))
 		return NULL;
 	spin_lock_irqsave(&free_queue->lock, irqL);
 	plist = free_queue->queue.next;
@@ -420,7 +420,7 @@ static void update_scanned_network(struct _adapter *adapter,
 	/* If we didn't find a match, then get a new network slot to initialize
 	 * with this beacon's information */
 	if (end_of_queue_search(phead, plist) == true) {
-		if (_queue_empty(&pmlmepriv->free_bss_pool) == true) {
+		if (list_empty(&pmlmepriv->free_bss_pool.queue)) {
 			/* If there are no more slots, expire the oldest */
 			pnetwork = oldest;
 			target->Rssi = (pnetwork->network.Rssi +
diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index cc2ca11..a3889d1 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -112,7 +112,7 @@ union recv_frame *r8712_alloc_recvframe(struct  __queue *pfree_recv_queue)
 	struct recv_priv *precvpriv;
 
 	spin_lock_irqsave(&pfree_recv_queue->lock, irqL);
-	if (_queue_empty(pfree_recv_queue) == true)
+	if (list_empty(&pfree_recv_queue->queue))
 		precvframe = NULL;
 	else {
 		phead = &pfree_recv_queue->queue;
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 73ca66e..e769bb5 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -121,7 +121,7 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 
 	pfree_sta_queue = &pstapriv->free_sta_queue;
 	spin_lock_irqsave(&(pfree_sta_queue->lock), flags);
-	if (_queue_empty(pfree_sta_queue) == true)
+	if (list_empty(&pfree_sta_queue->queue))
 		psta = NULL;
 	else {
 		psta = LIST_CONTAINOR(pfree_sta_queue->queue.next,
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 4b3fa40..a104b77 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -744,7 +744,7 @@ struct xmit_buf *r8712_alloc_xmitbuf(struct xmit_priv *pxmitpriv)
 	struct  __queue *pfree_xmitbuf_queue = &pxmitpriv->free_xmitbuf_queue;
 
 	spin_lock_irqsave(&pfree_xmitbuf_queue->lock, irqL);
-	if (_queue_empty(pfree_xmitbuf_queue) == true)
+	if (list_empty(&pfree_xmitbuf_queue->queue))
 		pxmitbuf = NULL;
 	else {
 		phead = &pfree_xmitbuf_queue->queue;
@@ -798,7 +798,7 @@ struct xmit_frame *r8712_alloc_xmitframe(struct xmit_priv *pxmitpriv)
 	struct  __queue *pfree_xmit_queue = &pxmitpriv->free_xmit_queue;
 
 	spin_lock_irqsave(&pfree_xmit_queue->lock, irqL);
-	if (_queue_empty(pfree_xmit_queue) == true)
+	if (list_empty(&pfree_xmit_queue->queue))
 		pxframe =  NULL;
 	else {
 		phead = &pfree_xmit_queue->queue;
-- 
1.7.9.5

