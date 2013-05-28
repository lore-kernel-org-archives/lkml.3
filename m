Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab3E1Vf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:35:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab3E1VZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 73/78] macvlan: fix passthru mode race between dev removal and rx path
Date: Tue, 28 May 2013 14:20:22 -0700
Message-Id: <1369776027-17859-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 233c7df0821c4190e2d3f4be0f2ca0ab40a5ed8c ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e5cb723..d30fc4d 100644
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
@@ -771,7 +772,7 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	if (err < 0)
 		goto destroy_port;
 
-	list_add_tail(&vlan->list, &port->vlans);
+	list_add_tail_rcu(&vlan->list, &port->vlans);
 	netif_stacked_transfer_operstate(lowerdev, dev);
 
 	return 0;
@@ -797,7 +798,7 @@ void macvlan_dellink(struct net_device *dev, struct list_head *head)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 
-	list_del(&vlan->list);
+	list_del_rcu(&vlan->list);
 	unregister_netdevice_queue(dev, head);
 }
 EXPORT_SYMBOL_GPL(macvlan_dellink);
-- 
1.8.1.2

