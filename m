Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab3LDPmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:42:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3LDPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:57 -0500
Date: Wed, 4 Dec 2013 07:41:21 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-14rpuci11l2s0o01yta87kxe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, stfomichev@yandex-team.ru, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, stfomichev@yandex-team.ru, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Move wake_events list to '
 struct timechart'
Git-Commit-ID: 436b0da02fc12970f2f5ecdef03160c7a401b121
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:41:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  436b0da02fc12970f2f5ecdef03160c7a401b121
Gitweb:     http://git.kernel.org/tip/436b0da02fc12970f2f5ecdef03160c7a401b121
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 28 Nov 2013 13:26:33 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:22:47 -0300

perf timechart: Move wake_events list to 'struct timechart'

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
index 8ee0ff1..0bda620 100644
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
