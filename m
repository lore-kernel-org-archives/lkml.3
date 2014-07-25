Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbaGYO5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933324AbaGYO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:57:11 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 15/19] perf tools: Add report.queue-size config file option
Date: Fri, 25 Jul 2014 16:56:13 +0200
Message-Id: <1406300177-31805-16-git-send-email-jolsa@kernel.org>
In-Reply-To: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
References: <1406300177-31805-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding report.queue-size config file option to setup
the maximum allocation size for session's struct
ordered_events_queue object.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-report.c      | 13 ++++++++++++-
 tools/perf/util/ordered-events.h |  6 ++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c72cc5a12144..ff6ab6184745 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -58,17 +58,19 @@ struct report {
 	const char		*symbol_filter_str;
 	float			min_percent;
 	u64			nr_entries;
+	u64			queue_size;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
 static int report__config(const char *var, const char *value, void *cb)
 {
+	struct report *rep = cb;
+
 	if (!strcmp(var, "report.group")) {
 		symbol_conf.event_group = perf_config_bool(var, value);
 		return 0;
 	}
 	if (!strcmp(var, "report.percent-limit")) {
-		struct report *rep = cb;
 		rep->min_percent = strtof(value, NULL);
 		return 0;
 	}
@@ -76,6 +78,10 @@ static int report__config(const char *var, const char *value, void *cb)
 		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
 		return 0;
 	}
+	if (!strcmp(var, "report.queue-size")) {
+		rep->queue_size = perf_config_u64(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
@@ -714,6 +720,11 @@ repeat:
 	if (session == NULL)
 		return -ENOMEM;
 
+	if (report.queue_size) {
+		ordered_events_alloc_size(&session->ordered_events,
+					  report.queue_size);
+	}
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index de40a8bb6466..a4fc435f0fc6 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -40,4 +40,10 @@ int ordered_events_flush(struct perf_session *s, struct perf_tool *tool,
 			 enum oe_flush how);
 void ordered_events_init(struct ordered_events *oe);
 void ordered_events_free(struct ordered_events *oe);
+
+static inline void
+ordered_events_alloc_size(struct ordered_events *oe, u64 size)
+{
+	oe->max_alloc_size = size;
+}
 #endif /* __ORDERED_EVENTS_H */
-- 
1.8.3.1

