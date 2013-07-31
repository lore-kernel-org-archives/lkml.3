Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004Ab3GaNeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:34:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47089 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759844Ab3GaN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Patrick McHardy" <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.90937304@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [22/84] vlan: fix a race in egress prio management
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3e3aac497513c669e1c62c71e1d552ea85c1d974 ]

egress_priority_map[] hash table updates are protected by rtnl,
and we never remove elements until device is dismantled.

We have to make sure that before inserting an new element in hash table,
all its fields are committed to memory or else another cpu could
find corrupt values and crash.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/8021q/vlan_dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 0cccca8..b40d3da 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -72,6 +72,8 @@ vlan_dev_get_egress_qos_mask(struct net_device *dev, struct sk_buff *skb)
 {
 	struct vlan_priority_tci_mapping *mp;
 
+	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priority() */
+
 	mp = vlan_dev_info(dev)->egress_priority_map[(skb->priority & 0xF)];
 	while (mp) {
 		if (mp->priority == skb->priority) {
@@ -232,6 +234,11 @@ int vlan_dev_set_egress_priority(const struct net_device *dev,
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

