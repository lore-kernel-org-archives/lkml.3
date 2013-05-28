Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab3E1M5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 08:57:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49991 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3E1M5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 08:57:33 -0400
Date: Tue, 28 May 2013 05:56:42 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ab573844e3058eef2788803d373019f8bebead57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, vincent.weaver@maine.edu,
        fweisbec@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, jolsa@redhat.com,
        fweisbec@gmail.com, vincent.weaver@maine.edu, oleg@redhat.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1367421944-19082-5-git-send-email-jolsa@redhat.com>
References: <1367421944-19082-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix hw breakpoints overflow period sampling
Git-Commit-ID: ab573844e3058eef2788803d373019f8bebead57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ab573844e3058eef2788803d373019f8bebead57
Gitweb:     http://git.kernel.org/tip/ab573844e3058eef2788803d373019f8bebead57
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 1 May 2013 17:25:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 08:59:54 +0200

perf: Fix hw breakpoints overflow period sampling

The hw breakpoint pmu 'add' function is missing the
period_left update needed for SW events.

The perf HW breakpoint events use the SW events framework
to process the overflow, so it needs to be properly initialized
in the PMU 'add' method.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1367421944-19082-5-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h    | 2 ++
 kernel/events/core.c          | 2 +-
 kernel/events/hw_breakpoint.c | 5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f463a46..fa38612 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -743,6 +743,7 @@ extern unsigned int perf_output_skip(struct perf_output_handle *handle,
 				     unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
+extern u64 perf_swevent_set_period(struct perf_event *event);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
@@ -782,6 +783,7 @@ static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
+static inline u64 perf_swevent_set_period(struct perf_event *event)	{ return 0; }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9dc297f..e0dcced 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4961,7 +4961,7 @@ static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
  * sign as trigger.
  */
 
-static u64 perf_swevent_set_period(struct perf_event *event)
+u64 perf_swevent_set_period(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	u64 period = hwc->last_period;
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index a64f8ae..966a241 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -612,6 +612,11 @@ static int hw_breakpoint_add(struct perf_event *bp, int flags)
 	if (!(flags & PERF_EF_START))
 		bp->hw.state = PERF_HES_STOPPED;
 
+	if (is_sampling_event(bp)) {
+		bp->hw.last_period = bp->hw.sample_period;
+		perf_swevent_set_period(bp);
+	}
+
 	return arch_install_hw_breakpoint(bp);
 }
 
