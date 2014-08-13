Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaHMFQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:16:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44968 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHMFQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:16:55 -0400
Date: Tue, 12 Aug 2014 22:16:37 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-lm42mbpu0cwljpyy8vw5y26n@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add report.queue-size config file option
Git-Commit-ID: 94786b67b5f4577c16486e8eb10ff045e59f80ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94786b67b5f4577c16486e8eb10ff045e59f80ef
Gitweb:     http://git.kernel.org/tip/94786b67b5f4577c16486e8eb10ff045e59f80ef
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 5 Jun 2014 11:00:20 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:01 -0300

perf tools: Add report.queue-size config file option

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
index c72cc5a..041e93d 100644
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
index 6036bd6..2ce847f 100644
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
