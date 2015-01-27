Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbbA0MVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:21:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbbA0MUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Fomichev <git.user@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel van Smoorenburg <mikevs@xs4all.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 122/126] net: fix creation adjacent device symlinks
Date: Tue, 27 Jan 2015 12:17:07 +0000
Message-Id: <1422361031-19364-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Alexander Y. Fomichev" <git.user@gmail.com>

commit 7ce64c79c4decdeb1afe0bf2f6ef834b382871d1 upstream.

__netdev_adjacent_dev_insert may add adjust device of different net
namespace, without proper check it leads to emergence of broken
sysfs links from/to devices in another namespace.
Fix: rewrite netdev_adjacent_is_neigh_list macro as a function,
     move net_eq check into netdev_adjacent_is_neigh_list.
     (thanks David)
     related to: 4c75431ac3520631f1d9e74aa88407e6374dbbc4

Signed-off-by: Alexander Fomichev <git.user@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1a9b82061128..2d93b9de1d7b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4799,9 +4799,14 @@ static void netdev_adjacent_sysfs_del(struct net_device *dev,
 	sysfs_remove_link(&(dev->dev.kobj), linkname);
 }
 
-#define netdev_adjacent_is_neigh_list(dev, dev_list) \
-		(dev_list == &dev->adj_list.upper || \
-		 dev_list == &dev->adj_list.lower)
+static inline bool netdev_adjacent_is_neigh_list(struct net_device *dev,
+						 struct net_device *adj_dev,
+						 struct list_head *dev_list)
+{
+	return (dev_list == &dev->adj_list.upper ||
+		dev_list == &dev->adj_list.lower) &&
+		net_eq(dev_net(dev), dev_net(adj_dev));
+}
 
 static int __netdev_adjacent_dev_insert(struct net_device *dev,
 					struct net_device *adj_dev,
@@ -4831,7 +4836,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	pr_debug("dev_hold for %s, because of link added from %s to %s\n",
 		 adj_dev->name, dev->name, adj_dev->name);
 
-	if (netdev_adjacent_is_neigh_list(dev, dev_list)) {
+	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list)) {
 		ret = netdev_adjacent_sysfs_add(dev, adj_dev, dev_list);
 		if (ret)
 			goto free_adj;
@@ -4852,7 +4857,7 @@ static int __netdev_adjacent_dev_insert(struct net_device *dev,
 	return 0;
 
 remove_symlinks:
-	if (netdev_adjacent_is_neigh_list(dev, dev_list))
+	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 free_adj:
 	kfree(adj);
@@ -4885,8 +4890,7 @@ static void __netdev_adjacent_dev_remove(struct net_device *dev,
 	if (adj->master)
 		sysfs_remove_link(&(dev->dev.kobj), "master");
 
-	if (netdev_adjacent_is_neigh_list(dev, dev_list) &&
-	    net_eq(dev_net(dev),dev_net(adj_dev)))
+	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 
 	list_del_rcu(&adj->list);
-- 
2.1.4

