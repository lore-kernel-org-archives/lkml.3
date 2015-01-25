Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbbAYTII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:08:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbbAYSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Fomichev <git.user@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: [PATCH 3.14 95/98] net: fix creation adjacent device symlinks
Date: Sun, 25 Jan 2015 10:07:53 -0800
Message-Id: <20150125180717.009640454@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4705,9 +4705,14 @@ static void netdev_adjacent_sysfs_del(st
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
@@ -4737,7 +4742,7 @@ static int __netdev_adjacent_dev_insert(
 	pr_debug("dev_hold for %s, because of link added from %s to %s\n",
 		 adj_dev->name, dev->name, adj_dev->name);
 
-	if (netdev_adjacent_is_neigh_list(dev, dev_list)) {
+	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list)) {
 		ret = netdev_adjacent_sysfs_add(dev, adj_dev, dev_list);
 		if (ret)
 			goto free_adj;
@@ -4758,7 +4763,7 @@ static int __netdev_adjacent_dev_insert(
 	return 0;
 
 remove_symlinks:
-	if (netdev_adjacent_is_neigh_list(dev, dev_list))
+	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 free_adj:
 	kfree(adj);
@@ -4791,8 +4796,7 @@ static void __netdev_adjacent_dev_remove
 	if (adj->master)
 		sysfs_remove_link(&(dev->dev.kobj), "master");
 
-	if (netdev_adjacent_is_neigh_list(dev, dev_list) &&
-	    net_eq(dev_net(dev),dev_net(adj_dev)))
+	if (netdev_adjacent_is_neigh_list(dev, adj_dev, dev_list))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 
 	list_del_rcu(&adj->list);


