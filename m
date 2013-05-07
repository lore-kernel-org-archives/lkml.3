Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3EGCT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:19:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759981Ab3EGCTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201750"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 02/48] netlink: Add compare function for netlink_table
Date: Tue, 7 May 2013 10:20:23 +0800
Message-Id: <1367893269-9308-3-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:26,
	Serialize complete at 2013/05/07 10:18:26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we know, netlink sockets can communicate with each other
only when they in the same net namespace. this works
well until we try to add namespace support for other
subsystems which use netlink.

Don't like ipv4,route table,it is not suited to make this
subsytems belongs to net namespace, Such as audit and crypto
subsystems,they are more suitable to user namespace.

So we must have the ability to make the netlink sockets in
same user namespace can communicate with each other.

This patch adds a new function pointer "compare" for
netlink_table, we can decide if the netlink sockets can
communicate with each other through this netlink_table
self-defined compare function.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 include/linux/netlink.h  |  1 +
 net/netlink/af_netlink.c | 26 ++++++++++++++++++++------
 net/netlink/af_netlink.h |  1 +
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 6358da5..f78b430 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -46,6 +46,7 @@ struct netlink_kernel_cfg {
 	void		(*input)(struct sk_buff *skb);
 	struct mutex	*cb_mutex;
 	void		(*bind)(int group);
+	bool		(*compare)(struct net *net, struct sock *sk);
 };
 
 extern struct sock *__netlink_kernel_create(struct net *net, int unit,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 12ac6b4..41cc3c8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -854,16 +854,23 @@ netlink_unlock_table(void)
 		wake_up(&nl_table_wait);
 }
 
+static bool netlink_compare(struct net *net, struct sock *sk)
+{
+	return net_eq(sock_net(sk), net);
+}
+
 static struct sock *netlink_lookup(struct net *net, int protocol, u32 portid)
 {
-	struct nl_portid_hash *hash = &nl_table[protocol].hash;
+	struct netlink_table *table = &nl_table[protocol];
+	struct nl_portid_hash *hash = &table->hash;
 	struct hlist_head *head;
 	struct sock *sk;
 
 	read_lock(&nl_table_lock);
 	head = nl_portid_hashfn(hash, portid);
 	sk_for_each(sk, head) {
-		if (net_eq(sock_net(sk), net) && (nlk_sk(sk)->portid == portid)) {
+		if (table->compare(net, sk) &&
+		    (nlk_sk(sk)->portid == portid)) {
 			sock_hold(sk);
 			goto found;
 		}
@@ -976,7 +983,8 @@ netlink_update_listeners(struct sock *sk)
 
 static int netlink_insert(struct sock *sk, struct net *net, u32 portid)
 {
-	struct nl_portid_hash *hash = &nl_table[sk->sk_protocol].hash;
+	struct netlink_table *table = &nl_table[sk->sk_protocol];
+	struct nl_portid_hash *hash = &table->hash;
 	struct hlist_head *head;
 	int err = -EADDRINUSE;
 	struct sock *osk;
@@ -986,7 +994,8 @@ static int netlink_insert(struct sock *sk, struct net *net, u32 portid)
 	head = nl_portid_hashfn(hash, portid);
 	len = 0;
 	sk_for_each(osk, head) {
-		if (net_eq(sock_net(osk), net) && (nlk_sk(osk)->portid == portid))
+		if (table->compare(net, osk) &&
+		    (nlk_sk(osk)->portid == portid))
 			break;
 		len++;
 	}
@@ -1161,6 +1170,7 @@ static int netlink_release(struct socket *sock)
 			kfree_rcu(old, rcu);
 			nl_table[sk->sk_protocol].module = NULL;
 			nl_table[sk->sk_protocol].bind = NULL;
+			nl_table[sk->sk_protocol].compare = NULL;
 			nl_table[sk->sk_protocol].flags = 0;
 			nl_table[sk->sk_protocol].registered = 0;
 		}
@@ -1183,7 +1193,8 @@ static int netlink_autobind(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct net *net = sock_net(sk);
-	struct nl_portid_hash *hash = &nl_table[sk->sk_protocol].hash;
+	struct netlink_table *table = &nl_table[sk->sk_protocol];
+	struct nl_portid_hash *hash = &table->hash;
 	struct hlist_head *head;
 	struct sock *osk;
 	s32 portid = task_tgid_vnr(current);
@@ -1195,7 +1206,7 @@ retry:
 	netlink_table_grab();
 	head = nl_portid_hashfn(hash, portid);
 	sk_for_each(osk, head) {
-		if (!net_eq(sock_net(osk), net))
+		if (!table->compare(net, osk))
 			continue;
 		if (nlk_sk(osk)->portid == portid) {
 			/* Bind collision, search negative portid values. */
@@ -2282,9 +2293,12 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
 		rcu_assign_pointer(nl_table[unit].listeners, listeners);
 		nl_table[unit].cb_mutex = cb_mutex;
 		nl_table[unit].module = module;
+		nl_table[unit].compare = netlink_compare;
 		if (cfg) {
 			nl_table[unit].bind = cfg->bind;
 			nl_table[unit].flags = cfg->flags;
+			if (cfg->compare)
+				nl_table[unit].compare = cfg->compare;
 		}
 		nl_table[unit].registered = 1;
 	} else {
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index ed85222..eaa88d1 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -73,6 +73,7 @@ struct netlink_table {
 	struct mutex		*cb_mutex;
 	struct module		*module;
 	void			(*bind)(int group);
+	bool			(*compare)(struct net *net, struct sock *sock);
 	int			registered;
 };
 
-- 
1.8.1.4

