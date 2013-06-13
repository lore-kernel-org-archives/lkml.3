Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3FMEcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 00:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3FMEcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 00:32:04 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [net-next PATCH 1/2] macvtap: slient sparse warnings
Date: Thu, 13 Jun 2013 12:21:33 +0800
Message-Id: <1371097294-5626-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch silents the following sparse warnings:

drivers/net/macvtap.c:98:9: warning: incorrect type in assignment (different
address spaces)
drivers/net/macvtap.c:98:9:    expected struct macvtap_queue *<noident>
drivers/net/macvtap.c:98:9:    got struct macvtap_queue [noderef]
<asn:4>*<noident>
drivers/net/macvtap.c:120:9: warning: incorrect type in assignment (different
address spaces)
drivers/net/macvtap.c:120:9:    expected struct macvtap_queue *<noident>
drivers/net/macvtap.c:120:9:    got struct macvtap_queue [noderef]
<asn:4>*<noident>
drivers/net/macvtap.c:151:22: error: incompatible types in comparison expression
(different address spaces)
drivers/net/macvtap.c:233:23: error: incompatible types in comparison expression
(different address spaces)
drivers/net/macvtap.c:243:23: error: incompatible types in comparison expression
(different address spaces)
drivers/net/macvtap.c:247:15: error: incompatible types in comparison expression
(different address spaces)
  CC [M]  drivers/net/macvtap.o
drivers/net/macvlan.c:232:24: error: incompatible types in comparison expression
(different address spaces)

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c      |    2 +-
 include/linux/if_macvlan.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 992151c..acf55ba 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -429,7 +429,7 @@ static int macvtap_open(struct inode *inode, struct file *file)
 	if (!q)
 		goto out;
 
-	q->sock.wq = &q->wq;
+	rcu_assign_pointer(q->sock.wq, &q->wq);
 	init_waitqueue_head(&q->wq.wait);
 	q->sock.type = SOCK_RAW;
 	q->sock.state = SS_CONNECTED;
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 1912133..f49a9f6 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -70,7 +70,7 @@ struct macvlan_dev {
 	int (*receive)(struct sk_buff *skb);
 	int (*forward)(struct net_device *dev, struct sk_buff *skb);
 	/* This array tracks active taps. */
-	struct macvtap_queue	*taps[MAX_MACVTAP_QUEUES];
+	struct macvtap_queue	__rcu *taps[MAX_MACVTAP_QUEUES];
 	/* This list tracks all taps (both enabled and disabled) */
 	struct list_head	queue_list;
 	int			numvtaps;
-- 
1.7.1

