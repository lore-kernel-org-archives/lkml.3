Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaHEFuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:50:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55849 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaHEFuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:50:16 -0400
Message-ID: <1407217807.3178.70.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next 2/3] netlink: Convert netlink_lookup() to use
 RCU protected hash table
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>
Cc: sasha.levin@oracle.com, tgraf@suug.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaber@trash.net,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org,
        challa@noironetworks.com, walpole@cs.pdx.edu, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org, nikolay@redhat.com
Date: Tue, 05 Aug 2014 07:50:07 +0200
In-Reply-To: <20140804.195841.536725238366145203.davem@davemloft.net>
References: <cover.1406971567.git.tgraf@suug.ch>
	 <a0370889bd1b1bdf097f74df7017d39ae845c12e.1406971567.git.tgraf@suug.ch>
	 <53E03D0B.3000208@oracle.com>
	 <20140804.195841.536725238366145203.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-08-04 at 19:58 -0700, David Miller wrote:
> From: Sasha Levin <sasha.levin@oracle.com>
> Date: Mon, 04 Aug 2014 22:10:19 -0400
> 
> > On 08/02/2014 05:47 AM, Thomas Graf wrote:
> >>  static void *netlink_seq_start(struct seq_file *seq, loff_t *pos)
> >> -	__acquires(nl_table_lock)
> >>  {
> >> -	read_lock(&nl_table_lock);
> >> +	rcu_read_lock();
> >>  	return *pos ? netlink_seq_socket_idx(seq, *pos - 1) : SEQ_START_TOKEN;
> >>  }
> > 
> > I'm not sure how you expect this code to work. You're replacing a local lock
> > with a RCU critical section. Imagine you're doing spin_lock() and just going
> > back to userspace.
> > 
> > It's quite easy to trigger this issue:
> 
> I think he expected the end of the seq sequence to drop the RCU lock,
> via netlink_seq_stop().
> --

Yes, two places use rht_dereference() instead of rht_dereference_rcu()

[PATCH net-next] netlink: fix lockdep splats

With netlink_lookup() conversion to RCU, we need to use appropriate
rcu dereference in netlink_seq_socket_idx() & netlink_seq_next()

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: 
Fixes: e341694e3eb57fc ("netlink: Convert netlink_lookup() to use RCU protected hash table")
---
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 0b89ca51a3af..479a344563d8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2899,7 +2899,7 @@ static struct sock *netlink_seq_socket_idx(struct seq_file *seq, loff_t pos)
 
 	for (i = 0; i < MAX_LINKS; i++) {
 		struct rhashtable *ht = &nl_table[i].hash;
-		const struct bucket_table *tbl = rht_dereference(ht->tbl, ht);
+		const struct bucket_table *tbl = rht_dereference_rcu(ht->tbl, ht);
 
 		for (j = 0; j < tbl->size; j++) {
 			rht_for_each_entry_rcu(nlk, tbl->buckets[j], node) {
@@ -2950,7 +2950,7 @@ static void *netlink_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 
 	do {
 		struct rhashtable *ht = &nl_table[i].hash;
-		const struct bucket_table *tbl = rht_dereference(ht->tbl, ht);
+		const struct bucket_table *tbl = rht_dereference_rcu(ht->tbl, ht);
 
 		for (; j < tbl->size; j++) {
 			rht_for_each_entry_rcu(nlk, tbl->buckets[j], node) {


