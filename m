Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3KRUdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:20 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50558 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3KRUdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:00 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/8] perf tool: Skip ignored symbols while printing callchain
Date: Mon, 18 Nov 2013 13:32:44 -0700
Message-Id: <1384806771-2945-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows a command to have a symbol_filter controlled by the user to skip
certain functions in a backtrace. One example is to allow the user to reduce
repeating patterns like:
    do_select  core_sys_select  sys_select

to just sys_select when dumping callchains, consuming less real estate on
the screen while still conveying the essential message - the process is in
a select call.

This option is leveraged by the upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
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
1.8.3.4 (Apple Git-47)

