Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3AYLts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:49:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3AYLtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:49:45 -0500
Date: Fri, 25 Jan 2013 03:49:24 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-2c803e5248d038988ec7c52e8fd7c83130dd3c13@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1358185681-90926-1-git-send-email-dsahern@gmail.com>
References: <1358185681-90926-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move get_term_dimensions from top to util.c
Git-Commit-ID: 2c803e5248d038988ec7c52e8fd7c83130dd3c13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:49:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c803e5248d038988ec7c52e8fd7c83130dd3c13
Gitweb:     http://git.kernel.org/tip/2c803e5248d038988ec7c52e8fd7c83130dd3c13
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 14 Jan 2013 10:48:01 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:34 -0300

perf tools: Move get_term_dimensions from top to util.c

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
