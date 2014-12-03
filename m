Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaLCMBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:01:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbaLCL1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/101] vxlan: Do not reuse sockets for a different address family
Date: Wed,  3 Dec 2014 12:25:27 +0100
Message-Id: <b27471ba5de8c062caf9819a5ed26e429cde9869.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Leitner <mleitner@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 19ca9fc1445b76b60d34148f7ff837b055f5dcf3 ]

Currently, we only match against local port number in order to reuse
socket. But if this new vxlan wants an IPv6 socket and a IPv4 one bound
to that port, vxlan will reuse an IPv4 socket as IPv6 and a panic will
follow. The following steps reproduce it:

   # ip link add vxlan6 type vxlan id 42 group 229.10.10.10 \
       srcport 5000 6000 dev eth0
   # ip link add vxlan7 type vxlan id 43 group ff0e::110 \
       srcport 5000 6000 dev eth0
   # ip link set vxlan6 up
   # ip link set vxlan7 up
   <panic>

[    4.187481] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
...
[    4.188076] Call Trace:
[    4.188085]  [<ffffffff81667c4a>] ? ipv6_sock_mc_join+0x3a/0x630
[    4.188098]  [<ffffffffa05a6ad6>] vxlan_igmp_join+0x66/0xd0 [vxlan]
[    4.188113]  [<ffffffff810a3430>] process_one_work+0x220/0x710
[    4.188125]  [<ffffffff810a33c4>] ? process_one_work+0x1b4/0x710
[    4.188138]  [<ffffffff810a3a3b>] worker_thread+0x11b/0x3a0
[    4.188149]  [<ffffffff810a3920>] ? process_one_work+0x710/0x710

So address family must also match in order to reuse a socket.

Reported-by: Jean-Tsung Hsiao <jhsiao@redhat.com>
Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/vxlan.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 23969eaf88c1..5407c11a9f14 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -282,13 +282,15 @@ static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
 	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
 }
 
-/* Find VXLAN socket based on network namespace and UDP port */
-static struct vxlan_sock *vxlan_find_sock(struct net *net, __be16 port)
+/* Find VXLAN socket based on network namespace, address family and UDP port */
+static struct vxlan_sock *vxlan_find_sock(struct net *net,
+					  sa_family_t family, __be16 port)
 {
 	struct vxlan_sock *vs;
 
 	hlist_for_each_entry_rcu(vs, vs_head(net, port), hlist) {
-		if (inet_sk(vs->sock->sk)->inet_sport == port)
+		if (inet_sk(vs->sock->sk)->inet_sport == port &&
+		    inet_sk(vs->sock->sk)->sk.sk_family == family)
 			return vs;
 	}
 	return NULL;
@@ -307,11 +309,12 @@ static struct vxlan_dev *vxlan_vs_find_vni(struct vxlan_sock *vs, u32 id)
 }
 
 /* Look up VNI in a per net namespace table */
-static struct vxlan_dev *vxlan_find_vni(struct net *net, u32 id, __be16 port)
+static struct vxlan_dev *vxlan_find_vni(struct net *net, u32 id,
+					sa_family_t family, __be16 port)
 {
 	struct vxlan_sock *vs;
 
-	vs = vxlan_find_sock(net, port);
+	vs = vxlan_find_sock(net, family, port);
 	if (!vs)
 		return NULL;
 
@@ -1783,7 +1786,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			struct vxlan_dev *dst_vxlan;
 
 			ip_rt_put(rt);
-			dst_vxlan = vxlan_find_vni(dev_net(dev), vni, dst_port);
+			dst_vxlan = vxlan_find_vni(dev_net(dev), vni,
+						   dst->sa.sa_family, dst_port);
 			if (!dst_vxlan)
 				goto tx_error;
 			vxlan_encap_bypass(skb, vxlan, dst_vxlan);
@@ -1836,7 +1840,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			struct vxlan_dev *dst_vxlan;
 
 			dst_release(ndst);
-			dst_vxlan = vxlan_find_vni(dev_net(dev), vni, dst_port);
+			dst_vxlan = vxlan_find_vni(dev_net(dev), vni,
+						   dst->sa.sa_family, dst_port);
 			if (!dst_vxlan)
 				goto tx_error;
 			vxlan_encap_bypass(skb, vxlan, dst_vxlan);
@@ -1987,6 +1992,7 @@ static int vxlan_init(struct net_device *dev)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_net *vn = net_generic(dev_net(dev), vxlan_net_id);
+	bool ipv6 = vxlan->flags & VXLAN_F_IPV6;
 	struct vxlan_sock *vs;
 
 	dev->tstats = alloc_percpu(struct pcpu_tstats);
@@ -1994,7 +2000,8 @@ static int vxlan_init(struct net_device *dev)
 		return -ENOMEM;
 
 	spin_lock(&vn->sock_lock);
-	vs = vxlan_find_sock(dev_net(dev), vxlan->dst_port);
+	vs = vxlan_find_sock(dev_net(dev), ipv6 ? AF_INET6 : AF_INET,
+			     vxlan->dst_port);
 	if (vs) {
 		/* If we have a socket with same port already, reuse it */
 		atomic_inc(&vs->refcnt);
@@ -2439,7 +2446,7 @@ struct vxlan_sock *vxlan_sock_add(struct net *net, __be16 port,
 		return vs;
 
 	spin_lock(&vn->sock_lock);
-	vs = vxlan_find_sock(net, port);
+	vs = vxlan_find_sock(net, ipv6 ? AF_INET6 : AF_INET, port);
 	if (vs) {
 		if (vs->rcv == rcv)
 			atomic_inc(&vs->refcnt);
@@ -2584,7 +2591,8 @@ static int vxlan_newlink(struct net *net, struct net_device *dev,
 	if (data[IFLA_VXLAN_PORT])
 		vxlan->dst_port = nla_get_be16(data[IFLA_VXLAN_PORT]);
 
-	if (vxlan_find_vni(net, vni, vxlan->dst_port)) {
+	if (vxlan_find_vni(net, vni, use_ipv6 ? AF_INET6 : AF_INET,
+			   vxlan->dst_port)) {
 		pr_info("duplicate VNI %u\n", vni);
 		return -EEXIST;
 	}
-- 
2.1.3

