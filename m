Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaAMQTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:19:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaAMQEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 167/208] macvtap: Do not double-count received packets
Date: Mon, 13 Jan 2014 16:00:08 +0000
Message-Id: <1389628849-1614-168-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

commit 006da7b07bc4d3a7ffabad17cf639eec6849c9dc upstream.

Currently macvlan will count received packets after calling each
vlans receive handler.   Macvtap attempts to count the packet
yet again when the user reads the packet from the tap socket.
This code doesn't do this consistently either.  Remove the
counting from macvtap and let only macvlan count received
packets.

Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvtap.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 3c87e53..70d5800 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -870,7 +870,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 				const struct sk_buff *skb,
 				const struct iovec *iv, int len)
 {
-	struct macvlan_dev *vlan;
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
@@ -924,15 +923,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	copied += len;
 
 done:
-	rcu_read_lock();
-	vlan = rcu_dereference(q->vlan);
-	if (vlan) {
-		preempt_disable();
-		macvlan_count_rx(vlan, copied - vnet_hdr_len, ret == 0, 0);
-		preempt_enable();
-	}
-	rcu_read_unlock();
-
 	return ret ? ret : copied;
 }
 
-- 
1.8.3.2

