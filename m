Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3G3JpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:45:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53234 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab3G3JdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 064/106] vlan: fix a race in egress prio management
Date: Tue, 30 Jul 2013 10:31:23 +0100
Message-Id: <1375176725-5825-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 3e3aac497513c669e1c62c71e1d552ea85c1d974 upstream.

egress_priority_map[] hash table updates are protected by rtnl,
and we never remove elements until device is dismantled.

We have to make sure that before inserting an new element in hash table,
all its fields are committed to memory or else another cpu could
find corrupt values and crash.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/8021q/vlan_dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 7005e08..b8cf84e 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_device *dev, struct sk_buff *skb)
 {
 	struct vlan_priority_tci_mapping *mp;
 
+	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priority() */
+
 	mp = vlan_dev_priv(dev)->egress_priority_map[(skb->priority & 0xF)];
 	while (mp) {
 		if (mp->priority == skb->priority) {
@@ -235,6 +237,11 @@ int vlan_dev_set_egress_priority(const struct net_device *dev,
 	np->next = mp;
 	np->priority = skb_prio;
 	np->vlan_qos = vlan_qos;
+	/* Before inserting this element in hash table, make sure all its fields
+	 * are committed to memory.
+	 * coupled with smp_rmb() in vlan_dev_get_egress_qos_mask()
+	 */
+	smp_wmb();
 	vlan->egress_priority_map[skb_prio & 0xF] = np;
 	if (vlan_qos)
 		vlan->nr_egress_mappings++;
-- 
1.8.3.2

