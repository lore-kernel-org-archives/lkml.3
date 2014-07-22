Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbaGVW5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:57:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44375 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaGVWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 002/116] netfilter: nf_nat: fix oops on netns removal
Date: Tue, 22 Jul 2014 15:20:13 -0700
Message-Id: <1406067727-19683-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 945b2b2d259d1a4364a2799e80e8ff32f8c6ee6f upstream.

Quoting Samu Kallio:

 Basically what's happening is, during netns cleanup,
 nf_nat_net_exit gets called before ipv4_net_exit. As I understand
 it, nf_nat_net_exit is supposed to kill any conntrack entries which
 have NAT context (through nf_ct_iterate_cleanup), but for some
 reason this doesn't happen (perhaps something else is still holding
 refs to those entries?).

 When ipv4_net_exit is called, conntrack entries (including those
 with NAT context) are cleaned up, but the
 nat_bysource hashtable is long gone - freed in nf_nat_net_exit. The
 bug happens when attempting to free a conntrack entry whose NAT hash
 'prev' field points to a slot in the freed hash table (head for that
 bin).

We ignore conntracks with null nat bindings.  But this is wrong,
as these are in bysource hash table as well.

Restore nat-cleaning for the netns-is-being-removed case.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=65191

Fixes: c2d421e1718 ('netfilter: nf_nat: fix race when unloading protocol modules')
Reported-by: Samu Kallio <samu.kallio@aberdeencloud.com>
Debugged-by: Samu Kallio <samu.kallio@aberdeencloud.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Samu Kallio <samu.kallio@aberdeencloud.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ kamal: backport to 3.8-stable: context ]
Cc: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netfilter/nf_nat_core.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 4bc2aaf..e40b77d 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -486,6 +486,39 @@ static int nf_nat_proto_remove(struct nf_conn *i, void *data)
 	return i->status & IPS_NAT_MASK ? 1 : 0;
 }
 
+static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
+{
+	struct nf_conn_nat *nat = nfct_nat(ct);
+
+	if (nf_nat_proto_remove(ct, data))
+		return 1;
+
+	if (!nat || !nat->ct)
+		return 0;
+
+	/* This netns is being destroyed, and conntrack has nat null binding.
+	 * Remove it from bysource hash, as the table will be freed soon.
+	 *
+	 * Else, when the conntrack is destoyed, nf_nat_cleanup_conntrack()
+	 * will delete entry from already-freed table.
+	 */
+	if (!del_timer(&ct->timeout))
+		return 1;
+
+	spin_lock_bh(&nf_nat_lock);
+	hlist_del_rcu(&nat->bysource);
+	ct->status &= ~IPS_NAT_DONE_MASK;
+	nat->ct = NULL;
+	spin_unlock_bh(&nf_nat_lock);
+
+	add_timer(&ct->timeout);
+
+	/* don't delete conntrack.  Although that would make things a lot
+	 * simpler, we'd end up flushing all conntracks on nat rmmod.
+	 */
+	return 0;
+}
+
 static void nf_nat_l4proto_clean(u8 l3proto, u8 l4proto)
 {
 	struct nf_nat_proto_clean clean = {
@@ -748,7 +781,7 @@ static void __net_exit nf_nat_net_exit(struct net *net)
 {
 	struct nf_nat_proto_clean clean = {};
 
-	nf_ct_iterate_cleanup(net, &nf_nat_proto_remove, &clean);
+	nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean);
 	synchronize_rcu();
 	nf_ct_free_hashtable(net->ct.nat_bysource, net->ct.nat_htable_size);
 }
-- 
1.9.1

