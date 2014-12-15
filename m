Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaLOOeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38997 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaLOO3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xin Long <lucien.xin@gmail.com>, Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 152/168] ip_tunnel: the lack of vti_link_ops' dellink() cause kernel panic
Date: Mon, 15 Dec 2014 14:26:46 +0000
Message-Id: <1418653622-21105-153-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: lucien <lucien.xin@gmail.com>

commit 20ea60ca9952bd19d4b0d74719daba305aef5178 upstream.

Now the vti_link_ops do not point the .dellink, for fb tunnel device
(ip_vti0), the net_device will be removed as the default .dellink is
unregister_netdevice_queue,but the tunnel still in the tunnel list,
then if we add a new vti tunnel, in ip_tunnel_find():

        hlist_for_each_entry_rcu(t, head, hash_node) {
                if (local == t->parms.iph.saddr &&
                    remote == t->parms.iph.daddr &&
                    link == t->parms.link &&
==>                 type == t->dev->type &&
                    ip_tunnel_key_match(&t->parms, flags, key))
                        break;
        }

the panic will happen, cause dev of ip_tunnel *t is null:
[ 3835.072977] IP: [<ffffffffa04103fd>] ip_tunnel_find+0x9d/0xc0 [ip_tunnel]
[ 3835.073008] PGD b2c21067 PUD b7277067 PMD 0
[ 3835.073008] Oops: 0000 [#1] SMP
.....
[ 3835.073008] Stack:
[ 3835.073008]  ffff8800b72d77f0 ffffffffa0411924 ffff8800bb956000 ffff8800b72d78e0
[ 3835.073008]  ffff8800b72d78a0 0000000000000000 ffffffffa040d100 ffff8800b72d7858
[ 3835.073008]  ffffffffa040b2e3 0000000000000000 0000000000000000 0000000000000000
[ 3835.073008] Call Trace:
[ 3835.073008]  [<ffffffffa0411924>] ip_tunnel_newlink+0x64/0x160 [ip_tunnel]
[ 3835.073008]  [<ffffffffa040b2e3>] vti_newlink+0x43/0x70 [ip_vti]
[ 3835.073008]  [<ffffffff8150d4da>] rtnl_newlink+0x4fa/0x5f0
[ 3835.073008]  [<ffffffff812f68bb>] ? nla_strlcpy+0x5b/0x70
[ 3835.073008]  [<ffffffff81508fb0>] ? rtnl_link_ops_get+0x40/0x60
[ 3835.073008]  [<ffffffff8150d11f>] ? rtnl_newlink+0x13f/0x5f0
[ 3835.073008]  [<ffffffff81509cf4>] rtnetlink_rcv_msg+0xa4/0x270
[ 3835.073008]  [<ffffffff8126adf5>] ? sock_has_perm+0x75/0x90
[ 3835.073008]  [<ffffffff81509c50>] ? rtnetlink_rcv+0x30/0x30
[ 3835.073008]  [<ffffffff81529e39>] netlink_rcv_skb+0xa9/0xc0
[ 3835.073008]  [<ffffffff81509c48>] rtnetlink_rcv+0x28/0x30
....

modprobe ip_vti
ip link del ip_vti0 type vti
ip link add ip_vti0 type vti
rmmod ip_vti

do that one or more times, kernel will panic.

fix it by assigning ip_tunnel_dellink to vti_link_ops' dellink, in
which we skip the unregister of fb tunnel device. do the same on ip6_vti.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_vti.c  |  1 +
 net/ipv6/ip6_vti.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index b8960f3527f3..ea7525b1f996 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -528,6 +528,7 @@ static struct rtnl_link_ops vti_link_ops __read_mostly = {
 	.validate	= vti_tunnel_validate,
 	.newlink	= vti_newlink,
 	.changelink	= vti_changelink,
+	.dellink        = ip_tunnel_dellink,
 	.get_size	= vti_get_size,
 	.fill_info	= vti_fill_info,
 };
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index f3ce1cbc0bc5..7c6e6bfb1b0f 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -901,6 +901,15 @@ static int vti6_newlink(struct net *src_net, struct net_device *dev,
 	return vti6_tnl_create2(dev);
 }
 
+static void vti6_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct net *net = dev_net(dev);
+	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
+
+	if (dev != ip6n->fb_tnl_dev)
+		unregister_netdevice_queue(dev, head);
+}
+
 static int vti6_changelink(struct net_device *dev, struct nlattr *tb[],
 			   struct nlattr *data[])
 {
@@ -976,6 +985,7 @@ static struct rtnl_link_ops vti6_link_ops __read_mostly = {
 	.setup		= vti6_dev_setup,
 	.validate	= vti6_validate,
 	.newlink	= vti6_newlink,
+	.dellink	= vti6_dellink,
 	.changelink	= vti6_changelink,
 	.get_size	= vti6_get_size,
 	.fill_info	= vti6_fill_info,
@@ -1016,6 +1026,7 @@ static int __net_init vti6_init_net(struct net *net)
 	if (!ip6n->fb_tnl_dev)
 		goto err_alloc_dev;
 	dev_net_set(ip6n->fb_tnl_dev, net);
+	ip6n->fb_tnl_dev->rtnl_link_ops = &vti6_link_ops;
 
 	err = vti6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)
-- 
2.1.3

