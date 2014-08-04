Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaHDQUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:20:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:39313 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaHDQUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/33] perf tools: Add report.queue-size config file option
Date: Mon,  4 Aug 2014 13:17:30 -0300
Message-Id: <1407169064-25625-20-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding report.queue-size config file option to setup the maximum
allocation size for session's struct ordered_events object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-lm42mbpu0cwljpyy8vw5y26n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c      | 13 ++++++++++++-
 tools/perf/util/ordered-events.h |  6 ++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c72cc5a12144..041e93da13e4 100644
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
+		ordered_events__set_alloc_size(&session->ordered_events,
+					       report.queue_size);
+	}
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 6036bd657073..2ce847fb48a5 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -40,4 +40,10 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
 void ordered_events__init(struct ordered_events *oe);
 void ordered_events__free(struct ordered_events *oe);
+
+static inline
+void ordered_events__set_alloc_size(struct ordered_events *oe, u64 size)
+{
+	oe->max_alloc_size = size;
+}
 #endif /* __ORDERED_EVENTS_H */
-- 
1.9.3

