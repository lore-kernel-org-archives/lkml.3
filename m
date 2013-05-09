Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab3EIWcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:32:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab3EIWcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        CAI Qian <caiqian@redhat.com>, Patrick McHardy <kaber@trash.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 18/73] netfilter: nf_nat: fix race when unloading protocol modules
Date: Thu,  9 May 2013 15:31:41 -0700
Message-Id: <20130509222759.933753547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit c2d421e171868586939c328dfb91bab840fe4c49 upstream.

following oops was reported:
RIP: 0010:[<ffffffffa03227f2>]  [<ffffffffa03227f2>] nf_nat_cleanup_conntrack+0x42/0x70 [nf_nat]
RSP: 0018:ffff880202c63d40  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8801ac7bec28 RCX: ffff8801d0eedbe0
RDX: dead000000200200 RSI: 0000000000000011 RDI: ffffffffa03265b8
[..]
Call Trace:
 [..]
 [<ffffffffa02febed>] destroy_conntrack+0xbd/0x110 [nf_conntrack]

Happens when a conntrack timeout expires right after first part
of the nat cleanup has completed (bysrc hash removal), but before
part 2 has completed (re-initialization of nat area).

[ destroy callback tries to delete bysrc again ]

Patrick suggested to just remove the affected conntracks -- the
connections won't work properly anyway without nat transformation.

So, lets do that.

Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_nat_core.c |   40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -468,33 +468,22 @@ EXPORT_SYMBOL_GPL(nf_nat_packet);
 struct nf_nat_proto_clean {
 	u8	l3proto;
 	u8	l4proto;
-	bool	hash;
 };
 
-/* Clear NAT section of all conntracks, in case we're loaded again. */
-static int nf_nat_proto_clean(struct nf_conn *i, void *data)
+/* kill conntracks with affected NAT section */
+static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 {
 	const struct nf_nat_proto_clean *clean = data;
 	struct nf_conn_nat *nat = nfct_nat(i);
 
 	if (!nat)
 		return 0;
-	if (!(i->status & IPS_SRC_NAT_DONE))
-		return 0;
+
 	if ((clean->l3proto && nf_ct_l3num(i) != clean->l3proto) ||
 	    (clean->l4proto && nf_ct_protonum(i) != clean->l4proto))
 		return 0;
 
-	if (clean->hash) {
-		spin_lock_bh(&nf_nat_lock);
-		hlist_del_rcu(&nat->bysource);
-		spin_unlock_bh(&nf_nat_lock);
-	} else {
-		memset(nat, 0, sizeof(*nat));
-		i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK |
-			       IPS_SEQ_ADJUST);
-	}
-	return 0;
+	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
 static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
@@ -506,16 +495,8 @@ static void nf_nat_l4proto_clean(u8 l3pr
 	struct net *net;
 
 	rtnl_lock();
-	/* Step 1 - remove from bysource hash */
-	clean.hash = true;
 	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
-	synchronize_rcu();
-
-	/* Step 2 - clean NAT section */
-	clean.hash = false;
-	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
+		nf_ct_iterate_cleanup(net, nf_nat_proto_remove, &clean);
 	rtnl_unlock();
 }
 
@@ -527,16 +508,9 @@ static void nf_nat_l3proto_clean(u8 l3pr
 	struct net *net;
 
 	rtnl_lock();
-	/* Step 1 - remove from bysource hash */
-	clean.hash = true;
-	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
-	synchronize_rcu();
 
-	/* Step 2 - clean NAT section */
-	clean.hash = false;
 	for_each_net(net)
-		nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
+		nf_ct_iterate_cleanup(net, nf_nat_proto_remove, &clean);
 	rtnl_unlock();
 }
 
@@ -774,7 +748,7 @@ static void __net_exit nf_nat_net_exit(s
 {
 	struct nf_nat_proto_clean clean = {};
 
-	nf_ct_iterate_cleanup(net, &nf_nat_proto_clean, &clean);
+	nf_ct_iterate_cleanup(net, &nf_nat_proto_remove, &clean);
 	synchronize_rcu();
 	nf_ct_free_hashtable(net->ct.nat_bysource, net->ct.nat_htable_size);
 }


