Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab3GZUtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:49:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759975Ab3GZUsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 42/79] vlan: fix a race in egress prio management
Date: Fri, 26 Jul 2013 13:47:32 -0700
Message-Id: <20130726204726.846842461@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan_dev.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_
 {
 	struct vlan_priority_tci_mapping *mp;
 
+	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priority() */
+
 	mp = vlan_dev_priv(dev)->egress_priority_map[(skb->priority & 0xF)];
 	while (mp) {
 		if (mp->priority == skb->priority) {
@@ -249,6 +251,11 @@ int vlan_dev_set_egress_priority(const s
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


