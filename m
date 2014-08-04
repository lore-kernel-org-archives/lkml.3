Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaHDQTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:19:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:39123 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaHDQTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:19:38 -0400
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
Subject: [PATCH 16/33] perf tools: Add ordered_events__init function
Date: Mon,  4 Aug 2014 13:17:27 -0300
Message-Id: <1407169064-25625-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding ordered_events__init function for struct ordered_events struct
initialization.

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
Link: http://lkml.kernel.org/n/tip-g6dx35hed8g14eh1ygx4uzp6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ordered-events.c | 9 +++++++++
 tools/perf/util/ordered-events.h | 1 +
 tools/perf/util/session.c        | 6 +-----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/ordered-events.c b/tools/perf/util/ordered-events.c
index be6a48ce3eea..7b8923e12dc7 100644
--- a/tools/perf/util/ordered-events.c
+++ b/tools/perf/util/ordered-events.c
@@ -193,3 +193,12 @@ int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 
 	return err;
 }
+
+void ordered_events__init(struct ordered_events *oe)
+{
+	INIT_LIST_HEAD(&oe->events);
+	INIT_LIST_HEAD(&oe->cache);
+	INIT_LIST_HEAD(&oe->to_free);
+	oe->max_alloc_size = (u64) -1;
+	oe->cur_alloc_size = 0;
+}
diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 8309983bdd70..62f9945319b6 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -38,4 +38,5 @@ struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timesta
 void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event);
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
+void ordered_events__init(struct ordered_events *oe);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0ccf051247f6..7f5851e433bb 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -75,11 +75,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 		goto out;
 
 	session->repipe = repipe;
-	INIT_LIST_HEAD(&session->ordered_events.events);
-	INIT_LIST_HEAD(&session->ordered_events.cache);
-	INIT_LIST_HEAD(&session->ordered_events.to_free);
-	session->ordered_events.max_alloc_size = (u64) -1;
-	session->ordered_events.cur_alloc_size = 0;
+	ordered_events__init(&session->ordered_events);
 	machines__init(&session->machines);
 
 	if (file) {
-- 
1.9.3

