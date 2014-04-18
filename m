Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaDRJbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:31:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45992 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 55/72] tipc: fix spinlock recursion bug for failed subscriptions
Date: Fri, 18 Apr 2014 11:22:28 +0200
Message-Id: <21a018a58f3c92c7e39ca38b84643bd187e397db.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Hugne <erik.hugne@ericsson.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a5d0e7c037119484a7006b883618bfa87996cb41 ]

If a topology event subscription fails for any reason, such as out
of memory, max number reached or because we received an invalid
request the correct behavior is to terminate the subscribers
connection to the topology server. This is currently broken and
produces the following oops:

[27.953662] tipc: Subscription rejected, illegal request
[27.955329] BUG: spinlock recursion on CPU#1, kworker/u4:0/6
[27.957066]  lock: 0xffff88003c67f408, .magic: dead4ead, .owner: kworker/u4:0/6, .owner_cpu: 1
[27.958054] CPU: 1 PID: 6 Comm: kworker/u4:0 Not tainted 3.14.0-rc6+ #5
[27.960230] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[27.960874] Workqueue: tipc_rcv tipc_recv_work [tipc]
[27.961430]  ffff88003c67f408 ffff88003de27c18 ffffffff815c0207 ffff88003de1c050
[27.962292]  ffff88003de27c38 ffffffff815beec5 ffff88003c67f408 ffffffff817f0a8a
[27.963152]  ffff88003de27c58 ffffffff815beeeb ffff88003c67f408 ffffffffa0013520
[27.964023] Call Trace:
[27.964292]  [<ffffffff815c0207>] dump_stack+0x45/0x56
[27.964874]  [<ffffffff815beec5>] spin_dump+0x8c/0x91
[27.965420]  [<ffffffff815beeeb>] spin_bug+0x21/0x26
[27.965995]  [<ffffffff81083df6>] do_raw_spin_lock+0x116/0x140
[27.966631]  [<ffffffff815c6215>] _raw_spin_lock_bh+0x15/0x20
[27.967256]  [<ffffffffa0008540>] subscr_conn_shutdown_event+0x20/0xa0 [tipc]
[27.968051]  [<ffffffffa000fde4>] tipc_close_conn+0xa4/0xb0 [tipc]
[27.968722]  [<ffffffffa00101ba>] tipc_conn_terminate+0x1a/0x30 [tipc]
[27.969436]  [<ffffffffa00089a2>] subscr_conn_msg_event+0x1f2/0x2f0 [tipc]
[27.970209]  [<ffffffffa0010000>] tipc_receive_from_sock+0x90/0xf0 [tipc]
[27.970972]  [<ffffffffa000fa79>] tipc_recv_work+0x29/0x50 [tipc]
[27.971633]  [<ffffffff8105dbf5>] process_one_work+0x165/0x3e0
[27.972267]  [<ffffffff8105e869>] worker_thread+0x119/0x3a0
[27.972896]  [<ffffffff8105e750>] ? manage_workers.isra.25+0x2a0/0x2a0
[27.973622]  [<ffffffff810648af>] kthread+0xdf/0x100
[27.974168]  [<ffffffff810647d0>] ? kthread_create_on_node+0x1a0/0x1a0
[27.974893]  [<ffffffff815ce13c>] ret_from_fork+0x7c/0xb0
[27.975466]  [<ffffffff810647d0>] ? kthread_create_on_node+0x1a0/0x1a0

The recursion occurs when subscr_terminate tries to grab the
subscriber lock, which is already taken by subscr_conn_msg_event.
We fix this by checking if the request to establish a new
subscription was successful, and if not we initiate termination of
the subscriber after we have released the subscriber lock.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/subscr.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index 78bdf1db4cdf..c2a37aa12498 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -263,9 +263,9 @@ static void subscr_cancel(struct tipc_subscr *s,
  *
  * Called with subscriber lock held.
  */
-static struct tipc_subscription *subscr_subscribe(struct tipc_subscr *s,
-					     struct tipc_subscriber *subscriber)
-{
+static int subscr_subscribe(struct tipc_subscr *s,
+			    struct tipc_subscriber *subscriber,
+			    struct tipc_subscription **sub_p) {
 	struct tipc_subscription *sub;
 	int swap;
 
@@ -276,23 +276,21 @@ static struct tipc_subscription *subscr_subscribe(struct tipc_subscr *s,
 	if (s->filter & htohl(TIPC_SUB_CANCEL, swap)) {
 		s->filter &= ~htohl(TIPC_SUB_CANCEL, swap);
 		subscr_cancel(s, subscriber);
-		return NULL;
+		return 0;
 	}
 
 	/* Refuse subscription if global limit exceeded */
 	if (atomic_read(&subscription_count) >= TIPC_MAX_SUBSCRIPTIONS) {
 		pr_warn("Subscription rejected, limit reached (%u)\n",
 			TIPC_MAX_SUBSCRIPTIONS);
-		subscr_terminate(subscriber);
-		return NULL;
+		return -EINVAL;
 	}
 
 	/* Allocate subscription object */
 	sub = kmalloc(sizeof(*sub), GFP_ATOMIC);
 	if (!sub) {
 		pr_warn("Subscription rejected, no memory\n");
-		subscr_terminate(subscriber);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	/* Initialize subscription object */
@@ -306,8 +304,7 @@ static struct tipc_subscription *subscr_subscribe(struct tipc_subscr *s,
 	    (sub->seq.lower > sub->seq.upper)) {
 		pr_warn("Subscription rejected, illegal request\n");
 		kfree(sub);
-		subscr_terminate(subscriber);
-		return NULL;
+		return -EINVAL;
 	}
 	INIT_LIST_HEAD(&sub->nameseq_list);
 	list_add(&sub->subscription_list, &subscriber->subscription_list);
@@ -320,8 +317,8 @@ static struct tipc_subscription *subscr_subscribe(struct tipc_subscr *s,
 			     (Handler)subscr_timeout, (unsigned long)sub);
 		k_start_timer(&sub->timer, sub->timeout);
 	}
-
-	return sub;
+	*sub_p = sub;
+	return 0;
 }
 
 /* Handle one termination request for the subscriber */
@@ -335,10 +332,14 @@ static void subscr_conn_msg_event(int conid, struct sockaddr_tipc *addr,
 				  void *usr_data, void *buf, size_t len)
 {
 	struct tipc_subscriber *subscriber = usr_data;
-	struct tipc_subscription *sub;
+	struct tipc_subscription *sub = NULL;
 
 	spin_lock_bh(&subscriber->lock);
-	sub = subscr_subscribe((struct tipc_subscr *)buf, subscriber);
+	if (subscr_subscribe((struct tipc_subscr *)buf, subscriber, &sub) < 0) {
+		spin_unlock_bh(&subscriber->lock);
+		subscr_terminate(subscriber);
+		return;
+	}
 	if (sub)
 		tipc_nametbl_subscribe(sub);
 	spin_unlock_bh(&subscriber->lock);
-- 
1.9.2

