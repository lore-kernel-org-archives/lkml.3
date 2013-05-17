Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3EQViA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:38:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab3EQVhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 071/102] macvlan: fix passthru mode race between dev removal and rx path
Date: Fri, 17 May 2013 14:36:26 -0700
Message-Id: <20130517213251.811627079@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -222,7 +222,8 @@ static rx_handler_result_t macvlan_handl
 	}
 
 	if (port->passthru)
-		vlan = list_first_entry(&port->vlans, struct macvlan_dev, list);
+		vlan = list_first_or_null_rcu(&port->vlans,
+					      struct macvlan_dev, list);
 	else
 		vlan = macvlan_hash_lookup(port, eth->h_dest);
 	if (vlan == NULL)
@@ -807,7 +808,7 @@ int macvlan_common_newlink(struct net *s
 	if (err < 0)
 		goto upper_dev_unlink;
 
-	list_add_tail(&vlan->list, &port->vlans);
+	list_add_tail_rcu(&vlan->list, &port->vlans);
 	netif_stacked_transfer_operstate(lowerdev, dev);
 
 	return 0;
@@ -835,7 +836,7 @@ void macvlan_dellink(struct net_device *
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 
-	list_del(&vlan->list);
+	list_del_rcu(&vlan->list);
 	unregister_netdevice_queue(dev, head);
 	netdev_upper_dev_unlink(vlan->lowerdev, dev);
 }


