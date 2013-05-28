Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab3E1Dzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52635 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758887Ab3E1DyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@resnulli.us>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.817818122@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [88/94] macvlan: fix passthru mode race between dev removal  and
 rx path
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 233c7df0821c4190e2d3f4be0f2ca0ab40a5ed8c, note
  that I had to add list_first_or_null_rcu to rculist.h in order
  to accomodate this fix. ]

Currently, if macvlan in passthru mode is created and data are rxed and
you remove this device, following panic happens:

NULL pointer dereference at 0000000000000198
IP: [<ffffffffa0196058>] macvlan_handle_frame+0x153/0x1f7 [macvlan]

I'm using following script to trigger this:
<script>
while [ 1 ]
do
	ip link add link e1 name macvtap0 type macvtap mode passthru
	ip link set e1 up
	ip link set macvtap0 up
	IFINDEX=`ip link |grep macvtap0 | cut -f 1 -d ':'`
	cat /dev/tap$IFINDEX  >/dev/null &
	ip link del dev macvtap0
done
</script>

I run this script while "ping -f" is running on another machine to send
packets to e1 rx.

Reason of the panic is that list_first_entry() is blindly called in
macvlan_handle_frame() even if the list was empty. vlan is set to
incorrect pointer which leads to the crash.

I'm fixing this by protecting port->vlans list by rcu and by preventing
from getting incorrect pointer in case the list is empty.

Introduced by: commit eb06acdc85585f2 "macvlan: Introduce 'passthru' mode to takeover the underlying device"

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvlan.c   |  7 ++++---
 include/linux/rculist.h | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 544ac06..301b39e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -204,7 +204,8 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 	}
 
 	if (port->passthru)
-		vlan = list_first_entry(&port->vlans, struct macvlan_dev, list);
+		vlan = list_first_or_null_rcu(&port->vlans,
+					      struct macvlan_dev, list);
 	else
 		vlan = macvlan_hash_lookup(port, eth->h_dest);
 	if (vlan == NULL)
@@ -725,7 +726,7 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		goto destroy_port;
 
-	list_add_tail(&vlan->list, &port->vlans);
+	list_add_tail_rcu(&vlan->list, &port->vlans);
 	netif_stacked_transfer_operstate(lowerdev, dev);
 
 	return 0;
@@ -751,7 +752,7 @@ void macvlan_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 
-	list_del(&vlan->list);
+	list_del_rcu(&vlan->list);
 	unregister_netdevice_queue(dev, head);
 }
 EXPORT_SYMBOL_GPL(macvlan_dellink);
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index d079290..6f95e24 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -242,6 +242,23 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	list_entry_rcu((ptr)->next, type, member)
 
 /**
+ * list_first_or_null_rcu - get the first element from a list
+ * @ptr:        the list head to take the element from.
+ * @type:       the type of the struct this is embedded in.
+ * @member:     the name of the list_struct within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ *
+ * This primitive may safely run concurrently with the _rcu list-mutation
+ * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
+ */
+#define list_first_or_null_rcu(ptr, type, member) \
+	({struct list_head *__ptr = (ptr); \
+	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
+	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
+	})
+
+/**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
  * @head:	the head for your list.

