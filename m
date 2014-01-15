Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaAOWbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:31:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaAOV4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:56:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 141/166] macvtap: Do not double-count received packets
Date: Wed, 15 Jan 2014 13:52:35 -0800
Message-Id: <1389822780-4729-142-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit 006da7b07bc4d3a7ffabad17cf639eec6849c9dc ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 15820ab..a4df37f 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -805,7 +805,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 				const struct sk_buff *skb,
 				const struct iovec *iv, int len)
 {
-	struct macvlan_dev *vlan;
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
@@ -859,12 +858,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	copied += len;
 
 done:
-	rcu_read_lock_bh();
-	vlan = rcu_dereference_bh(q->vlan);
-	if (vlan)
-		macvlan_count_rx(vlan, copied - vnet_hdr_len, ret == 0, 0);
-	rcu_read_unlock_bh();
-
 	return ret ? ret : copied;
 }
 
-- 
1.8.3.2

