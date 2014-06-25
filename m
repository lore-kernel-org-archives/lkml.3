Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaFYCxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:53:25 -0400
Received: from mail-yk0-f181.google.com ([209.85.160.181]:55272 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaFYCxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:53:17 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 2/8] staging: rtl8712: remove wrapper function is_list_empty
Date: Tue, 24 Jun 2014 22:52:35 -0400
Message-Id: <1403664761-15728-2-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403664761-15728-1-git-send-email-shack@linux.com>
References: <1403664761-15728-1-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_list_empty is just an inline wrapper around list_empty.  This patch
removes the wrapper and directly uses list_empty instead.

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h |   10 +---------
 drivers/staging/rtl8712/rtl8712_recv.c  |    4 ++--
 drivers/staging/rtl8712/rtl871x_cmd.c   |    2 +-
 drivers/staging/rtl8712/rtl871x_xmit.c  |    2 +-
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 17c28c8..58f2090 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -115,14 +115,6 @@ For the following list_xxx operations,
 caller must guarantee the atomic context.
 Otherwise, there will be racing condition.
 */
-static inline u32 is_list_empty(struct list_head *phead)
-{
-	if (list_empty(phead))
-		return true;
-	else
-		return false;
-}
-
 static inline void list_insert_tail(struct list_head *plist,
 				    struct list_head *phead)
 {
@@ -139,7 +131,7 @@ static inline u32 _down_sema(struct semaphore *sema)
 
 static inline u32 _queue_empty(struct  __queue *pqueue)
 {
-	return is_list_empty(&(pqueue->queue));
+	return list_empty(&(pqueue->queue));
 }
 
 static inline u32 end_of_queue_search(struct list_head *head,
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index f87a8fd..22840a1 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -532,7 +532,7 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 	plist = get_next(phead);
 	/* Handling some condition for forced indicate case.*/
 	if (bforced == true) {
-		if (is_list_empty(phead))
+		if (list_empty(phead))
 			return true;
 		else {
 			prframe = LIST_CONTAINOR(plist, union recv_frame, u);
@@ -542,7 +542,7 @@ int r8712_recv_indicatepkts_in_order(struct _adapter *padapter,
 	}
 	/* Prepare indication list and indication.
 	 * Check if there is any packet need indicate. */
-	while (!is_list_empty(phead)) {
+	while (!list_empty(phead)) {
 		prframe = LIST_CONTAINOR(plist, union recv_frame, u);
 		pattrib = &prframe->u.hdr.attrib;
 		if (!SN_LESS(preorder_ctrl->indicate_seq, pattrib->seq_num)) {
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 646c5cd..689364d 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -137,7 +137,7 @@ static struct cmd_obj *_dequeue_cmd(struct  __queue *queue)
 	struct cmd_obj *obj;
 
 	spin_lock_irqsave(&(queue->lock), irqL);
-	if (is_list_empty(&(queue->queue)))
+	if (list_empty(&(queue->queue)))
 		obj = NULL;
 	else {
 		obj = LIST_CONTAINOR(get_next(&(queue->queue)),
diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index 68bfab0..989fb67 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -939,7 +939,7 @@ sint r8712_xmit_classifier(struct _adapter *padapter,
 	ptxservq = get_sta_pending(padapter, &pstapending,
 		   psta, pattrib->priority);
 	spin_lock_irqsave(&pstapending->lock, irqL0);
-	if (is_list_empty(&ptxservq->tx_pending))
+	if (list_empty(&ptxservq->tx_pending))
 		list_insert_tail(&ptxservq->tx_pending,
 				 get_list_head(pstapending));
 	list_insert_tail(&pxmitframe->list,
-- 
1.7.9.5

