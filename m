Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3J2SFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:05:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3J2SFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julian Anastasov <ja@ssi.bg>, Simon Horman <horms@verge.net.au>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 01/81] ipvs: add backup_only flag to avoid loops
Date: Tue, 29 Oct 2013 11:03:22 -0700
Message-Id: <1383069882-11437-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

commit 0c12582fbcdea0cbb0dfd224e1c5f9a8428ffa18 upstream.

Dmitry Akindinov is reporting for a problem where SYNs are looping
between the master and backup server when the backup server is used as
real server in DR mode and has IPVS rules to function as director.

Even when the backup function is enabled we continue to forward
traffic and schedule new connections when the current master is using
the backup server as real server. While this is not a problem for NAT,
for DR and TUN method the backup server can not determine if a request
comes from client or from director.

To avoid such loops add new sysctl flag backup_only. It can be needed
for DR/TUN setups that do not need backup and director function at the
same time. When the backup function is enabled we stop any forwarding
and pass the traffic to the local stack (real server mode). The flag
disables the director function when the backup function is enabled.

For setups that enable backup function for some virtual services and
director function for other virtual services there should be another
more complex solution to support DR/TUN mode, may be to assign
per-virtual service syncid value, so that we can differentiate the
requests.

Reported-by: Dmitry Akindinov <dimak@stalker.com>
Tested-by: German Myzovsky <lawyer@sipnet.ru>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 Documentation/networking/ipvs-sysctl.txt |  7 +++++++
 include/net/ip_vs.h                      | 12 ++++++++++++
 net/netfilter/ipvs/ip_vs_core.c          | 12 ++++++++----
 net/netfilter/ipvs/ip_vs_ctl.c           |  7 +++++++
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index f2a2488..9573d0c 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -15,6 +15,13 @@ amemthresh - INTEGER
         enabled and the variable is automatically set to 2, otherwise
         the strategy is disabled and the variable is  set  to 1.
 
+backup_only - BOOLEAN
+	0 - disabled (default)
+	not 0 - enabled
+
+	If set, disable the director function while the server is
+	in backup mode to avoid packet loops for DR/TUN methods.
+
 conntrack - BOOLEAN
 	0 - disabled (default)
 	not 0 - enabled
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 68c69d5..fce8e6b 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -976,6 +976,7 @@ struct netns_ipvs {
 	int			sysctl_sync_retries;
 	int			sysctl_nat_icmp_send;
 	int			sysctl_pmtu_disc;
+	int			sysctl_backup_only;
 
 	/* ip_vs_lblc */
 	int			sysctl_lblc_expiration;
@@ -1067,6 +1068,12 @@ static inline int sysctl_pmtu_disc(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_pmtu_disc;
 }
 
+static inline int sysctl_backup_only(struct netns_ipvs *ipvs)
+{
+	return ipvs->sync_state & IP_VS_STATE_BACKUP &&
+	       ipvs->sysctl_backup_only;
+}
+
 #else
 
 static inline int sysctl_sync_threshold(struct netns_ipvs *ipvs)
@@ -1114,6 +1121,11 @@ static inline int sysctl_pmtu_disc(struct netns_ipvs *ipvs)
 	return 1;
 }
 
+static inline int sysctl_backup_only(struct netns_ipvs *ipvs)
+{
+	return 0;
+}
+
 #endif
 
 /*
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index a9e07fe..bbbb9a1 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1604,7 +1604,8 @@ ip_vs_in(unsigned int hooknum, struct sk_buff *skb, int af)
 	}
 	/* ipvs enabled in this netns ? */
 	net = skb_net(skb);
-	if (!net_ipvs(net)->enable)
+	ipvs = net_ipvs(net);
+	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
 		return NF_ACCEPT;
 
 	ip_vs_fill_iph_skb(af, skb, &iph);
@@ -1690,7 +1691,6 @@ ip_vs_in(unsigned int hooknum, struct sk_buff *skb, int af)
 	}
 
 	IP_VS_DBG_PKT(11, af, pp, skb, 0, "Incoming packet");
-	ipvs = net_ipvs(net);
 	/* Check the server status */
 	if (cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
 		/* the destination server is not available */
@@ -1851,13 +1851,15 @@ ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
 {
 	int r;
 	struct net *net;
+	struct netns_ipvs *ipvs;
 
 	if (ip_hdr(skb)->protocol != IPPROTO_ICMP)
 		return NF_ACCEPT;
 
 	/* ipvs enabled in this netns ? */
 	net = skb_net(skb);
-	if (!net_ipvs(net)->enable)
+	ipvs = net_ipvs(net);
+	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
 		return NF_ACCEPT;
 
 	return ip_vs_in_icmp(skb, &r, hooknum);
@@ -1871,6 +1873,7 @@ ip_vs_forward_icmp_v6(unsigned int hooknum, struct sk_buff *skb,
 {
 	int r;
 	struct net *net;
+	struct netns_ipvs *ipvs;
 	struct ip_vs_iphdr iphdr;
 
 	ip_vs_fill_iph_skb(AF_INET6, skb, &iphdr);
@@ -1879,7 +1882,8 @@ ip_vs_forward_icmp_v6(unsigned int hooknum, struct sk_buff *skb,
 
 	/* ipvs enabled in this netns ? */
 	net = skb_net(skb);
-	if (!net_ipvs(net)->enable)
+	ipvs = net_ipvs(net);
+	if (unlikely(sysctl_backup_only(ipvs) || !ipvs->enable))
 		return NF_ACCEPT;
 
 	return ip_vs_in_icmp_v6(skb, &r, hooknum, &iphdr);
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 5f929a7..79c557d2 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1808,6 +1808,12 @@ static struct ctl_table vs_vars[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "backup_only",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #ifdef CONFIG_IP_VS_DEBUG
 	{
 		.procname	= "debug_level",
@@ -3742,6 +3748,7 @@ static int __net_init ip_vs_control_net_init_sysctl(struct net *net)
 	tbl[idx++].data = &ipvs->sysctl_nat_icmp_send;
 	ipvs->sysctl_pmtu_disc = 1;
 	tbl[idx++].data = &ipvs->sysctl_pmtu_disc;
+	tbl[idx++].data = &ipvs->sysctl_backup_only;
 
 
 	ipvs->sysctl_hdr = register_net_sysctl(net, "net/ipv4/vs", tbl);
-- 
1.8.1.2

