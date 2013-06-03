Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab3FCWNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:13:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4097 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115Ab3FCWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:40 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_1xTFJL4K3cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WvCumczFClAA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=L03L2QfmqWoA:10 a=qJl0yQZNg3oA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221159.316290756@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [41/65] macvlan: fix passthru mode race between dev removal and rx path
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0041-macvlan-fix-passthru-mode-race-between-dev-removal-a.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/macvlan.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 666fc20..0bec603 100644
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
1.7.10.4


