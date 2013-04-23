Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab3DWWD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:03:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3DWV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Voegtle <tv@lio96.de>, Cong Wang <amwang@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [ 02/23] Revert "8021q: fix a potential use-after-free"
Date: Tue, 23 Apr 2013 14:56:09 -0700
Message-Id: <20130423215456.549116188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 9829fe9806e22d7a822f4c947cc432c8d1774b54 which is
upstream commit 4a7df340ed1bac190c124c1601bfc10cde9fb4fb 

It turns out this causes problems on the 3.0-stable release.

Reported-by: Thomas Voegtle <tv@lio96.de>
Acked-by: Cong Wang <amwang@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/8021q/vlan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -108,6 +108,13 @@ void unregister_vlan_dev(struct net_devi
 	grp = rtnl_dereference(real_dev->vlgrp);
 	BUG_ON(!grp);
 
+	/* Take it out of our own structures, but be sure to interlock with
+	 * HW accelerating devices or SW vlan input packet processing if
+	 * VLAN is not 0 (leave it there for 802.1p).
+	 */
+	if (vlan_id && (real_dev->features & NETIF_F_HW_VLAN_FILTER))
+		ops->ndo_vlan_rx_kill_vid(real_dev, vlan_id);
+
 	grp->nr_vlans--;
 
 	if (vlan->flags & VLAN_FLAG_GVRP)
@@ -132,13 +139,6 @@ void unregister_vlan_dev(struct net_devi
 		call_rcu(&grp->rcu, vlan_rcu_free);
 	}
 
-	/* Take it out of our own structures, but be sure to interlock with
-	 * HW accelerating devices or SW vlan input packet processing if
-	 * VLAN is not 0 (leave it there for 802.1p).
-	 */
-	if (vlan_id && (real_dev->features & NETIF_F_HW_VLAN_FILTER))
-		ops->ndo_vlan_rx_kill_vid(real_dev, vlan_id);
-
 	/* Get rid of the vlan's reference to real_dev */
 	dev_put(real_dev);
 }


