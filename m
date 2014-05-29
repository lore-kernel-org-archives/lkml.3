Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaE2Nxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:53:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59497 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933562AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Christensen <pch@ordbogen.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/103] macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
Date: Thu, 29 May 2014 15:49:21 +0200
Message-Id: <951c8657d8c4bb80afa304e4f506cdcf40fc1b8f.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Christensen <pch@ordbogen.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556 ]

Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
overflow on the underlying interface.

Attempting the set IFF_ALLMULTI on the underlying interface would cause an
error and the log message:

"allmulti touches root, set allmulti failed."

Signed-off-by: Peter Christensen <pch@ordbogen.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/macvlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index fb5f47e94547..743aa91c853c 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -425,8 +425,10 @@ static void macvlan_change_rx_flags(struct net_device *dev, int change)
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	struct net_device *lowerdev = vlan->lowerdev;
 
-	if (change & IFF_ALLMULTI)
-		dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
+	if (dev->flags & IFF_UP) {
+		if (change & IFF_ALLMULTI)
+			dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
+	}
 }
 
 static void macvlan_set_mac_lists(struct net_device *dev)
-- 
1.9.3

