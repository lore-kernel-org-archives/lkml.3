Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaHMWtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:54847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbaHMWs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:48:59 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/41] perf tools: Introduce set_term_quiet_input helper function
Date: Wed, 13 Aug 2014 19:47:50 -0300
Message-Id: <1407970107-24540-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding set_term_quiet_input helper to set the terminal quiet, out from
'perf top', used in following patches in 'perf kvm'.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407747014-18394-9-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 10 ++--------
 tools/perf/util/util.c   | 13 +++++++++++++
 tools/perf/util/util.h   |  2 ++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 10fc7e844872..e8459e260c3b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -580,20 +580,14 @@ static void *display_thread_tui(void *arg)
 static void *display_thread(void *arg)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-	struct termios tc, save;
+	struct termios save;
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
-	tcgetattr(0, &save);
-	tc = save;
-	tc.c_lflag &= ~(ICANON | ECHO);
-	tc.c_cc[VMIN] = 0;
-	tc.c_cc[VTIME] = 0;
-
 	pthread__unblock_sigwinch();
 repeat:
 	delay_msecs = top->delay_secs * 1000;
-	tcsetattr(0, TCSANOW, &tc);
+	set_term_quiet_input(&save);
 	/* trash return*/
 	getc(stdin);
 
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index b82a93cb1694..25822bdf7bbf 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -13,6 +13,7 @@
 #include <limits.h>
 #include <byteswap.h>
 #include <linux/kernel.h>
+#include <unistd.h>
 
 /*
  * XXX We need to find a better place for these things...
@@ -282,6 +283,18 @@ void get_term_dimensions(struct winsize *ws)
 	ws->ws_col = 80;
 }
 
+void set_term_quiet_input(struct termios *old)
+{
+	struct termios tc;
+
+	tcgetattr(0, old);
+	tc = *old;
+	tc.c_lflag &= ~(ICANON | ECHO);
+	tc.c_cc[VMIN] = 0;
+	tc.c_cc[VTIME] = 0;
+	tcsetattr(0, TCSANOW, &tc);
+}
+
 static void set_tracing_events_path(const char *mountpoint)
 {
 	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 03a1ea2266b8..d6a79b1fb28c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -75,6 +75,7 @@
 #include <api/fs/debugfs.h>
 #include <termios.h>
 #include <linux/bitops.h>
+#include <termios.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
@@ -308,6 +309,7 @@ extern unsigned int page_size;
 extern int cacheline_size;
 
 void get_term_dimensions(struct winsize *ws);
+void set_term_quiet_input(struct termios *old);
 
 struct parse_tag {
 	char tag;
-- 
1.9.3

