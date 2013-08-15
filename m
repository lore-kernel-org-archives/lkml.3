Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3HOH4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:56:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53880 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3HOH4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:56:16 -0400
Date: Thu, 15 Aug 2013 00:55:44 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-a6ffaf91302dc1689fc72da0068b87226747fbe0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-10-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-10-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tool:
  Simplify options to perf_evsel__print_ip
Git-Commit-ID: a6ffaf91302dc1689fc72da0068b87226747fbe0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:55:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6ffaf91302dc1689fc72da0068b87226747fbe0
Gitweb:     http://git.kernel.org/tip/a6ffaf91302dc1689fc72da0068b87226747fbe0
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:51 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:07 -0300

perf tool: Simplify options to perf_evsel__print_ip

Make print options based on flags. Simplifies addition of more print
options which is the subject of upcoming patches.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-10-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 27 +++++++++++++++++++++++----
 tools/perf/util/session.c   | 14 +++++++++++---
 tools/perf/util/session.h   |  7 ++++++-
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index cd616ff..ee5d6f8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -66,6 +66,7 @@ struct output_option {
 static struct {
 	bool user_set;
 	bool wildcard_set;
+	unsigned int print_ip_opts;
 	u64 fields;
 	u64 invalid_fields;
 } output[PERF_TYPE_MAX] = {
@@ -235,6 +236,7 @@ static int perf_session__check_output_opt(struct perf_session *session)
 {
 	int j;
 	struct perf_evsel *evsel;
+	struct perf_event_attr *attr;
 
 	for (j = 0; j < PERF_TYPE_MAX; ++j) {
 		evsel = perf_session__find_first_evtype(session, j);
@@ -253,6 +255,24 @@ static int perf_session__check_output_opt(struct perf_session *session)
 		if (evsel && output[j].fields &&
 			perf_evsel__check_attr(evsel, session))
 			return -1;
+
+		if (evsel == NULL)
+			continue;
+
+		attr = &evsel->attr;
+
+		output[j].print_ip_opts = 0;
+		if (PRINT_FIELD(IP))
+			output[j].print_ip_opts |= PRINT_IP_OPT_IP;
+
+		if (PRINT_FIELD(SYM))
+			output[j].print_ip_opts |= PRINT_IP_OPT_SYM;
+
+		if (PRINT_FIELD(DSO))
+			output[j].print_ip_opts |= PRINT_IP_OPT_DSO;
+
+		if (PRINT_FIELD(SYMOFFSET))
+			output[j].print_ip_opts |= PRINT_IP_OPT_SYMOFFSET;
 	}
 
 	return 0;
@@ -382,8 +402,7 @@ static void print_sample_bts(union perf_event *event,
 		else
 			printf("\n");
 		perf_evsel__print_ip(evsel, event, sample, machine,
-				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
-				     PRINT_FIELD(SYMOFFSET));
+				     output[attr->type].print_ip_opts);
 	}
 
 	printf(" => ");
@@ -423,9 +442,9 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 			printf(" ");
 		else
 			printf("\n");
+
 		perf_evsel__print_ip(evsel, event, sample, machine,
-				     PRINT_FIELD(SYM), PRINT_FIELD(DSO),
-				     PRINT_FIELD(SYMOFFSET));
+				     output[attr->type].print_ip_opts);
 	}
 
 	printf("\n");
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index dedaeb2..e5fd658 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1489,10 +1489,14 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  int print_sym, int print_dso, int print_symoffset)
+			  unsigned int print_opts)
 {
 	struct addr_location al;
 	struct callchain_cursor_node *node;
+	int print_ip = print_opts & PRINT_IP_OPT_IP;
+	int print_sym = print_opts & PRINT_IP_OPT_SYM;
+	int print_dso = print_opts & PRINT_IP_OPT_DSO;
+	int print_symoffset = print_opts & PRINT_IP_OPT_SYMOFFSET;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  NULL) < 0) {
@@ -1516,7 +1520,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!node)
 				break;
 
-			printf("\t%16" PRIx64, node->ip);
+			if (print_ip)
+				printf("%16" PRIx64, node->ip);
+
 			if (print_sym) {
 				printf(" ");
 				if (print_symoffset) {
@@ -1537,7 +1543,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 		}
 
 	} else {
-		printf("%16" PRIx64, sample->ip);
+		if (print_ip)
+			printf("%16" PRIx64, sample->ip);
+
 		if (print_sym) {
 			printf(" ");
 			if (print_symoffset)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8bed17e..69e554a 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -41,6 +41,11 @@ struct perf_session {
 	char			filename[1];
 };
 
+#define PRINT_IP_OPT_IP		(1<<0)
+#define PRINT_IP_OPT_SYM		(1<<1)
+#define PRINT_IP_OPT_DSO		(1<<2)
+#define PRINT_IP_OPT_SYMOFFSET	(1<<3)
+
 struct perf_tool;
 
 struct perf_session *perf_session__new(const char *filename, int mode,
@@ -103,7 +108,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  int print_sym, int print_dso, int print_symoffset);
+			  unsigned int print_opts);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
