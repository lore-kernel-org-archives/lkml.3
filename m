Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaFWIkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:40:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55608 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/111] net: force a list_del() in unregister_netdevice_many()
Date: Mon, 23 Jun 2014 10:32:20 +0200
Message-Id: <cbaf35e5ba05b9ff2f43d798fe4082cca8151861.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 87757a917b0b3c0787e0563c679762152be81312 ]

unregister_netdevice_many() API is error prone and we had too
many bugs because of dangling LIST_HEAD on stacks.

See commit f87e6f47933e3e ("net: dont leave active on stack LIST_HEAD")

In fact, instead of making sure no caller leaves an active list_head,
just force a list_del() in the callee. No one seems to need to access
the list after unregister_netdevice_many()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/macvlan.c | 1 -
 net/core/dev.c        | 5 ++++-
 net/core/rtnetlink.c  | 1 -
 net/mac80211/iface.c  | 1 -
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 743aa91c853c..f6b7257466bc 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -991,7 +991,6 @@ static int macvlan_device_event(struct notifier_block *unused,
 		list_for_each_entry_safe(vlan, next, &port->vlans, list)
 			vlan->dev->rtnl_link_ops->dellink(vlan->dev, &list_kill);
 		unregister_netdevice_many(&list_kill);
-		list_del(&list_kill);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* Forbid underlaying device to change its type. */
diff --git a/net/core/dev.c b/net/core/dev.c
index 01d53d62a2ec..58990d60e65b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6208,6 +6208,9 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
 /**
  *	unregister_netdevice_many - unregister many devices
  *	@head: list of devices
+ *
+ *  Note: As most callers use a stack allocated list_head,
+ *  we force a list_del() to make sure stack wont be corrupted later.
  */
 void unregister_netdevice_many(struct list_head *head)
 {
@@ -6217,6 +6220,7 @@ void unregister_netdevice_many(struct list_head *head)
 		rollback_registered_many(head);
 		list_for_each_entry(dev, head, unreg_list)
 			net_set_todo(dev);
+		list_del(head);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_many);
@@ -6672,7 +6676,6 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 		}
 	}
 	unregister_netdevice_many(&dev_kill_list);
-	list_del(&dev_kill_list);
 	rtnl_unlock();
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e46ced7c9c33..f3d46dfb6944 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1673,7 +1673,6 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	ops->dellink(dev, &list_kill);
 	unregister_netdevice_many(&list_kill);
-	list_del(&list_kill);
 	return 0;
 }
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index fcecd633514e..d019b42e4a65 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1766,7 +1766,6 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->iflist_mtx);
 	unregister_netdevice_many(&unreg_list);
-	list_del(&unreg_list);
 
 	list_for_each_entry_safe(sdata, tmp, &wdev_list, list) {
 		list_del(&sdata->list);
-- 
2.0.0

