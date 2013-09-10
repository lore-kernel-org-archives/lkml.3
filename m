Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3IJIY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:24:29 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45991 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3IJIYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:24:25 -0400
X-AuditID: 9c93017e-b7c76ae000003897-9f-522ed73440fe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] perf ui/progress: Add new helper functions for progress bar
Date: Tue, 10 Sep 2013 17:24:17 +0900
Message-Id: <1378801458-2515-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Introduce ui_progress_setup() and ui_progress__advance() to separate
out from the session logic.  It'll be used by other places in the
upcoming patch.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/progress.c  | 18 ++++++++++++++++++
 tools/perf/ui/progress.h  | 10 ++++++++++
 tools/perf/util/session.c | 22 +++++++++-------------
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/progress.c
index 3ec695607a4d..b5c22c6b1d93 100644
--- a/tools/perf/ui/progress.c
+++ b/tools/perf/ui/progress.c
@@ -19,6 +19,24 @@ void ui_progress__update(u64 curr, u64 total, const char *title)
 	return progress_fns->update(curr, total, title);
 }
 
+void ui_progress__setup(struct perf_progress *p, u64 total)
+{
+	p->curr = 0;
+	p->next = p->unit = total / 16;
+	p->total = total;
+
+}
+
+void ui_progress__advance(struct perf_progress *p, u64 adv, const char *title)
+{
+	p->curr += adv;
+
+	if (p->curr >= p->next) {
+		p->next += p->unit;
+		ui_progress__update(p->curr, p->total, title);
+	}
+}
+
 void ui_progress__finish(void)
 {
 	if (progress_fns->finish)
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index 257cc224f9cf..3bd23e825953 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -8,10 +8,20 @@ struct ui_progress {
 	void (*finish)(void);
 };
 
+struct perf_progress {
+	u64 curr;
+	u64 next;
+	u64 unit;
+	u64 total;
+};
+
 extern struct ui_progress *progress_fns;
 
 void ui_progress__init(void);
 
+void ui_progress__setup(struct perf_progress *p, u64 total);
+void ui_progress__advance(struct perf_progress *p, u64 adv, const char *title);
+
 void ui_progress__update(u64 curr, u64 total, const char *title);
 void ui_progress__finish(void);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1fc0c628683e..fe8f8e7a7d02 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -503,12 +503,14 @@ static int flush_sample_queue(struct perf_session *s,
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
-	unsigned idx = 0, progress_next = os->nr_samples / 16;
+	struct perf_progress prog;
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
 		return 0;
 
+	ui_progress__setup(&prog, os->nr_samples);
+
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (iter->timestamp > limit)
 			break;
@@ -526,11 +528,8 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (++idx >= progress_next) {
-			progress_next += os->nr_samples / 16;
-			ui_progress__update(idx, os->nr_samples,
-					    "Processing time ordered events...");
-		}
+
+		ui_progress__advance(&prog, 1, "Processing time ordered events...");
 	}
 
 	if (list_empty(head)) {
@@ -1271,12 +1270,13 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 data_offset, u64 data_size,
 				   u64 file_size, struct perf_tool *tool)
 {
-	u64 head, page_offset, file_offset, file_pos, progress_next;
+	u64 head, page_offset, file_offset, file_pos;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
 	char *buf, *mmaps[NUM_MMAPS];
 	union perf_event *event;
 	uint32_t size;
+	struct perf_progress prog;
 
 	perf_tool__fill_defaults(tool);
 
@@ -1287,7 +1287,7 @@ int __perf_session__process_events(struct perf_session *session,
 	if (data_offset + data_size < file_size)
 		file_size = data_offset + data_size;
 
-	progress_next = file_size / 16;
+	ui_progress__setup(&prog, file_size);
 
 	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size)
@@ -1342,11 +1342,7 @@ more:
 	head += size;
 	file_pos += size;
 
-	if (file_pos >= progress_next) {
-		progress_next += file_size / 16;
-		ui_progress__update(file_pos, file_size,
-				    "Processing events...");
-	}
+	ui_progress__advance(&prog, size, "Processing events...");
 
 	if (file_pos < file_size)
 		goto more;
-- 
1.7.11.7

