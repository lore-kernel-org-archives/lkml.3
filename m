Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab3APP7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3APP7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 027/222] rcu: Fix batch-limit size problem
Date: Wed, 16 Jan 2013 13:53:47 -0200
Message-Id: <1358351822-7675-28-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 878d7439d0f45a95869e417576774673d1fa243f upstream.

Commit 29c00b4a1d9e27 (rcu: Add event-tracing for RCU callback
invocation) added a regression in rcu_do_batch()

Under stress, RCU is supposed to allow to process all items in queue,
instead of a batch of 10 items (blimit), but an integer overflow makes
the effective limit being 1.  So, unless there is frequent idle periods
(during which RCU ignores batch limits), RCU can be forced into a
state where it cannot keep up with the callback-generation rate,
eventually resulting in OOM.

This commit therefore converts a few variables in rcu_do_batch() from
int to long to fix this problem, along with the module parameters
controlling the batch limits.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
[ herton: adjust for different module_param permissions ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/rcutree.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd55ba1..232dd61 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -211,13 +211,13 @@ DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks = ATOMIC_INIT(1),
 };
 
-static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
-static int qhimark = 10000;	/* If this many pending, ignore blimit. */
-static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
+static long qhimark = 10000;	/* If this many pending, ignore blimit. */
+static long qlowmark = 100;	/* Once only this many pending, use blimit. */
 
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
+module_param(blimit, long, 0);
+module_param(qhimark, long, 0);
+module_param(qlowmark, long, 0);
 
 int rcu_cpu_stall_suppress __read_mostly; /* 1 = suppress stall warnings. */
 int rcu_cpu_stall_timeout __read_mostly = CONFIG_RCU_CPU_STALL_TIMEOUT;
@@ -1533,7 +1533,8 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 	struct rcu_head *next, *list, **tail;
-	int bl, count, count_lazy, i;
+	long bl, count, count_lazy;
+	int i;
 
 	/* If no callbacks are ready, just return.*/
 	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
-- 
1.7.9.5

