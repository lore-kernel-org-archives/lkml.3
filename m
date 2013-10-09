Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3JIS5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab3JIS5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:57:52 -0400
Date: Wed, 9 Oct 2013 20:50:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] rcusync: make rcu_sync_enter() return "bool"
Message-ID: <20131009185041.GA19287@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009185023.GA19264@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change rcu_sync_enter() to return "need_sync" to let the caller
know whether we did the FAST -> SLOW transition or not.

This is particularly useful in exclusive mode, for example
percpu_down_write() can avoid clear_fast_ctr() if rcu_sync_enter()
returns F.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/rcusync.h |    2 +-
 kernel/rcusync.c        |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index aaea86a..8430921 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -31,7 +31,7 @@ static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 
 extern void rcu_sync_init(struct rcu_sync_struct *,
 				enum rcu_sync_type, bool excl);
-extern void rcu_sync_enter(struct rcu_sync_struct *);
+extern bool rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
 extern void rcu_sync_dtor(struct rcu_sync_struct *);
 
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index 03ddc61..21a6695 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -59,7 +59,7 @@ void rcu_sync_init(struct rcu_sync_struct *rss,
 	rss->gp_type = type;
 }
 
-void rcu_sync_enter(struct rcu_sync_struct *rss)
+bool rcu_sync_enter(struct rcu_sync_struct *rss)
 {
 	bool need_wait, need_sync;
 
@@ -90,6 +90,8 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
 		 */
 		BUG_ON(rss->gp_state != GP_PASSED);
 	}
+
+	return need_sync;
 }
 
 static void rcu_sync_func(struct rcu_head *rcu)
-- 
1.5.5.1

