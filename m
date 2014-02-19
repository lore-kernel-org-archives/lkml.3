Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaBSSJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:09:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbaBSSJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:09:21 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: netdev@oss.sgi.com, davem@davemloft.net, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH 2/5] netlink: have netlink per-protocol bind function return an error code.
Date: Wed, 19 Feb 2014 13:08:20 -0500
Message-Id: <274547529fb494f50c794e4abfb8805c216580ac.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
In-Reply-To: <cover.1392831003.git.rgb@redhat.com>
References: <cover.1392831003.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have the netlink per-protocol optional bind function return an error code
rather than void to signal a failure.

This will enable netlink protocols to perform extra checks including
capabilities and permissions verifications when updating memberships in
multicast groups.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/netlink.h   |    2 +-
 net/netfilter/nfnetlink.c |    6 ++++--
 net/netlink/af_netlink.c  |   30 +++++++++++++++++-------------
 net/netlink/af_netlink.h  |    4 ++--
 4 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 7a6c396..4402653 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -45,7 +45,7 @@ struct netlink_kernel_cfg {
 	unsigned int	flags;
 	void		(*input)(struct sk_buff *skb);
 	struct mutex	*cb_mutex;
-	void		(*bind)(int group);
+	int		(*bind)(int group);
 	bool		(*compare)(struct net *net, struct sock *sk);
 };
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 046aa13..0edc4d6 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -392,7 +392,7 @@ static void nfnetlink_rcv(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_MODULES
-static void nfnetlink_bind(int group)
+static int nfnetlink_bind(int group)
 {
 	const struct nfnetlink_subsystem *ss;
 	int type = nfnl_group2type[group];
@@ -402,9 +402,11 @@ static void nfnetlink_bind(int group)
 	if (!ss) {
 		rcu_read_unlock();
 		request_module("nfnetlink-subsys-%d", type);
-		return;
+		return 0;
 	}
 	rcu_read_unlock();
+
+	return 0;
 }
 #endif
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index bca50b9..755912f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1198,7 +1198,7 @@ static int netlink_create(struct net *net, struct socket *sock, int protocol,
 	struct module *module = NULL;
 	struct mutex *cb_mutex;
 	struct netlink_sock *nlk;
-	void (*bind)(int group);
+	int (*bind)(int group);
 	int err = 0;
 
 	sock->state = SS_UNCONNECTED;
@@ -1441,6 +1441,17 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	if (!nladdr->nl_groups && (nlk->groups == NULL || !(u32)nlk->groups[0]))
 		return 0;
 
+	if (nlk->netlink_bind && nladdr->nl_groups) {
+		int i;
+
+		for (i=0; i<nlk->ngroups; i++)
+			if (test_bit(i, (long unsigned int *)&nladdr->nl_groups)) {
+				err = nlk->netlink_bind(i);
+				if (err)
+					return err;
+			}
+	}
+
 	netlink_table_grab();
 	netlink_update_subscriptions(sk, nlk->subscriptions +
 					 hweight32(nladdr->nl_groups) -
@@ -1449,15 +1460,6 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 	netlink_update_listeners(sk);
 	netlink_table_ungrab();
 
-	if (nlk->netlink_bind && nlk->groups[0]) {
-		int i;
-
-		for (i=0; i<nlk->ngroups; i++) {
-			if (test_bit(i, nlk->groups))
-				nlk->netlink_bind(i);
-		}
-	}
-
 	return 0;
 }
 
@@ -2095,14 +2097,16 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 			return err;
 		if (!val || val - 1 >= nlk->ngroups)
 			return -EINVAL;
+		if (nlk->netlink_bind) {
+			err = nlk->netlink_bind(val);
+			if (err)
+				return err;
+		}
 		netlink_table_grab();
 		netlink_update_socket_mc(nlk, val,
 					 optname == NETLINK_ADD_MEMBERSHIP);
 		netlink_table_ungrab();
 
-		if (nlk->netlink_bind)
-			nlk->netlink_bind(val);
-
 		err = 0;
 		break;
 	}
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index acbd774..0edb8d5 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -37,7 +37,7 @@ struct netlink_sock {
 	struct mutex		*cb_mutex;
 	struct mutex		cb_def_mutex;
 	void			(*netlink_rcv)(struct sk_buff *skb);
-	void			(*netlink_bind)(int group);
+	int			(*netlink_bind)(int group);
 	struct module		*module;
 #ifdef CONFIG_NETLINK_MMAP
 	struct mutex		pg_vec_lock;
@@ -73,7 +73,7 @@ struct netlink_table {
 	unsigned int		groups;
 	struct mutex		*cb_mutex;
 	struct module		*module;
-	void			(*bind)(int group);
+	int			(*bind)(int group);
 	bool			(*compare)(struct net *net, struct sock *sock);
 	int			registered;
 };
-- 
1.7.1

