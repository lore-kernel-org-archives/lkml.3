Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbaJXW6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:58:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64061 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbaJXW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:58:42 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 6/8] perf: Pass the event to arch_perf_update_userpage
Date: Fri, 24 Oct 2014 15:58:11 -0700
Message-Id: <0fea9a7fac3c1eea86cb0a5954184e74f4213666.1414190806.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
In-Reply-To: <cover.1414190806.git.luto@amacapital.net>
References: <cover.1414190806.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/cpu/perf_event.c | 3 ++-
 kernel/events/core.c             | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2176647fdbb7..00fbab7aa587 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1923,7 +1923,8 @@ static struct pmu pmu = {
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
-void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
+void arch_perf_update_userpage(struct perf_event *event,
+			       struct perf_event_mmap_page *userpg, u64 now)
 {
 	struct cyc2ns_data *data;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3b1ec69d189f..e366f98a94d5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3947,7 +3947,8 @@ unlock:
 	rcu_read_unlock();
 }
 
-void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
+void __weak arch_perf_update_userpage(
+	struct perf_event *event, struct perf_event_mmap_page *userpg, u64 now)
 {
 }
 
@@ -3997,7 +3998,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	userpg->time_running = running +
 			atomic64_read(&event->child_total_time_running);
 
-	arch_perf_update_userpage(userpg, now);
+	arch_perf_update_userpage(event, userpg, now);
 
 	barrier();
 	++userpg->lock;
-- 
1.9.3

