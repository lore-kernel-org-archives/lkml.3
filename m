Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbbA0MU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:20:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767AbbA0MUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Alexander Y. Fomichev" <git.user@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel van Smoorenburg <mikevs@xs4all.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 121/126] net: prevent of emerging cross-namespace symlinks
Date: Tue, 27 Jan 2015 12:17:06 +0000
Message-Id: <1422361031-19364-122-git-send-email-luis.henriques@canonical.com>
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

commit 4c75431ac3520631f1d9e74aa88407e6374dbbc4 upstream.

Code manipulating sysfs symlinks on adjacent net_devices(s)
currently doesn't take into account that devices potentially
belong to different namespaces.

This patch trying to fix an issue as follows:
- check for net_ns before creating / deleting symlink.
  for now only netdev_adjacent_rename_links and
  __netdev_adjacent_dev_remove are affected, afaics
  __netdev_adjacent_dev_insert implies both net_devs
  belong to the same namespace.
- Drop all existing symlinks to / from all adj_devs before
  switching namespace and recreate them just after.

Signed-off-by: Alexander Y. Fomichev <git.user@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Miquel van Smoorenburg <mikevs@xs4all.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a4ebbe7d4f15..1a9b82061128 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4885,7 +4885,8 @@ static void __netdev_adjacent_dev_remove(struct net_device *dev,
 	if (adj->master)
 		sysfs_remove_link(&(dev->dev.kobj), "master");
 
-	if (netdev_adjacent_is_neigh_list(dev, dev_list))
+	if (netdev_adjacent_is_neigh_list(dev, dev_list) &&
+	    net_eq(dev_net(dev),dev_net(adj_dev)))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 
 	list_del_rcu(&adj->list);
@@ -5155,11 +5156,65 @@ void netdev_upper_dev_unlink(struct net_device *dev,
 }
 EXPORT_SYMBOL(netdev_upper_dev_unlink);
 
+void netdev_adjacent_add_links(struct net_device *dev)
+{
+	struct netdev_adjacent *iter;
+
+	struct net *net = dev_net(dev);
+
+	list_for_each_entry(iter, &dev->adj_list.upper, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
+		netdev_adjacent_sysfs_add(iter->dev, dev,
+					  &iter->dev->adj_list.lower);
+		netdev_adjacent_sysfs_add(dev, iter->dev,
+					  &dev->adj_list.upper);
+	}
+
+	list_for_each_entry(iter, &dev->adj_list.lower, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
+		netdev_adjacent_sysfs_add(iter->dev, dev,
+					  &iter->dev->adj_list.upper);
+		netdev_adjacent_sysfs_add(dev, iter->dev,
+					  &dev->adj_list.lower);
+	}
+}
+
+void netdev_adjacent_del_links(struct net_device *dev)
+{
+	struct netdev_adjacent *iter;
+
+	struct net *net = dev_net(dev);
+
+	list_for_each_entry(iter, &dev->adj_list.upper, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
+		netdev_adjacent_sysfs_del(iter->dev, dev->name,
+					  &iter->dev->adj_list.lower);
+		netdev_adjacent_sysfs_del(dev, iter->dev->name,
+					  &dev->adj_list.upper);
+	}
+
+	list_for_each_entry(iter, &dev->adj_list.lower, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
+		netdev_adjacent_sysfs_del(iter->dev, dev->name,
+					  &iter->dev->adj_list.upper);
+		netdev_adjacent_sysfs_del(dev, iter->dev->name,
+					  &dev->adj_list.lower);
+	}
+}
+
 void netdev_adjacent_rename_links(struct net_device *dev, char *oldname)
 {
 	struct netdev_adjacent *iter;
 
+	struct net *net = dev_net(dev);
+
 	list_for_each_entry(iter, &dev->adj_list.upper, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
 		netdev_adjacent_sysfs_del(iter->dev, oldname,
 					  &iter->dev->adj_list.lower);
 		netdev_adjacent_sysfs_add(iter->dev, dev,
@@ -5167,6 +5222,8 @@ void netdev_adjacent_rename_links(struct net_device *dev, char *oldname)
 	}
 
 	list_for_each_entry(iter, &dev->adj_list.lower, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
 		netdev_adjacent_sysfs_del(iter->dev, oldname,
 					  &iter->dev->adj_list.upper);
 		netdev_adjacent_sysfs_add(iter->dev, dev,
@@ -6770,6 +6827,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 
 	/* Send a netdev-removed uevent to the old namespace */
 	kobject_uevent(&dev->dev.kobj, KOBJ_REMOVE);
+	netdev_adjacent_del_links(dev);
 
 	/* Actually switch the network namespace */
 	dev_net_set(dev, net);
@@ -6784,6 +6842,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 
 	/* Send a netdev-add uevent to the new namespace */
 	kobject_uevent(&dev->dev.kobj, KOBJ_ADD);
+	netdev_adjacent_add_links(dev);
 
 	/* Fixup kobjects */
 	err = device_rename(&dev->dev, dev->name);
-- 
2.1.4

