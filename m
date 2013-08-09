Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030422Ab3HIG2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:28:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51561 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220Ab3HIG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:28:13 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-f0-52048bfb328f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] perf tools: Setup GTK browser dynamically
Date: Fri,  9 Aug 2013 15:28:08 +0900
Message-Id: <1376029689-32593-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
References: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call setup/exit GTK browser function using libdl.

Cc: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/gtk.h |  3 +++
 tools/perf/ui/setup.c   | 50 +++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/ui.h      | 12 +-----------
 3 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 3d96785ef155..09b7a062fd48 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -20,6 +20,9 @@ struct perf_gtk_context {
 	guint statbar_ctx_id;
 };
 
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
+
 extern struct perf_gtk_context *pgctx;
 
 static inline bool perf_gtk__is_active_context(struct perf_gtk_context *ctx)
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 47d9a571f261..33338c03741b 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,10 +1,56 @@
 #include <pthread.h>
+#include <dlfcn.h>
 
 #include "../util/cache.h"
 #include "../util/debug.h"
 #include "../util/hist.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
+void *perf_gtk_handle;
+
+#ifdef GTK2_SUPPORT
+static int setup_gtk_browser(void)
+{
+	int (*perf_ui_init)(void);
+
+	perf_gtk_handle = dlopen("libperf-gtk.so", RTLD_LAZY);
+	if (perf_gtk_handle == NULL)
+		return -1;
+
+	perf_ui_init = dlsym(perf_gtk_handle, "perf_gtk__init");
+	if (perf_ui_init == NULL)
+		goto out_close;
+
+	if (perf_ui_init() == 0)
+		return 0;
+
+out_close:
+	dlclose(perf_gtk_handle);
+	return -1;
+}
+
+static void exit_gtk_browser(bool wait_for_ok)
+{
+	void (*perf_ui_exit)(bool);
+
+	if (perf_gtk_handle == NULL)
+		return;
+
+	perf_ui_exit = dlsym(perf_gtk_handle, "perf_gtk__exit");
+	if (perf_ui_exit == NULL)
+		goto out_close;
+
+	perf_ui_exit(wait_for_ok);
+
+out_close:
+	dlclose(perf_gtk_handle);
+
+	perf_gtk_handle = NULL;
+}
+#else
+static inline int setup_gtk_browser(void) { return -1; }
+static inline void exit_gtk_browser(bool wait_for_ok __maybe_unused) {}
+#endif
 
 void setup_browser(bool fallback_to_pager)
 {
@@ -17,7 +63,7 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
-		if (perf_gtk__init() == 0)
+		if (setup_gtk_browser() == 0)
 			break;
 		/* fall through */
 	case 1:
@@ -39,7 +85,7 @@ void exit_browser(bool wait_for_ok)
 {
 	switch (use_browser) {
 	case 2:
-		perf_gtk__exit(wait_for_ok);
+		exit_gtk_browser(wait_for_ok);
 		break;
 
 	case 1:
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index 70cb0d4eb8aa..4f7cbe6a2608 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -6,6 +6,7 @@
 #include <linux/compiler.h>
 
 extern pthread_mutex_t ui__lock;
+extern void *perf_gtk_handle;
 
 extern int use_browser;
 
@@ -23,17 +24,6 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef GTK2_SUPPORT
-int perf_gtk__init(void);
-void perf_gtk__exit(bool wait_for_ok);
-#else
-static inline int perf_gtk__init(void)
-{
-	return -1;
-}
-static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
-#endif
-
 void ui__refresh_dimensions(bool force);
 
 #endif /* _PERF_UI_H_ */
-- 
1.7.11.7

