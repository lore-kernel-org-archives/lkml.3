Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab3JOFas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:30:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOFao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:30:44 -0400
Date: Mon, 14 Oct 2013 22:30:17 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-4bbe5a61f29b13437a6a16467328d3bae8fce9e7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380400080-9211-4-git-send-email-dsahern@gmail.com>
References: <1380400080-9211-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add units to nanosec-based counters
Git-Commit-ID: 4bbe5a61f29b13437a6a16467328d3bae8fce9e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:30:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bbe5a61f29b13437a6a16467328d3bae8fce9e7
Gitweb:     http://git.kernel.org/tip/4bbe5a61f29b13437a6a16467328d3bae8fce9e7
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 28 Sep 2013 14:28:00 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:46 -0300

perf stat: Add units to nanosec-based counters

Ingo pointed out that the task-clock counter should have the units
explicitly stated since it is not a counter.

Before:

perf stat -a -- sleep 1

 Performance counter stats for 'sleep 1':

      16186.874834 task-clock          #   16.154 CPUs utilized
...

After:

perf stat -a -- sleep 1

 Performance counter stats for 'system wide':

      16146.402138 task-clock (msec)   #   16.125 CPUs utilized
...

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380400080-9211-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2178e66..1a9c95d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -706,10 +706,13 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	const char *fmt = csv_output ? "%.6f%s%s" : "%18.6f%s%-25s";
+	char name[25];
 
 	aggr_printout(evsel, cpu, nr);
 
-	fprintf(output, fmt, msecs, csv_sep, perf_evsel__name(evsel));
+	scnprintf(name, sizeof(name), "%s%s",
+		  perf_evsel__name(evsel), csv_output ? "" : " (msec)");
+	fprintf(output, fmt, msecs, csv_sep, name);
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
