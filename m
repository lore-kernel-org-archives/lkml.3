Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaHKIux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaHKIuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:51 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/20] perf tools: Add set_term_quiet_input helper function
Date: Mon, 11 Aug 2014 10:50:02 +0200
Message-Id: <1407747014-18394-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding set_term_quiet_input helper to set the terminal
quiet. It will be used in following patches.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/util.c | 13 +++++++++++++
 tools/perf/util/util.h |  2 ++
 2 files changed, 15 insertions(+)

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
1.8.3.1

