Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485Ab3DGWzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:55:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46308 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758909Ab3DGWzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:55:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Patrick McHardy" <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Cong Wang" <amwang@redhat.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.398438224@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [56/74] 8021q: fix a potential use-after-free
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit 4a7df340ed1bac190c124c1601bfc10cde9fb4fb ]

vlan_vid_del() could possibly free ->vlan_info after a RCU grace
period, however, we may still refer to the freed memory area
by 'grp' pointer. Found by code inspection.

This patch moves vlan_vid_del() as behind as possible.

Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/8021q/vlan.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 5471628..963f285 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -110,13 +110,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
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
@@ -139,6 +132,13 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
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

