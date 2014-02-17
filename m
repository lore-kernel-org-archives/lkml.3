Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaBQVi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:38:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52898 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbaBQVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:10 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH tip/core/rcu 10/12] block: Substitute rcu_access_pointer() for rcu_dereference_raw()
Date: Mon, 17 Feb 2014 13:35:57 -0800
Message-Id: <1392672959-6386-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-6688-0000-0000-000006AE6F04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

(Trivial patch.)

If the code is looking at the RCU-protected pointer itself, but not
dereferencing it, the rcu_dereference() functions can be downgraded to
rcu_access_pointer().  This commit makes this downgrade in blkg_destroy()
and ioc_destroy_icq(), both of which simply compare the RCU-protected
pointer against another pointer with no dereferencing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-cgroup.c | 2 +-
 block/blk-ioc.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4e491d9b5292..b6e95b5e262f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -336,7 +336,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	 * under queue_lock.  If it's not pointing to @blkg now, it never
 	 * will.  Hint assignment itself can race safely.
 	 */
-	if (rcu_dereference_raw(blkcg->blkg_hint) == blkg)
+	if (rcu_access_pointer(blkcg->blkg_hint) == blkg)
 		rcu_assign_pointer(blkcg->blkg_hint, NULL);
 
 	/*
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 242df01413f6..1a27f45ec776 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -68,7 +68,7 @@ static void ioc_destroy_icq(struct io_cq *icq)
 	 * under queue_lock.  If it's not pointing to @icq now, it never
 	 * will.  Hint assignment itself can race safely.
 	 */
-	if (rcu_dereference_raw(ioc->icq_hint) == icq)
+	if (rcu_access_pointer(ioc->icq_hint) == icq)
 		rcu_assign_pointer(ioc->icq_hint, NULL);
 
 	ioc_exit_icq(icq);
-- 
1.8.1.5

