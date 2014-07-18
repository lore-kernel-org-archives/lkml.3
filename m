Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800AbaGRE1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:27:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33330 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaGRE1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:27:38 -0400
Date: Thu, 17 Jul 2014 21:26:44 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-2afd2bcfc3a026d6e4c2184bf41ccd74eb05758b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405332185-4050-34-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-34-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Add 'immediate' option
Git-Commit-ID: 2afd2bcfc3a026d6e4c2184bf41ccd74eb05758b
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

Commit-ID:  2afd2bcfc3a026d6e4c2184bf41ccd74eb05758b
Gitweb:     http://git.kernel.org/tip/2afd2bcfc3a026d6e4c2184bf41ccd74eb05758b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:57 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:37 -0300

perf evsel: Add 'immediate' option

Add an option to cause a selected event to be enabled immediately when
configured by perf_evsel__config().

This is needed when using the sched_switch tracepoint to follow object
code execution.  By having sched_switch enabled immediately the first
sched_switch event precedes the start of other tracing.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-34-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 5 +++++
 tools/perf/util/evsel.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 40626e5..90f58cd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -681,6 +681,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (target__none(&opts->target) && perf_evsel__is_group_leader(evsel) &&
 		!opts->initial_delay)
 		attr->enable_on_exec = 1;
+
+	if (evsel->immediate) {
+		attr->disabled = 0;
+		attr->enable_on_exec = 0;
+	}
 }
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8dfec05..d7f93ce 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -84,6 +84,7 @@ struct perf_evsel {
 	bool 			supported;
 	bool 			needs_swap;
 	bool			no_aux_samples;
+	bool			immediate;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
