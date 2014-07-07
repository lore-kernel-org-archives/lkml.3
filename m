Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaGHAtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:49:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaGGXyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.15 117/122] netfilter: ctnetlink: fix refcnt leak in dying/unconfirmed list dumper
Date: Mon,  7 Jul 2014 16:57:59 -0700
Message-Id: <20140707235737.744740701@linuxfoundation.org>
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

commit cd5f336f1780cb20e83146cde64d3d5779e175e6 upstream.

'last' keeps track of the ct that had its refcnt bumped during previous
dump cycle.  Thus it must not be overwritten until end-of-function.

Another (unrelated, theoretical) issue: Don't attempt to bump refcnt of a conntrack
whose reference count is already 0.  Such conntrack is being destroyed
right now, its memory is freed once we release the percpu dying spinlock.

Fixes: b7779d06 ('netfilter: conntrack: spinlock per cpu to protect special lists.')
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_netlink.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1150,7 +1150,7 @@ static int ctnetlink_done_list(struct ne
 static int
 ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
 {
-	struct nf_conn *ct, *last = NULL;
+	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
@@ -1163,6 +1163,8 @@ ctnetlink_dump_list(struct sk_buff *skb,
 	if (cb->args[2])
 		return 0;
 
+	last = (struct nf_conn *)cb->args[1];
+
 	for (cpu = cb->args[0]; cpu < nr_cpu_ids; cpu++) {
 		struct ct_pcpu *pcpu;
 
@@ -1171,7 +1173,6 @@ ctnetlink_dump_list(struct sk_buff *skb,
 
 		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 		spin_lock_bh(&pcpu->lock);
-		last = (struct nf_conn *)cb->args[1];
 		list = dying ? &pcpu->dying : &pcpu->unconfirmed;
 restart:
 		hlist_nulls_for_each_entry(h, n, list, hnnode) {
@@ -1190,7 +1191,8 @@ restart:
 						  ct);
 			rcu_read_unlock();
 			if (res < 0) {
-				nf_conntrack_get(&ct->ct_general);
+				if (!atomic_inc_not_zero(&ct->ct_general.use))
+					continue;
 				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
 				spin_unlock_bh(&pcpu->lock);


