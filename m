Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbaGHAth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:49:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaGGXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samu Kallio <samu.kallio@aberdeencloud.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.15 116/122] netfilter: nf_nat: fix oops on netns removal
Date: Mon,  7 Jul 2014 16:57:58 -0700
Message-Id: <20140707235737.716445225@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_nat_core.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -517,6 +517,39 @@ static int nf_nat_proto_remove(struct nf
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
@@ -787,7 +820,7 @@ static void __net_exit nf_nat_net_exit(s
 {
 	struct nf_nat_proto_clean clean = {};
 
-	nf_ct_iterate_cleanup(net, &nf_nat_proto_remove, &clean, 0, 0);
+	nf_ct_iterate_cleanup(net, nf_nat_proto_clean, &clean, 0, 0);
 	synchronize_rcu();
 	nf_ct_free_hashtable(net->ct.nat_bysource, net->ct.nat_htable_size);
 }


