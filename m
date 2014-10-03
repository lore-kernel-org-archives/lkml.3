Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbaJCWQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:16:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbaJCWOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.14 223/238] netfilter: xt_hashlimit: perform garbage collection from process context
Date: Fri,  3 Oct 2014 14:32:18 -0700
Message-Id: <20141003212920.798225983@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 7bd8490eef9776ced7632345df5133384b6be0fe upstream.

xt_hashlimit cannot be used with large hash tables, because garbage
collector is run from a timer. If table is really big, its possible
to hold cpu for more than 500 msec, which is unacceptable.

Switch to a work queue, and use proper scheduling points to remove
latencies spikes.

Later, we also could switch to a smoother garbage collection done
at lookup time, one bucket at a time...

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Patrick McHardy <kaber@trash.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_hashlimit.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -104,7 +104,7 @@ struct xt_hashlimit_htable {
 	spinlock_t lock;		/* lock for list_head */
 	u_int32_t rnd;			/* random seed for hash */
 	unsigned int count;		/* number entries in table */
-	struct timer_list timer;	/* timer for gc */
+	struct delayed_work gc_work;
 
 	/* seq_file stuff */
 	struct proc_dir_entry *pde;
@@ -213,7 +213,7 @@ dsthash_free(struct xt_hashlimit_htable
 	call_rcu_bh(&ent->rcu, dsthash_free_rcu);
 	ht->count--;
 }
-static void htable_gc(unsigned long htlong);
+static void htable_gc(struct work_struct *work);
 
 static int htable_create(struct net *net, struct xt_hashlimit_mtinfo1 *minfo,
 			 u_int8_t family)
@@ -273,9 +273,9 @@ static int htable_create(struct net *net
 	}
 	hinfo->net = net;
 
-	setup_timer(&hinfo->timer, htable_gc, (unsigned long)hinfo);
-	hinfo->timer.expires = jiffies + msecs_to_jiffies(hinfo->cfg.gc_interval);
-	add_timer(&hinfo->timer);
+	INIT_DEFERRABLE_WORK(&hinfo->gc_work, htable_gc);
+	queue_delayed_work(system_power_efficient_wq, &hinfo->gc_work,
+			   msecs_to_jiffies(hinfo->cfg.gc_interval));
 
 	hlist_add_head(&hinfo->node, &hashlimit_net->htables);
 
@@ -300,29 +300,30 @@ static void htable_selective_cleanup(str
 {
 	unsigned int i;
 
-	/* lock hash table and iterate over it */
-	spin_lock_bh(&ht->lock);
 	for (i = 0; i < ht->cfg.size; i++) {
 		struct dsthash_ent *dh;
 		struct hlist_node *n;
+
+		spin_lock_bh(&ht->lock);
 		hlist_for_each_entry_safe(dh, n, &ht->hash[i], node) {
 			if ((*select)(ht, dh))
 				dsthash_free(ht, dh);
 		}
+		spin_unlock_bh(&ht->lock);
+		cond_resched();
 	}
-	spin_unlock_bh(&ht->lock);
 }
 
-/* hash table garbage collector, run by timer */
-static void htable_gc(unsigned long htlong)
+static void htable_gc(struct work_struct *work)
 {
-	struct xt_hashlimit_htable *ht = (struct xt_hashlimit_htable *)htlong;
+	struct xt_hashlimit_htable *ht;
+
+	ht = container_of(work, struct xt_hashlimit_htable, gc_work.work);
 
 	htable_selective_cleanup(ht, select_gc);
 
-	/* re-add the timer accordingly */
-	ht->timer.expires = jiffies + msecs_to_jiffies(ht->cfg.gc_interval);
-	add_timer(&ht->timer);
+	queue_delayed_work(system_power_efficient_wq,
+			   &ht->gc_work, msecs_to_jiffies(ht->cfg.gc_interval));
 }
 
 static void htable_remove_proc_entry(struct xt_hashlimit_htable *hinfo)
@@ -341,7 +342,7 @@ static void htable_remove_proc_entry(str
 
 static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 {
-	del_timer_sync(&hinfo->timer);
+	cancel_delayed_work_sync(&hinfo->gc_work);
 	htable_remove_proc_entry(hinfo);
 	htable_selective_cleanup(hinfo, select_all);
 	kfree(hinfo->name);


