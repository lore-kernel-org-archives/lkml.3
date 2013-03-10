Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab3CJSl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab3CJSlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:41:51 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/6] perf: Fix hw breakpoints overflow period sampling
Date: Sun, 10 Mar 2013 19:41:09 +0100
Message-Id: <1362940871-24486-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hw breakpoint pmu 'add' function is missing the
period_left update needed for SW events.

The perf HW breakpoint events use SW events framework
for to process the overflow, so it needs to be properly
initialized during PMU 'add' method.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h    | 2 ++
 kernel/events/core.c          | 2 +-
 kernel/events/hw_breakpoint.c | 5 +++++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8737e1c..24befdf 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -738,6 +738,7 @@ extern unsigned int perf_output_skip(struct perf_output_handle *handle,
 				     unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
+extern u64 perf_swevent_set_period(struct perf_event *event);
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
@@ -777,6 +778,7 @@ static inline void perf_event_fork(struct task_struct *tsk)		{ }
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
+static inline u64 perf_swevent_set_period(struct perf_event *event)	{ return 0; }
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5976a2a..bd076b8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4972,7 +4972,7 @@ static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
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
 
-- 
1.7.11.7

