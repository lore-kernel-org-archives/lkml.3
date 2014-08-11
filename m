Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaHKIue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaHKIud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:33 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/20] perf: Add PERF_EVENT_STATE_EXIT state for events with exited task
Date: Mon, 11 Aug 2014 10:49:55 +0200
Message-Id: <1407747014-18394-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new perf event state to indicate that the monitored
task has exited.  In this case the event stays alive until
the owner task exits or close the event fd while providing
the last data through the read syscall and ring buffer.

Instead it needs to propagate the error info (monitored task
has died)  via poll and read  syscalls by  returning POLLHUP
and 0 respectively.

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
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a8c0f6..54f3a6241386 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -268,6 +268,7 @@ struct pmu {
  * enum perf_event_active_state - the states of a event
  */
 enum perf_event_active_state {
+	PERF_EVENT_STATE_EXIT		= -3,
 	PERF_EVENT_STATE_ERROR		= -2,
 	PERF_EVENT_STATE_OFF		= -1,
 	PERF_EVENT_STATE_INACTIVE	=  0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 14086e45c5c4..dde0eefa410a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3499,7 +3499,8 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
 	 * error state (i.e. because it was pinned but it couldn't be
 	 * scheduled on to the CPU at some point).
 	 */
-	if (event->state == PERF_EVENT_STATE_ERROR)
+	if ((event->state == PERF_EVENT_STATE_ERROR) ||
+	    (event->state == PERF_EVENT_STATE_EXIT))
 		return 0;
 
 	if (count < event->read_size)
@@ -3526,9 +3527,13 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
 	struct ring_buffer *rb;
-	unsigned int events = POLL_HUP;
+	unsigned int events = POLLHUP;
 
 	poll_wait(file, &event->waitq, wait);
+
+	if (event->state == PERF_EVENT_STATE_EXIT)
+		return POLLHUP;
+
 	/*
 	 * Pin the event->rb by taking event->mmap_mutex; otherwise
 	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
@@ -7484,6 +7489,9 @@ __perf_event_exit_task(struct perf_event *child_event,
 	if (child_event->parent) {
 		sync_child_event(child_event, child);
 		free_event(child_event);
+	} else {
+		child_event->state = PERF_EVENT_STATE_EXIT;
+		perf_event_wakeup(child_event);
 	}
 }
 
-- 
1.8.3.1

