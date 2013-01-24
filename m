Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab3AXUIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:08:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50054 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727Ab3AXUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:35 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 52/74] perf tools: Move get_term_dimensions from top to util.c
Date: Thu, 24 Jan 2013 17:08:01 -0300
Message-Id: <1359058103-31645-53-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

It is used by util/help.c so it should be a lib function and included in
libperf.a. Code move only.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1358185681-90926-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 22 ----------------------
 tools/perf/perf.h        |  4 ----
 tools/perf/util/util.c   | 22 ++++++++++++++++++++++
 tools/perf/util/util.h   |  3 +++
 4 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bc78812..e05ba81 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -68,28 +68,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-void get_term_dimensions(struct winsize *ws)
-{
-	char *s = getenv("LINES");
-
-	if (s != NULL) {
-		ws->ws_row = atoi(s);
-		s = getenv("COLUMNS");
-		if (s != NULL) {
-			ws->ws_col = atoi(s);
-			if (ws->ws_row && ws->ws_col)
-				return;
-		}
-	}
-#ifdef TIOCGWINSZ
-	if (ioctl(1, TIOCGWINSZ, ws) == 0 &&
-	    ws->ws_row && ws->ws_col)
-		return;
-#endif
-	ws->ws_row = 25;
-	ws->ws_col = 80;
-}
-
 static void perf_top__update_print_entries(struct perf_top *top)
 {
 	if (top->print_entries > 9)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 7622f15..8f3bf38 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,10 +1,6 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-struct winsize;
-
-void get_term_dimensions(struct winsize *ws);
-
 #include <asm/unistd.h>
 
 #if defined(__i386__)
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 252b889..805d1f5 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -220,3 +220,25 @@ void dump_stack(void)
 #else
 void dump_stack(void) {}
 #endif
+
+void get_term_dimensions(struct winsize *ws)
+{
+	char *s = getenv("LINES");
+
+	if (s != NULL) {
+		ws->ws_row = atoi(s);
+		s = getenv("COLUMNS");
+		if (s != NULL) {
+			ws->ws_col = atoi(s);
+			if (ws->ws_row && ws->ws_col)
+				return;
+		}
+	}
+#ifdef TIOCGWINSZ
+	if (ioctl(1, TIOCGWINSZ, ws) == 0 &&
+	    ws->ws_row && ws->ws_col)
+		return;
+#endif
+	ws->ws_row = 25;
+	ws->ws_col = 80;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index c233091..ec5de5e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -271,4 +271,7 @@ void dump_stack(void);
 
 extern unsigned int page_size;
 
+struct winsize;
+void get_term_dimensions(struct winsize *ws);
+
 #endif
-- 
1.8.1.1.361.gec3ae6e

