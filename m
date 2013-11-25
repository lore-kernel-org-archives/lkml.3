Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3KYJTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:19:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab3KYJT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:19:29 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] macvtap: fix tx_dropped counting error
Date: Mon, 25 Nov 2013 17:19:04 +0800
Message-Id: <1385371144-11071-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 8ffab51b3dfc54876f145f15b351c41f3f703195
(macvlan: lockless tx path), tx stat counter were converted to percpu stat
structure. So we need use to this also for tx_dropped in macvtap. Otherwise, the
management won't notice the dropping packet in macvtap tx path.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index dc76670..0605da8 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -744,7 +744,7 @@ err:
 	rcu_read_lock();
 	vlan = rcu_dereference(q->vlan);
 	if (vlan)
-		vlan->dev->stats.tx_dropped++;
+		this_cpu_inc(vlan->pcpu_stats->tx_dropped);
 	rcu_read_unlock();
 
 	return err;
-- 
1.8.3.2

