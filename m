Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbaGREYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:24:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33106 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaGREYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:24:40 -0400
Date: Thu, 17 Jul 2014 21:23:41 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-39e09d40bea440d9cfe645b55aff251294318669@git.kernel.org>
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
In-Reply-To: <1405332185-4050-5-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Select comm_exec flag if supported
Git-Commit-ID: 39e09d40bea440d9cfe645b55aff251294318669
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

Commit-ID:  39e09d40bea440d9cfe645b55aff251294318669
Gitweb:     http://git.kernel.org/tip/39e09d40bea440d9cfe645b55aff251294318669
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Jul 2014 13:02:28 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Jul 2014 17:57:34 -0300

perf record: Select comm_exec flag if supported

The comm_exec flag on the attribute can later be found in the perf.data
file allowing a tool to know in advance if the captured data has the
flag.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/record.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 049e0a0..1657231 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -69,15 +69,26 @@ static void perf_probe_sample_identifier(struct perf_evsel *evsel)
 	evsel->attr.sample_type |= PERF_SAMPLE_IDENTIFIER;
 }
 
+static void perf_probe_comm_exec(struct perf_evsel *evsel)
+{
+	evsel->attr.comm_exec = 1;
+}
+
 bool perf_can_sample_identifier(void)
 {
 	return perf_probe_api(perf_probe_sample_identifier);
 }
 
+static bool perf_can_comm_exec(void)
+{
+	return perf_probe_api(perf_probe_comm_exec);
+}
+
 void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 {
 	struct perf_evsel *evsel;
 	bool use_sample_identifier = false;
+	bool use_comm_exec;
 
 	/*
 	 * Set the evsel leader links before we configure attributes,
@@ -89,8 +100,13 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	evlist__for_each(evlist, evsel)
+	use_comm_exec = perf_can_comm_exec();
+
+	evlist__for_each(evlist, evsel) {
 		perf_evsel__config(evsel, opts);
+		if (!evsel->idx && use_comm_exec)
+			evsel->attr.comm_exec = 1;
+	}
 
 	if (evlist->nr_entries > 1) {
 		struct perf_evsel *first = perf_evlist__first(evlist);
