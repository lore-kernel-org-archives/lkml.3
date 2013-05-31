Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3EaKF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:05:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3EaKDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:03:44 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next rfc V2 1/8] macvtap: do not add self to waitqueue if doing a nonblock read
Date: Fri, 31 May 2013 17:53:18 +0800
Message-Id: <1369994005-5943-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369994005-5943-1-git-send-email-jasowang@redhat.com>
References: <1369994005-5943-1-git-send-email-jasowang@redhat.com>
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
index 59e9605..2395062 100644
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

