Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaIXO72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:59:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaIXO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:59:22 -0400
Date: Wed, 24 Sep 2014 07:58:15 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-dc633982ff3f4fd74cdc11b5a6ae53d39a0b2451@git.kernel.org>
Cc: eranian@google.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, paulus@samba.org, eranian@google.com,
        jolsa@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
References: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Do not POLLHUP event if it has children
Git-Commit-ID: dc633982ff3f4fd74cdc11b5a6ae53d39a0b2451
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

Commit-ID:  dc633982ff3f4fd74cdc11b5a6ae53d39a0b2451
Gitweb:     http://git.kernel.org/tip/dc633982ff3f4fd74cdc11b5a6ae53d39a0b2451
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 12 Sep 2014 13:18:26 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:11 +0200

perf: Do not POLLHUP event if it has children

Currently we return POLLHUP in event polling if the monitored
process is done, but we didn't consider possible children,
that might be still running and producing data.

Before returning POLLHUP making sure that:

   1) the monitored task has exited and that
   2) we don't have any children to monitor

Also adding parent wakeup when the child event is gone.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1410520708-19275-1-git-send-email-jolsa@kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 733c616..15e58d4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3587,6 +3587,19 @@ static int perf_event_read_one(struct perf_event *event,
 	return n * sizeof(u64);
 }
 
+static bool is_event_hup(struct perf_event *event)
+{
+	bool no_children;
+
+	if (event->state != PERF_EVENT_STATE_EXIT)
+		return false;
+
+	mutex_lock(&event->child_mutex);
+	no_children = list_empty(&event->child_list);
+	mutex_unlock(&event->child_mutex);
+	return no_children;
+}
+
 /*
  * Read the performance event - simple non blocking version for now
  */
@@ -3632,7 +3645,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &event->waitq, wait);
 
-	if (event->state == PERF_EVENT_STATE_EXIT)
+	if (is_event_hup(event))
 		return events;
 
 	/*
@@ -7580,6 +7593,12 @@ static void sync_child_event(struct perf_event *child_event,
 	mutex_unlock(&parent_event->child_mutex);
 
 	/*
+	 * Make sure user/parent get notified, that we just
+	 * lost one event.
+	 */
+	perf_event_wakeup(parent_event);
+
+	/*
 	 * Release the parent event, if this was the last
 	 * reference to it.
 	 */
