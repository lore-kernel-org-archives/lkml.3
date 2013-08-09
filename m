Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389Ab3HIG2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:28:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54151 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030260Ab3HIG2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:28:14 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-f3-52048bfbf5ec
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/3] perf tools: Run dynamic loaded GTK browser
Date: Fri,  9 Aug 2013 15:28:09 +0900
Message-Id: <1376029689-32593-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
References: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run GTK hist and annotation browser using libdl.

Cc: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c | 26 +++++++++++++++++++++++---
 tools/perf/builtin-report.c   | 16 ++++++++++++++--
 tools/perf/config/Makefile    |  2 +-
 tools/perf/ui/gtk/annotate.c  | 13 ++++++++++---
 tools/perf/ui/gtk/gtk.h       | 13 +++++++++++++
 tools/perf/util/annotate.h    | 24 ------------------------
 tools/perf/util/hist.h        | 15 ---------------
 7 files changed, 61 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index db491e9a812b..82469b3ead07 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -30,6 +30,7 @@
 #include "util/tool.h"
 #include "arch/common.h"
 
+#include <dlfcn.h>
 #include <linux/bitmap.h>
 
 struct perf_annotate {
@@ -143,8 +144,18 @@ find_next:
 
 		if (use_browser == 2) {
 			int ret;
+			int (*annotate)(struct hist_entry *he,
+					struct perf_evsel *evsel,
+					struct hist_browser_timer *hbt);
+
+			annotate = dlsym(perf_gtk_handle,
+					 "hist_entry__gtk_annotate");
+			if (annotate == NULL) {
+				ui__error("GTK browser not found!\n");
+				return;
+			}
 
-			ret = hist_entry__gtk_annotate(he, evsel, NULL);
+			ret = annotate(he, evsel, NULL);
 			if (!ret || !ann->skip_missing)
 				return;
 
@@ -246,8 +257,17 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		goto out_delete;
 	}
 
-	if (use_browser == 2)
-		perf_gtk__show_annotations();
+	if (use_browser == 2) {
+		void (*show_annotations)(void);
+
+		show_annotations = dlsym(perf_gtk_handle,
+					 "perf_gtk__show_annotations");
+		if (show_annotations == NULL) {
+			ui__error("GTK browser not found!\n");
+			goto out_delete;
+		}
+		show_annotations();
+	}
 
 out_delete:
 	/*
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d785d89ed226..05c0e80c8ae4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,6 +35,7 @@
 #include "util/hist.h"
 #include "arch/common.h"
 
+#include <dlfcn.h>
 #include <linux/bitmap.h>
 
 struct perf_report {
@@ -592,8 +593,19 @@ static int __cmd_report(struct perf_report *rep)
 				ret = 0;
 
 		} else if (use_browser == 2) {
-			perf_evlist__gtk_browse_hists(session->evlist, help,
-						      NULL, rep->min_percent);
+			int (*hist_browser)(struct perf_evlist *,
+					    const char *,
+					    struct hist_browser_timer *,
+					    float min_pcnt);
+
+			hist_browser = dlsym(perf_gtk_handle,
+					     "perf_evlist__gtk_browse_hists");
+			if (hist_browser == NULL) {
+				ui__error("GTK browser not found!\n");
+				return ret;
+			}
+			hist_browser(session->evlist, help, NULL,
+				     rep->min_percent);
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6bdfd0302c4e..1b6ccb242609 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -269,7 +269,7 @@ ifndef NO_GTK2
     ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
       GTK_CFLAGS := -DHAVE_GTK_INFO_BAR
     endif
-    GTK_CFLAGS += -DGTK2_SUPPORT
+    CFLAGS += -DGTK2_SUPPORT
     GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
     GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
   endif
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index f538794615db..9c7ff8d31b27 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -154,9 +154,9 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 	return 0;
 }
 
-int symbol__gtk_annotate(struct symbol *sym, struct map *map,
-			 struct perf_evsel *evsel,
-			 struct hist_browser_timer *hbt)
+static int symbol__gtk_annotate(struct symbol *sym, struct map *map,
+				struct perf_evsel *evsel,
+				struct hist_browser_timer *hbt)
 {
 	GtkWidget *window;
 	GtkWidget *notebook;
@@ -226,6 +226,13 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+int hist_entry__gtk_annotate(struct hist_entry *he,
+			     struct perf_evsel *evsel,
+			     struct hist_browser_timer *hbt)
+{
+	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evsel, hbt);
+}
+
 void perf_gtk__show_annotations(void)
 {
 	GtkWidget *window;
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 09b7a062fd48..62922d284bca 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -51,4 +51,17 @@ static inline GtkWidget *perf_gtk__setup_info_bar(void)
 }
 #endif
 
+struct perf_evsel;
+struct perf_evlist;
+struct hist_entry;
+struct hist_browser_timer;
+
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  struct hist_browser_timer *hbt,
+				  float min_pcnt);
+int hist_entry__gtk_annotate(struct hist_entry *he,
+			     struct perf_evsel *evsel,
+			     struct hist_browser_timer *hbt);
+void perf_gtk__show_annotations(void);
+
 #endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index af755156d278..31b898312c3f 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -165,30 +165,6 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 }
 #endif
 
-#ifdef GTK2_SUPPORT
-int symbol__gtk_annotate(struct symbol *sym, struct map *map,
-			 struct perf_evsel *evsel,
-			 struct hist_browser_timer *hbt);
-
-static inline int hist_entry__gtk_annotate(struct hist_entry *he,
-					   struct perf_evsel *evsel,
-					   struct hist_browser_timer *hbt)
-{
-	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evsel, hbt);
-}
-
-void perf_gtk__show_annotations(void);
-#else
-static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
-				struct perf_evsel *evsel __maybe_unused,
-				struct hist_browser_timer *hbt __maybe_unused)
-{
-	return 0;
-}
-
-static inline void perf_gtk__show_annotations(void) {}
-#endif
-
 extern const char	*disassembler_style;
 
 #endif	/* __PERF_ANNOTATE_H */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1329b6b6ffe6..7f29792efc58 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -224,20 +224,5 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #define K_SWITCH_INPUT_DATA -3000
 #endif
 
-#ifdef GTK2_SUPPORT
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  struct hist_browser_timer *hbt __maybe_unused,
-				  float min_pcnt);
-#else
-static inline
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
-				  const char *help __maybe_unused,
-				  struct hist_browser_timer *hbt __maybe_unused,
-				  float min_pcnt __maybe_unused)
-{
-	return 0;
-}
-#endif
-
 unsigned int hists__sort_list_width(struct hists *self);
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

