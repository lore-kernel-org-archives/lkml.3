Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3LBUwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:52:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab3LBUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:49:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/12] perf timechart: Move wake_events list to 'struct timechart'
Date: Mon,  2 Dec 2013 17:49:06 -0300
Message-Id: <1386017349-24486-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing another global variable.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-14rpuci11l2s0o01yta87kxe@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 8ee0ff1777a8..0bda620a717d 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -43,11 +43,13 @@
 
 struct per_pid;
 struct power_event;
+struct wake_event;
 
 struct timechart {
 	struct perf_tool	tool;
 	struct per_pid		*all_data;
 	struct power_event	*power_events;
+	struct wake_event	*wake_events;
 	int			proc_num;
 	unsigned int		numcpus;
 	u64			min_freq,	/* Lowest CPU frequency seen */
@@ -148,8 +150,6 @@ struct wake_event {
 	const char *backtrace;
 };
 
-static struct wake_event     *wake_events;
-
 struct process_filter {
 	char			*name;
 	int			pid;
@@ -383,8 +383,8 @@ static void sched_wakeup(struct timechart *tchart, int cpu, u64 timestamp,
 		we->waker = -1;
 
 	we->wakee = wakee;
-	we->next = wake_events;
-	wake_events = we;
+	we->next = tchart->wake_events;
+	tchart->wake_events = we;
 	p = find_create_pid(tchart, we->wakee);
 
 	if (p && p->current && p->current->state == TYPE_NONE) {
@@ -764,7 +764,7 @@ static void draw_wakeups(struct timechart *tchart)
 	struct per_pid *p;
 	struct per_pidcomm *c;
 
-	we = wake_events;
+	we = tchart->wake_events;
 	while (we) {
 		int from = 0, to = 0;
 		char *task_from = NULL, *task_to = NULL;
-- 
1.8.1.4

