Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116Ab3HHCxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:53:50 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61053 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925Ab3HHCvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:42 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/19] perf tool: Skip symbols in exclude list while printing callchain
Date: Wed,  7 Aug 2013 22:50:55 -0400
Message-Id: <1375930261-77273-14-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leverage new exclude symbol list to allow user to not see certain functions
in a backtrace. For example repeating patterns like:
    do_select  core_sys_select  sys_select
can be reduced to just sys_select when dumping callchains, consuming less
real estate on the screen while still conveying the essential message - the
process is in a select call.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5a89964..0eada12 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1522,6 +1522,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!node)
 				break;
 
+			if (symbol__is_excluded(node->sym))
+				goto next;
+
 			if (print_ip)
 				printf("%c%16" PRIx64, s, node->ip);
 
@@ -1543,9 +1546,10 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (!print_oneline)
 				printf("\n");
 
-			callchain_cursor_advance(&callchain_cursor);
-
 			stack_depth--;
+
+next:
+			callchain_cursor_advance(&callchain_cursor);
 		}
 
 	} else {
-- 
1.7.10.1

