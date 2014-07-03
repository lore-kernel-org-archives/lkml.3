Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030359AbaGCJYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030347AbaGCJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 146/198] net: force a list_del() in unregister_netdevice_many()
Date: Thu,  3 Jul 2014 10:19:49 +0100
Message-Id: <1404379241-8590-147-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 87757a917b0b3c0787e0563c679762152be81312 upstream.

unregister_netdevice_many() API is error prone and we had too
many bugs because of dangling LIST_HEAD on stacks.

See commit f87e6f47933e3e ("net: dont leave active on stack LIST_HEAD")

In fact, instead of making sure no caller leaves an active list_head,
just force a list_del() in the callee. No one seems to need to access
the list after unregister_netdevice_many()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvlan.c | 1 -
 net/core/dev.c        | 5 ++++-
 net/core/rtnetlink.c  | 1 -
 net/mac80211/iface.c  | 1 -
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e64fb8bc3e97..123c37f4f8d5 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -986,7 +986,6 @@ static int macvlan_device_event(struct notifier_block *unused,
 		list_for_each_entry_safe(vlan, next, &port->vlans, list)
 			vlan->dev->rtnl_link_ops->dellink(vlan->dev, &list_kill);
 		unregister_netdevice_many(&list_kill);
-		list_del(&list_kill);
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* Forbid underlaying device to change its type. */
diff --git a/net/core/dev.c b/net/core/dev.c
index 363e06e58c81..fe78e8c2fb3c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5964,6 +5964,9 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
 /**
  *	unregister_netdevice_many - unregister many devices
  *	@head: list of devices
+ *
+ *  Note: As most callers use a stack allocated list_head,
+ *  we force a list_del() to make sure stack wont be corrupted later.
  */
 void unregister_netdevice_many(struct list_head *head)
 {
@@ -5973,6 +5976,7 @@ void unregister_netdevice_many(struct list_head *head)
 		rollback_registered_many(head);
 		list_for_each_entry(dev, head, unreg_list)
 			net_set_todo(dev);
+		list_del(head);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_many);
@@ -6389,7 +6393,6 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 		}
 	}
 	unregister_netdevice_many(&dev_kill_list);
-	list_del(&dev_kill_list);
 	rtnl_unlock();
 }
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 76ebe61ed998..61b25794e74f 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1619,7 +1619,6 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	ops->dellink(dev, &list_kill);
 	unregister_netdevice_many(&list_kill);
-	list_del(&list_kill);
 	return 0;
 }
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index cc117591f678..a84e8f55f8ec 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1754,7 +1754,6 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->iflist_mtx);
 	unregister_netdevice_many(&unreg_list);
-	list_del(&unreg_list);
 
 	list_for_each_entry_safe(sdata, tmp, &wdev_list, list) {
 		list_del(&sdata->list);
-- 
1.9.1

