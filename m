Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbaHVQbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:31:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:33838 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932732AbaHVQae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:34 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/16] perf: Add PERF_EVENT_STATE_EXIT state for events with exited task
Date: Fri, 22 Aug 2014 13:29:25 -0300
Message-Id: <1408724968-3441-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding new perf event state to indicate that the monitored task has
exited.  In this case the event stays alive until the owner task exits
or close the event fd while providing the last data through the read
syscall and ring buffer.

Instead it needs to propagate the error info (monitored task has died)
via poll and read  syscalls by  returning POLLHUP and 0 respectively.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140811120102.GY9918@twins.programming.kicks-ass.net
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-t5y3w8jjx6tfo5w8y6oajsjq@git.kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f0a1036b1911..893a0d07986f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -269,6 +269,7 @@ struct pmu {
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
+	PERF_EVENT_STATE_EXIT		= -3,
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4575dd6e59ea..d8cb4d21a346 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3600,7 +3600,8 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
 	 * error state (i.e. because it was pinned but it couldn't be
 	 * scheduled on to the CPU at some point).
 	 */
-	if (event->state == PERF_EVENT_STATE_ERROR)
+	if ((event->state == PERF_EVENT_STATE_ERROR) ||
+	    (event->state == PERF_EVENT_STATE_EXIT))
 		return 0;
 
 	if (count < event->read_size)
@@ -3630,6 +3631,10 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	unsigned int events = POLLHUP;
 
 	poll_wait(file, &event->waitq, wait);
+
+	if (event->state == PERF_EVENT_STATE_EXIT)
+		return events;
+
 	/*
 	 * Pin the event->rb by taking event->mmap_mutex; otherwise
 	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
@@ -7588,6 +7593,9 @@ __perf_event_exit_task(struct perf_event *child_event,
 	if (child_event->parent) {
 		sync_child_event(child_event, child);
 		free_event(child_event);
+	} else {
+		child_event->state = PERF_EVENT_STATE_EXIT;
+		perf_event_wakeup(child_event);
 	}
 }
 
-- 
1.9.3

