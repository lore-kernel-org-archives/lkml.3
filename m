Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744AbbAYTIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:08:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbbAYSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Alexander Y. Fomichev" <git.user@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: [PATCH 3.14 94/98] net: prevent of emerging cross-namespace symlinks
Date: Sun, 25 Jan 2015 10:07:52 -0800
Message-Id: <20150125180716.969346298@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4791,7 +4791,8 @@ static void __netdev_adjacent_dev_remove
 	if (adj->master)
 		sysfs_remove_link(&(dev->dev.kobj), "master");
 
-	if (netdev_adjacent_is_neigh_list(dev, dev_list))
+	if (netdev_adjacent_is_neigh_list(dev, dev_list) &&
+	    net_eq(dev_net(dev),dev_net(adj_dev)))
 		netdev_adjacent_sysfs_del(dev, adj_dev->name, dev_list);
 
 	list_del_rcu(&adj->list);
@@ -5061,11 +5062,65 @@ void netdev_upper_dev_unlink(struct net_
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
@@ -5073,6 +5128,8 @@ void netdev_adjacent_rename_links(struct
 	}
 
 	list_for_each_entry(iter, &dev->adj_list.lower, list) {
+		if (!net_eq(net,dev_net(iter->dev)))
+			continue;
 		netdev_adjacent_sysfs_del(iter->dev, oldname,
 					  &iter->dev->adj_list.upper);
 		netdev_adjacent_sysfs_add(iter->dev, dev,
@@ -6679,6 +6736,7 @@ int dev_change_net_namespace(struct net_
 
 	/* Send a netdev-removed uevent to the old namespace */
 	kobject_uevent(&dev->dev.kobj, KOBJ_REMOVE);
+	netdev_adjacent_del_links(dev);
 
 	/* Actually switch the network namespace */
 	dev_net_set(dev, net);
@@ -6693,6 +6751,7 @@ int dev_change_net_namespace(struct net_
 
 	/* Send a netdev-add uevent to the new namespace */
 	kobject_uevent(&dev->dev.kobj, KOBJ_ADD);
+	netdev_adjacent_add_links(dev);
 
 	/* Fixup kobjects */
 	err = device_rename(&dev->dev, dev->name);


