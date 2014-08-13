Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaHMFQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:16:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaHMFQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:16:15 -0400
Date: Tue, 12 Aug 2014 22:15:55 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-g6dx35hed8g14eh1ygx4uzp6@git.kernel.org>
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
Subject: [tip:perf/core] perf tools: Add ordered_events__init function
Git-Commit-ID: 36522f5cf2ad280c971557e04120d52f9330ed36
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

Commit-ID:  36522f5cf2ad280c971557e04120d52f9330ed36
Gitweb:     http://git.kernel.org/tip/36522f5cf2ad280c971557e04120d52f9330ed36
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Tue, 10 Jun 2014 22:47:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:02:59 -0300

perf tools: Add ordered_events__init function

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
index be6a48c..7b8923e 100644
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
index 8309983..62f9945 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -38,4 +38,5 @@ struct ordered_event *ordered_events__new(struct ordered_events *oe, u64 timesta
 void ordered_events__delete(struct ordered_events *oe, struct ordered_event *event);
 int ordered_events__flush(struct perf_session *s, struct perf_tool *tool,
 			  enum oe_flush how);
+void ordered_events__init(struct ordered_events *oe);
 #endif /* __ORDERED_EVENTS_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0ccf051..7f5851e 100644
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
