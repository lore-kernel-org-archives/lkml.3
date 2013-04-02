Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758716Ab3DBWy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:54:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab3DBWu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:50:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <amwang@redhat.com>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [ 45/56] 8021q: fix a potential use-after-free
Date: Tue,  2 Apr 2013 15:50:12 -0700
Message-Id: <20130402224717.071394205@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402224711.840825715@linuxfoundation.org>
References: <20130402224711.840825715@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Cong Wang <amwang@redhat.com>

[ Upstream commit 4a7df340ed1bac190c124c1601bfc10cde9fb4fb ]

vlan_vid_del() could possibly free ->vlan_info after a RCU grace
period, however, we may still refer to the freed memory area
by 'grp' pointer. Found by code inspection.

This patch moves vlan_vid_del() as behind as possible.

Signed-off-by: Cong Wang <amwang@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -108,13 +108,6 @@ void unregister_vlan_dev(struct net_devi
 	grp = rtnl_dereference(real_dev->vlgrp);
 	BUG_ON(!grp);
 
-	/* Take it out of our own structures, but be sure to interlock with
-	 * HW accelerating devices or SW vlan input packet processing if
-	 * VLAN is not 0 (leave it there for 802.1p).
-	 */
-	if (vlan_id && (real_dev->features & NETIF_F_HW_VLAN_FILTER))
-		ops->ndo_vlan_rx_kill_vid(real_dev, vlan_id);
-
 	grp->nr_vlans--;
 
 	if (vlan->flags & VLAN_FLAG_GVRP)
@@ -139,6 +132,13 @@ void unregister_vlan_dev(struct net_devi
 		call_rcu(&grp->rcu, vlan_rcu_free);
 	}
 
+	/* Take it out of our own structures, but be sure to interlock with
+	 * HW accelerating devices or SW vlan input packet processing if
+	 * VLAN is not 0 (leave it there for 802.1p).
+	 */
+	if (vlan_id && (real_dev->features & NETIF_F_HW_VLAN_FILTER))
+		ops->ndo_vlan_rx_kill_vid(real_dev, vlan_id);
+
 	/* Get rid of the vlan's reference to real_dev */
 	dev_put(real_dev);
 }


