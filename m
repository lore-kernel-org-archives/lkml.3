Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3JDSyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045Ab3JDSyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:54:02 -0400
Date: Fri, 4 Oct 2013 20:46:44 +0200
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
Subject: [PATCH 5/5] rcusync: make rcu_sync_enter() return "bool"
Message-ID: <20131004184644.GA17576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004184614.GA17536@redhat.com>
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
index 5689f24..6f4c75b 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -37,7 +37,7 @@ enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
 
 extern void rcu_sync_init(struct rcu_sync_struct *,
 				enum rcu_sync_type, bool excl);
-extern void rcu_sync_enter(struct rcu_sync_struct *);
+extern bool rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
 extern void rcu_sync_dtor(struct rcu_sync_struct *);
 
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index 667eb7d..d03d8e5 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -42,7 +42,7 @@ void rcu_sync_init(struct rcu_sync_struct *rss,
 	rss->exclusive = excl;
 }
 
-void rcu_sync_enter(struct rcu_sync_struct *rss)
+bool rcu_sync_enter(struct rcu_sync_struct *rss)
 {
 	bool need_wait, need_sync;
 
@@ -73,6 +73,8 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
 		 */
 		BUG_ON(rss->gp_state != GP_PASSED);
 	}
+
+	return need_sync;
 }
 
 static void rcu_sync_func(struct rcu_head *rcu)
-- 
1.5.5.1

