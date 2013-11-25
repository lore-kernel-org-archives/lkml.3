Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3KYOUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:20:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975Ab3KYOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:18:10 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/25] perf evsel: Skip ignored symbols while printing callchain
Date: Mon, 25 Nov 2013 11:17:51 -0300
Message-Id: <1385389075-7989-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385389075-7989-1-git-send-email-acme@infradead.org>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Allows a command to have a symbol_filter controlled by the user to skip
certain functions in a backtrace. One example is to allow the user to
reduce repeating patterns like:

    do_select  core_sys_select  sys_select

to just sys_select when dumping callchains, consuming less real estate
on the screen while still conveying the essential message - the process
is in a select call.

This option is leveraged by the upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1384806771-2945-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f36d24a02445..948f7644b4d9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1522,6 +1522,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!node)
 				break;
 
+			if (node->sym && node->sym->ignore)
+				goto next;
+
 			if (print_ip)
 				printf("%c%16" PRIx64, s, node->ip);
 
@@ -1544,12 +1547,15 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!print_oneline)
 				printf("\n");
 
-			callchain_cursor_advance(&callchain_cursor);
-
 			stack_depth--;
+next:
+			callchain_cursor_advance(&callchain_cursor);
 		}
 
 	} else {
+		if (al.sym->ignore)
+			return;
+
 		if (print_ip)
 			printf("%16" PRIx64, sample->ip);
 
-- 
1.8.1.4

