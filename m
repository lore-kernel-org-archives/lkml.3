Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBJPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:39:37 -0500
Received: from hofr.at ([212.69.189.236]:43867 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaBJPjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:39:35 -0500
Date: Mon, 10 Feb 2014 16:39:33 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: linux-rt-users@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: [PATCH RT 4/5] allow preemption in
	mem_cgroup_move_account_page_stat
Message-ID: <20140210153933.GE20017@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


allow preemption in mem_cgroup_move_account_page_stat

as the call sites of mem_cgroup_move_account_page_stat are under 
move_lock_mem_cgroup move_unlock_mem_cgroup (spin_lock_irqsave/
spin_unlock_irqrestore respectively) the move operations 
preempt_disable/enable seem to be purely for migration protection so 
a migrate_disable/enable should be fine here.

patch on top of 3.12.10-rt15

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 mm/memcontrol.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a67e630f..e7cc35a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3784,10 +3784,10 @@ void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
 					enum mem_cgroup_stat_index idx)
 {
 	/* Update stat data for mem_cgroup */
-	preempt_disable();
+	migrate_disable();
 	__this_cpu_sub(from->stat->count[idx], nr_pages);
 	__this_cpu_add(to->stat->count[idx], nr_pages);
-	preempt_enable();
+	migrate_enable();
 }
 
 /**
-- 
1.7.2.5

