Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab3FTQTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:19:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3FTQTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:19:15 -0400
Date: Thu, 20 Jun 2013 09:18:55 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-e1ebe86203e6532eb5a0ae8f26ccae47aca548ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, vincent.weaver@maine.edu, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20130620155011.GA6330@redhat.com>
References: <20130620155011.GA6330@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoint: Simplify list/
 idx mess in toggle_bp_slot() paths
Git-Commit-ID: e1ebe86203e6532eb5a0ae8f26ccae47aca548ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 09:19:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1ebe86203e6532eb5a0ae8f26ccae47aca548ae
Gitweb:     http://git.kernel.org/tip/e1ebe86203e6532eb5a0ae8f26ccae47aca548ae
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 20 Jun 2013 17:50:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 17:58:55 +0200

hw_breakpoint: Simplify list/idx mess in toggle_bp_slot() paths

The enable/disable logic in toggle_bp_slot() is not symmetrical
and imho very confusing. "old_count" in toggle_bp_task_slot() is
actually new_count because this bp was already removed from the
list.

Change toggle_bp_slot() to always call list_add/list_del after
toggle_bp_task_slot(). This way old_idx is task_bp_pinned() and
this entry should be decremented, new_idx is +/-weight and we
need to increment this element. The code/logic looks obvious.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20130620155011.GA6330@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index ef8ebe5..dee0148 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -185,26 +185,20 @@ fetch_this_slot(struct bp_busy_slots *slots, int weight)
 static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 				enum bp_type_idx type, int weight)
 {
-	unsigned int *tsk_pinned;
-	int old_count = 0;
-	int old_idx = 0;
-	int idx = 0;
-
-	old_count = task_bp_pinned(cpu, bp, type);
-	old_idx = old_count - 1;
-	idx = old_idx + weight;
-
-	/* tsk_pinned[n] is the number of tasks having n breakpoints */
-	tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
-	if (enable) {
-		tsk_pinned[idx]++;
-		if (old_count > 0)
-			tsk_pinned[old_idx]--;
-	} else {
-		tsk_pinned[idx]--;
-		if (old_count > 0)
-			tsk_pinned[old_idx]++;
-	}
+	/* tsk_pinned[n-1] is the number of tasks having n>0 breakpoints */
+	unsigned int *tsk_pinned = per_cpu(nr_task_bp_pinned[type], cpu);
+	int old_idx, new_idx;
+
+	old_idx = task_bp_pinned(cpu, bp, type) - 1;
+	if (enable)
+		new_idx = old_idx + weight;
+	else
+		new_idx = old_idx - weight;
+
+	if (old_idx >= 0)
+		tsk_pinned[old_idx]--;
+	if (new_idx >= 0)
+		tsk_pinned[new_idx]++;
 }
 
 /*
@@ -228,10 +222,6 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	}
 
 	/* Pinned counter task profiling */
-
-	if (!enable)
-		list_del(&bp->hw.bp_list);
-
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
@@ -241,6 +231,8 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 
 	if (enable)
 		list_add_tail(&bp->hw.bp_list, &bp_task_head);
+	else
+		list_del(&bp->hw.bp_list);
 }
 
 /*
