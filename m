Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab3HOH43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:56:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab3HOH40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:56:26 -0400
Date: Thu, 15 Aug 2013 00:55:54 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-b0b35f0179161a5e256eebffa274b0b6f023f451@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-11-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-11-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Add option to print stack trace on single line
Git-Commit-ID: b0b35f0179161a5e256eebffa274b0b6f023f451
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:56:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0b35f0179161a5e256eebffa274b0b6f023f451
Gitweb:     http://git.kernel.org/tip/b0b35f0179161a5e256eebffa274b0b6f023f451
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:52 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:08 -0300

perf evsel: Add option to print stack trace on single line

Option is used by upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-11-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 8 ++++++--
 tools/perf/util/session.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e5fd658..0d895e7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1497,6 +1497,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	int print_sym = print_opts & PRINT_IP_OPT_SYM;
 	int print_dso = print_opts & PRINT_IP_OPT_DSO;
 	int print_symoffset = print_opts & PRINT_IP_OPT_SYMOFFSET;
+	int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
+	char s = print_oneline ? ' ' : '\t';
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  NULL) < 0) {
@@ -1521,7 +1523,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				break;
 
 			if (print_ip)
-				printf("%16" PRIx64, node->ip);
+				printf("%c%16" PRIx64, s, node->ip);
 
 			if (print_sym) {
 				printf(" ");
@@ -1537,7 +1539,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				map__fprintf_dsoname(node->map, stdout);
 				printf(")");
 			}
-			printf("\n");
+
+			if (!print_oneline)
+				printf("\n");
 
 			callchain_cursor_advance(&callchain_cursor);
 		}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 69e554a..7c00ccb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -45,6 +45,7 @@ struct perf_session {
 #define PRINT_IP_OPT_SYM		(1<<1)
 #define PRINT_IP_OPT_DSO		(1<<2)
 #define PRINT_IP_OPT_SYMOFFSET	(1<<3)
+#define PRINT_IP_OPT_ONELINE	(1<<4)
 
 struct perf_tool;
 
