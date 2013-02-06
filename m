Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3BFWQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:16:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab3BFWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:16:46 -0500
Date: Wed, 6 Feb 2013 14:16:18 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-izjubje7ltd1srji5wb0ygwi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Pass the event_group info via perf_attr_details
Git-Commit-ID: e35ef355ad3dd26bff79c8711f070ac69501dfa3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:16:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e35ef355ad3dd26bff79c8711f070ac69501dfa3
Gitweb:     http://git.kernel.org/tip/e35ef355ad3dd26bff79c8711f070ac69501dfa3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 6 Feb 2013 17:20:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:28 -0300

perf evlist: Pass the event_group info via perf_attr_details

So that we avoid dragging symbol.o into the python binding.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-izjubje7ltd1srji5wb0ygwi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c | 4 ++--
 tools/perf/util/evsel.c     | 2 +-
 tools/perf/util/evsel.h     | 1 +
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 85a5e35..05bd9df 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -39,7 +39,7 @@ int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN('F', "freq", &details.freq, "Show the sample frequency"),
 	OPT_BOOLEAN('v', "verbose", &details.verbose,
 		    "Show all event attr details"),
-	OPT_BOOLEAN('g', "group", &symbol_conf.event_group,
+	OPT_BOOLEAN('g', "group", &details.event_group,
 		    "Show event group information"),
 	OPT_END()
 	};
@@ -52,7 +52,7 @@ int cmd_evlist(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (argc)
 		usage_with_options(evlist_usage, options);
 
-	if (symbol_conf.event_group && (details.verbose || details.freq)) {
+	if (details.event_group && (details.verbose || details.freq)) {
 		pr_err("--group option is not compatible with other options\n");
 		usage_with_options(evlist_usage, options);
 	}
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index a547015..9c82f98f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1391,7 +1391,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 	bool first = true;
 	int printed = 0;
 
-	if (symbol_conf.event_group) {
+	if (details->event_group) {
 		struct perf_evsel *pos;
 
 		if (!perf_evsel__is_group_leader(evsel))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 8512f6a..52021c3 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -254,6 +254,7 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
+	bool event_group;
 };
 
 int perf_evsel__fprintf(struct perf_evsel *evsel,
