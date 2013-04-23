Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab3DWIfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:35:36 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61602 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3DWIbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:31:16 -0400
X-AuditID: 9c930197-b7bb3ae000000fa9-8b-517646d1cdc5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/14] perf util: Use evsel->name to get tracepoint_paths
Date: Tue, 23 Apr 2013 17:31:00 +0900
Message-Id: <1366705872-12132-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Most tracepoint events already have their system and event name in
->name field so that searching whole event tracing directory for each
evsel to match given id is suboptimal.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index ab18bf12d54a..dcfc1869c9af 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -414,12 +414,31 @@ get_tracepoints_path(struct list_head *pattrs)
 		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
 			continue;
 		++nr_tracepoints;
+
+		if (pos->name && strchr(pos->name, ':')) {
+			char *str = strchr(pos->name, ':');
+
+			ppath->next = zalloc(sizeof(path));
+			if (!ppath->next)
+				goto error;
+
+			ppath->next->system = strndup(pos->name, str - pos->name);
+			ppath->next->name = strdup(str+1);
+
+			if (!ppath->next->system || !ppath->next->name)
+				goto error;
+
+			goto next;
+		}
+
 		ppath->next = tracepoint_id_to_path(pos->attr.config);
 		if (!ppath->next) {
+error:
 			pr_debug("No memory to alloc tracepoints list\n");
 			put_tracepoints_path(&path);
 			return NULL;
 		}
+next:
 		ppath = ppath->next;
 	}
 
-- 
1.7.11.7

