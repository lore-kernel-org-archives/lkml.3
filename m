Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066AbaKMTZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:30 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:46407 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbaKMTZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:24 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org (open list:PERFORMANCE EVENT...)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 10/16] perf: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:16 -0500
Message-Id: <1415906662-4576-11-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/events/core.c    | 3 +--
 kernel/events/uprobes.c | 8 ++++----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d59fdc0..9dd5920 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3400,14 +3400,13 @@ static void perf_remove_from_owner(struct perf_event *event)
 	struct task_struct *owner;
 
 	rcu_read_lock();
-	owner = ACCESS_ONCE(event->owner);
 	/*
 	 * Matches the smp_wmb() in perf_event_exit_task(). If we observe
 	 * !owner it means the list deletion is complete and we can indeed
 	 * free this event, otherwise we need to serialize on
 	 * owner->perf_event_mutex.
 	 */
-	smp_read_barrier_depends();
+	owner = lockless_dereference(event->owner);
 	if (owner) {
 		/*
 		 * Since delayed_put_task_struct() also drops the last
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6158a64b..c070949 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1212,8 +1212,8 @@ static struct xol_area *get_xol_area(void)
 	if (!mm->uprobes_state.xol_area)
 		__create_xol_area(0);
 
-	area = mm->uprobes_state.xol_area;
-	smp_read_barrier_depends();	/* pairs with wmb in xol_add_vma() */
+	/* pairs with wmb in xol_add_vma() */
+	area = lockless_dereference(mm->uprobes_state.xol_area);
 	return area;
 }
 
@@ -1507,8 +1507,8 @@ static unsigned long get_trampoline_vaddr(void)
 	struct xol_area *area;
 	unsigned long trampoline_vaddr = -1;
 
-	area = current->mm->uprobes_state.xol_area;
-	smp_read_barrier_depends();
+	area = lockless_dereference(current->mm->uprobes_state.xol_area);
+
 	if (area)
 		trampoline_vaddr = area->vaddr;
 
-- 
1.9.1

