Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3HGKVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:21:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab3HGKVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143909"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 4/8] rcu: delay task rcu state cleanup in exit_rcu()
Date: Wed, 7 Aug 2013 18:25:00 +0800
Message-Id: <1375871104-10688-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize complete at 2013/08/07 18:19:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_rcu() tries to clean up the task rcu state when the task is exiting.
It did it by calls __rcu_read_unlock().

Actually, calling rcu_read_unlock_special() is enough. This patch defer it
to the rcu_preempt_note_context_switch() of the next schedule().

This patch prepares for the next patch which defers rcu_read_unlock_special()
if irq is disabled when __rcu_read_unlock() is called.
So __rcu_read_unlock() can't work here(it is irq-disabled here)
if the next patch applied.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutree_plugin.h |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 6b23b6f..fc8b36f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -942,10 +942,13 @@ void exit_rcu(void)
 
 	if (likely(list_empty(&current->rcu_node_entry)))
 		return;
-	t->rcu_read_lock_nesting = 1;
-	barrier();
-	t->rcu_read_unlock_special = RCU_READ_UNLOCK_BLOCKED;
-	__rcu_read_unlock();
+	WARN_ON_ONCE(!(t->rcu_read_unlock_special | RCU_READ_UNLOCK_BLOCKED));
+	/*
+	 * Task RCU state(rcu_node_entry) of this task will be cleanup by
+	 * the next rcu_preempt_note_context_switch() of the next schedule()
+	 * in the do_exit().
+	 */
+	t->rcu_read_lock_nesting = INT_MIN;
 }
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-- 
1.7.4.4

