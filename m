Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab3HOH4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:56:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3HOH4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:56:37 -0400
Date: Thu, 15 Aug 2013 00:56:04 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-307cbb92aa2bdc9eed7c74409ff4d5fc9135b4e2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-12-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-12-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Add option to limit stack depth in callchain dumps
Git-Commit-ID: 307cbb92aa2bdc9eed7c74409ff4d5fc9135b4e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:56:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  307cbb92aa2bdc9eed7c74409ff4d5fc9135b4e2
Gitweb:     http://git.kernel.org/tip/307cbb92aa2bdc9eed7c74409ff4d5fc9135b4e2
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:53 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:08 -0300

perf evsel: Add option to limit stack depth in callchain dumps

Option is used by upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-12-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 6 ++++--
 tools/perf/util/session.c   | 6 ++++--
 tools/perf/util/session.h   | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ee5d6f8..33b2d83 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -402,7 +402,8 @@ static void print_sample_bts(union perf_event *event,
 		else
 			printf("\n");
 		perf_evsel__print_ip(evsel, event, sample, machine,
-				     output[attr->type].print_ip_opts);
+				     output[attr->type].print_ip_opts,
+				     PERF_MAX_STACK_DEPTH);
 	}
 
 	printf(" => ");
@@ -444,7 +445,8 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 			printf("\n");
 
 		perf_evsel__print_ip(evsel, event, sample, machine,
-				     output[attr->type].print_ip_opts);
+				     output[attr->type].print_ip_opts,
+				     PERF_MAX_STACK_DEPTH);
 	}
 
 	printf("\n");
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0d895e7..5a89964 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1489,7 +1489,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  unsigned int print_opts)
+			  unsigned int print_opts, unsigned int stack_depth)
 {
 	struct addr_location al;
 	struct callchain_cursor_node *node;
@@ -1517,7 +1517,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 		}
 		callchain_cursor_commit(&callchain_cursor);
 
-		while (1) {
+		while (stack_depth) {
 			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
 				break;
@@ -1544,6 +1544,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				printf("\n");
 
 			callchain_cursor_advance(&callchain_cursor);
+
+			stack_depth--;
 		}
 
 	} else {
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7c00ccb..3aa75fb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -109,7 +109,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  unsigned int print_opts);
+			  unsigned int print_opts, unsigned int stack_depth);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
