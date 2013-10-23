Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab3JWVBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:01:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55414 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3JWU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/16] perf ui progress: Per progress bar state
Date: Wed, 23 Oct 2013 17:58:14 -0300
Message-Id: <1382561895-8237-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That will ease using a progress bar across multiple functions, like in
the upcoming patches that will present a progress bar when collapsing
histograms.

Based on a previous patch by Namhyung Kim.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cr7lq7ud9fj21bg7wvq27w1u@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/progress.c |  8 ++++----
 tools/perf/ui/progress.c     | 22 +++++++++++++++++-----
 tools/perf/ui/progress.h     | 15 +++++++++++----
 tools/perf/ui/tui/progress.c |  8 ++++----
 tools/perf/util/session.c    | 24 +++++++++++-------------
 5 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/tools/perf/ui/gtk/progress.c b/tools/perf/ui/gtk/progress.c
index 195c7f94f98e..b656655fbc39 100644
--- a/tools/perf/ui/gtk/progress.c
+++ b/tools/perf/ui/gtk/progress.c
@@ -7,14 +7,14 @@
 static GtkWidget *dialog;
 static GtkWidget *progress;
 
-static void gtk_ui_progress__update(u64 curr, u64 total, const char *title)
+static void gtk_ui_progress__update(struct ui_progress *p)
 {
-	double fraction = total ? 1.0 * curr / total : 0.0;
+	double fraction = p->total ? 1.0 * p->curr / p->total : 0.0;
 	char buf[1024];
 
 	if (dialog == NULL) {
 		GtkWidget *vbox = gtk_vbox_new(TRUE, 5);
-		GtkWidget *label = gtk_label_new(title);
+		GtkWidget *label = gtk_label_new(p->title);
 
 		dialog = gtk_window_new(GTK_WINDOW_TOPLEVEL);
 		progress = gtk_progress_bar_new();
@@ -32,7 +32,7 @@ static void gtk_ui_progress__update(u64 curr, u64 total, const char *title)
 	}
 
 	gtk_progress_bar_set_fraction(GTK_PROGRESS_BAR(progress), fraction);
-	snprintf(buf, sizeof(buf), "%"PRIu64" / %"PRIu64, curr, total);
+	snprintf(buf, sizeof(buf), "%"PRIu64" / %"PRIu64, p->curr, p->total);
 	gtk_progress_bar_set_text(GTK_PROGRESS_BAR(progress), buf);
 
 	/* we didn't call gtk_main yet, so do it manually */
diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/progress.c
index d753821b6e0b..a0f24c7115c5 100644
--- a/tools/perf/ui/progress.c
+++ b/tools/perf/ui/progress.c
@@ -1,9 +1,7 @@
 #include "../cache.h"
 #include "progress.h"
 
-static void null_progress__update(u64 curr __maybe_unused,
-				  u64 total __maybe_unused,
-				  const char *title __maybe_unused)
+static void null_progress__update(struct ui_progress *p __maybe_unused)
 {
 }
 
@@ -14,9 +12,23 @@ static struct ui_progress_ops null_progress__ops =
 
 struct ui_progress_ops *ui_progress__ops = &null_progress__ops;
 
-void ui_progress__update(u64 curr, u64 total, const char *title)
+void ui_progress__update(struct ui_progress *p, u64 adv)
 {
-	return ui_progress__ops->update(curr, total, title);
+	p->curr += adv;
+
+	if (p->curr >= p->next) {
+		p->next += p->step;
+		ui_progress__ops->update(p);
+	}
+}
+
+void ui_progress__init(struct ui_progress *p, u64 total, const char *title)
+{
+	p->curr = 0;
+	p->next = p->step = total / 16;
+	p->total = total;
+	p->title = title;
+
 }
 
 void ui_progress__finish(void)
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index d41bde5908a6..29ec8efffefb 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -3,14 +3,21 @@
 
 #include <../types.h>
 
+void ui_progress__finish(void);
+ 
+struct ui_progress {
+	const char *title;
+	u64 curr, next, step, total;
+};
+ 
+void ui_progress__init(struct ui_progress *p, u64 total, const char *title);
+void ui_progress__update(struct ui_progress *p, u64 adv);
+
 struct ui_progress_ops {
-	void (*update)(u64, u64, const char *);
+	void (*update)(struct ui_progress *p);
 	void (*finish)(void);
 };
 
 extern struct ui_progress_ops *ui_progress__ops;
 
-void ui_progress__update(u64 curr, u64 total, const char *title);
-void ui_progress__finish(void);
-
 #endif
diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index 0fcc5a1f525a..3e2d936d7443 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -5,7 +5,7 @@
 #include "tui.h"
 #include "../browser.h"
 
-static void tui_progress__update(u64 curr, u64 total, const char *title)
+static void tui_progress__update(struct ui_progress *p)
 {
 	int bar, y;
 	/*
@@ -15,7 +15,7 @@ static void tui_progress__update(u64 curr, u64 total, const char *title)
 	if (use_browser <= 0)
 		return;
 
-	if (total == 0)
+	if (p->total == 0)
 		return;
 
 	ui__refresh_dimensions(true);
@@ -24,9 +24,9 @@ static void tui_progress__update(u64 curr, u64 total, const char *title)
 	SLsmg_set_color(0);
 	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
 	SLsmg_gotorc(y++, 1);
-	SLsmg_write_string((char *)title);
+	SLsmg_write_string((char *)p->title);
 	SLsmg_set_color(HE_COLORSET_SELECTED);
-	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
+	bar = ((SLtt_Screen_Cols - 2) * p->curr) / p->total;
 	SLsmg_fill_region(y, 1, 1, bar, ' ');
 	SLsmg_refresh();
 	pthread_mutex_unlock(&ui__lock);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 854c5aa4db0d..4ba7b548e055 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -503,13 +503,16 @@ static int flush_sample_queue(struct perf_session *s,
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
-	unsigned idx = 0, progress_next = os->nr_samples / 16;
 	bool show_progress = limit == ULLONG_MAX;
+	struct ui_progress prog;
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
 		return 0;
 
+	if (show_progress)
+		ui_progress__init(&prog, os->nr_samples, "Processing time ordered events...");
+
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (session_done())
 			return 0;
@@ -530,11 +533,9 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (show_progress && (++idx >= progress_next)) {
-			progress_next += os->nr_samples / 16;
-			ui_progress__update(idx, os->nr_samples,
-					    "Processing time ordered events...");
-		}
+
+		if (show_progress)
+			ui_progress__update(&prog, 1);
 	}
 
 	if (list_empty(head)) {
@@ -1285,12 +1286,13 @@ int __perf_session__process_events(struct perf_session *session,
 				   u64 file_size, struct perf_tool *tool)
 {
 	int fd = perf_data_file__fd(session->file);
-	u64 head, page_offset, file_offset, file_pos, progress_next;
+	u64 head, page_offset, file_offset, file_pos;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
 	size_t	mmap_size;
 	char *buf, *mmaps[NUM_MMAPS];
 	union perf_event *event;
 	uint32_t size;
+	struct ui_progress prog;
 
 	perf_tool__fill_defaults(tool);
 
@@ -1301,7 +1303,7 @@ int __perf_session__process_events(struct perf_session *session,
 	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
-	progress_next = file_size / 16;
+	ui_progress__init(&prog, file_size, "Processing events...");
 
 	mmap_size = MMAP_SIZE;
 	if (mmap_size > file_size)
@@ -1356,11 +1358,7 @@ more:
 	head += size;
 	file_pos += size;
 
-	if (file_pos >= progress_next) {
-		progress_next += file_size / 16;
-		ui_progress__update(file_pos, file_size,
-				    "Processing events...");
-	}
+	ui_progress__update(&prog, size);
 
 	if (session_done())
 		goto out;
-- 
1.8.1.4

