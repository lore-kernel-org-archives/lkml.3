Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab3ANRsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:48:08 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61855 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3ANRsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:48:06 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf: move get_term_dimensions from top to util.c
Date: Mon, 14 Jan 2013 10:48:01 -0700
Message-Id: <1358185681-90926-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is used by util/help.c so it should be a lib function and included
in libperf.a. Code move only.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-top.c |   22 ----------------------
 tools/perf/perf.h        |    4 ----
 tools/perf/util/util.c   |   22 ++++++++++++++++++++++
 tools/perf/util/util.h   |    3 +++
 4 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c9ff395..471efaa 100644
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
index 2c340e7..ec1eace 100644
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
index 5906e84..1e32d8b 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -218,3 +218,25 @@ void dump_stack(void)
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
1.7.10.1

