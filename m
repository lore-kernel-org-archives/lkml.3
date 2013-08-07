Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab3HGKVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:21:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932455Ab3HGKVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143910"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 7/8] rcu: add # of deferred _special() statistics
Date: Wed, 7 Aug 2013 18:25:03 +0800
Message-Id: <1375871104-10688-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize complete at 2013/08/07 18:19:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |    1 +
 kernel/rcutree_trace.c  |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 4a39d36..a5e9643 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -290,6 +290,7 @@ struct rcu_data {
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
 	long		blimit;		/* Upper limit on a processed batch */
+	unsigned long	n_defer_special;/* # of deferred _special() */
 
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c9ff9f1..d828eec 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -396,6 +396,7 @@ void rcu_read_unlock_special(struct task_struct *t, bool unlock)
 		 * is still unlikey to be true.
 		 */
 		if (unlikely(unlock && irqs_disabled_flags(flags))) {
+			this_cpu_ptr(&rcu_preempt_data)->n_defer_special++;
 			set_need_resched();
 			local_irq_restore(flags);
 			return;
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index cf6c174..17d8b2c 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -149,6 +149,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 	seq_printf(m, " ci=%lu nci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_nocbs_invoked,
 		   rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
+	seq_printf(m, " ds=%lu\n", rdp->n_defer_special);
 }
 
 static int show_rcudata(struct seq_file *m, void *v)
-- 
1.7.4.4

