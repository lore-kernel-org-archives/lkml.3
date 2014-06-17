Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaFQWra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:47:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53759 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965678AbaFQVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:46:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Christensen <pch@ordbogen.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/212] macvlan: Don't propagate IFF_ALLMULTI changes on down interfaces.
Date: Tue, 17 Jun 2014 14:42:23 -0700
Message-Id: <1403041506-13646-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Christensen <pch@ordbogen.com>

[ Upstream commit bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556 ]

Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
overflow on the underlying interface.

Attempting the set IFF_ALLMULTI on the underlying interface would cause an
error and the log message:

"allmulti touches root, set allmulti failed."

Signed-off-by: Peter Christensen <pch@ordbogen.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index fbb21fa..9687122 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -459,8 +459,10 @@ static void macvlan_change_rx_flags(struct net_device *dev, int change)
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
1.9.1

