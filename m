Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaAMOko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:40:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAMO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 76/96] macvtap: Do not double-count received packets
Date: Mon, 13 Jan 2014 14:24:39 +0000
Message-Id: <1389623099-18783-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: used devam's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvtap.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 8b7c4f2..81fbe78a 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -798,7 +798,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 				const struct sk_buff *skb,
 				const struct iovec *iv, int len)
 {
-	struct macvlan_dev *vlan;
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
@@ -852,12 +851,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
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

