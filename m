Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220AbbA2ChZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46992 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091AbbA2ChT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Daniel Borkmann <dborkman@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 016/139] netfilter: conntrack: disable generic tracking for known protocols
Date: Wed, 28 Jan 2015 14:19:19 -0800
Message-Id: <1422483682-15393-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit db29a9508a9246e77087c5531e45b2c88ec6988b upstream.

Given following iptables ruleset:

-P FORWARD DROP
-A FORWARD -m sctp --dport 9 -j ACCEPT
-A FORWARD -p tcp --dport 80 -j ACCEPT
-A FORWARD -p tcp -m conntrack -m state ESTABLISHED,RELATED -j ACCEPT

One would assume that this allows SCTP on port 9 and TCP on port 80.
Unfortunately, if the SCTP conntrack module is not loaded, this allows
*all* SCTP communication, to pass though, i.e. -p sctp -j ACCEPT,
which we think is a security issue.

This is because on the first SCTP packet on port 9, we create a dummy
"generic l4" conntrack entry without any port information (since
conntrack doesn't know how to extract this information).

All subsequent packets that are unknown will then be in established
state since they will fallback to proto_generic and will match the
'generic' entry.

Our originally proposed version [1] completely disabled generic protocol
tracking, but Jozsef suggests to not track protocols for which a more
suitable helper is available, hence we now mitigate the issue for in
tree known ct protocol helpers only, so that at least NAT and direction
information will still be preserved for others.

 [1] http://www.spinics.net/lists/netfilter-devel/msg33430.html

Joint work with Daniel Borkmann.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netfilter/nf_conntrack_proto_generic.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index d25f293..957c1db 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -14,6 +14,30 @@
 
 static unsigned int nf_ct_generic_timeout __read_mostly = 600*HZ;
 
+static bool nf_generic_should_process(u8 proto)
+{
+	switch (proto) {
+#ifdef CONFIG_NF_CT_PROTO_SCTP_MODULE
+	case IPPROTO_SCTP:
+		return false;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_DCCP_MODULE
+	case IPPROTO_DCCP:
+		return false;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_GRE_MODULE
+	case IPPROTO_GRE:
+		return false;
+#endif
+#ifdef CONFIG_NF_CT_PROTO_UDPLITE_MODULE
+	case IPPROTO_UDPLITE:
+		return false;
+#endif
+	default:
+		return true;
+	}
+}
+
 static inline struct nf_generic_net *generic_pernet(struct net *net)
 {
 	return &net->ct.nf_ct_proto.generic;
@@ -67,7 +91,7 @@ static int generic_packet(struct nf_conn *ct,
 static bool generic_new(struct nf_conn *ct, const struct sk_buff *skb,
 			unsigned int dataoff, unsigned int *timeouts)
 {
-	return true;
+	return nf_generic_should_process(nf_ct_protonum(ct));
 }
 
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
-- 
1.9.1

