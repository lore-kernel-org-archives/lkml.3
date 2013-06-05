Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3FEGrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 02:47:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3FEGrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 02:47:03 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: sergei.shtylyov@cogentembedded.com, Jason Wang <jasowang@redhat.com>
Subject: [net-next rfc V3 2/9] macvtap: do not add self to waitqueue if doing a nonblock read
Date: Wed,  5 Jun 2013 14:36:25 +0800
Message-Id: <1370414192-5830-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1370414192-5830-1-git-send-email-jasowang@redhat.com>
References: <1370414192-5830-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to add self to waitqueue if doing a nonblock read. This could
help to avoid the spinlock contention.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 5e485e3..8949631 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -845,7 +845,9 @@ static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
 	ssize_t ret = 0;
 
 	while (len) {
-		prepare_to_wait(sk_sleep(&q->sk), &wait, TASK_INTERRUPTIBLE);
+		if (!noblock)
+			prepare_to_wait(sk_sleep(&q->sk), &wait,
+					TASK_INTERRUPTIBLE);
 
 		/* Read frames from the queue */
 		skb = skb_dequeue(&q->sk.sk_receive_queue);
@@ -867,7 +869,8 @@ static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
 		break;
 	}
 
-	finish_wait(sk_sleep(&q->sk), &wait);
+	if (!noblock)
+		finish_wait(sk_sleep(&q->sk), &wait);
 	return ret;
 }
 
-- 
1.7.1

