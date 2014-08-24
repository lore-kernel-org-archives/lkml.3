Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaHXPBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:01:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaHXPBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:01:35 -0400
Date: Sun, 24 Aug 2014 07:59:42 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-t5y3w8jjx6tfo5w8y6oajsjq@git.kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jean.pihet@linaro.org,
        acme@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jean.pihet@linaro.org,
        acme@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, namhyung@kernel.org,
        adrian.hunter@intel.com
In-Reply-To: <20140811120102.GY9918@twins.programming.kicks-ass.net>
References: <20140811120102.GY9918@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add PERF_EVENT_STATE_EXIT state for events with exited task
Git-Commit-ID: 179033b3e064d2cd3f5f9945e76b0a0f0fbf4883
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

Commit-ID:  179033b3e064d2cd3f5f9945e76b0a0f0fbf4883
Gitweb:     http://git.kernel.org/tip/179033b3e064d2cd3f5f9945e76b0a0f0fbf4883
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 7 Aug 2014 11:48:26 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 24 Aug 2014 08:11:09 -0300

perf: Add PERF_EVENT_STATE_EXIT state for events with exited task

Adding new perf event state to indicate that the monitored task has
exited.  In this case the event stays alive until the owner task exits
or close the event fd while providing the last data through the read
syscall and ring buffer.

Instead it needs to propagate the error info (monitored task has died)
via poll and read  syscalls by  returning POLLHUP and 0 respectively.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h |  1 +
 kernel/events/core.c       | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f0a1036..893a0d0 100644
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
index 4575dd6..d8cb4d2 100644
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
 
