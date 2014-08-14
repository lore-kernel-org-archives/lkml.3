Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaHNIny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:43:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbaHNIns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:43:48 -0400
Date: Thu, 14 Aug 2014 01:43:21 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-9398c484f8abc8d287cb90f5a33dd43ac26f24ef@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1407747014-18394-9-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-9-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Introduce set_term_quiet_input helper function
Git-Commit-ID: 9398c484f8abc8d287cb90f5a33dd43ac26f24ef
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

Commit-ID:  9398c484f8abc8d287cb90f5a33dd43ac26f24ef
Gitweb:     http://git.kernel.org/tip/9398c484f8abc8d287cb90f5a33dd43ac26f24ef
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 11 Aug 2014 10:50:02 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 11:14:22 -0300

perf tools: Introduce set_term_quiet_input helper function

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
index 10fc7e8..e8459e2 100644
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
index b82a93c..25822bd 100644
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
index 03a1ea2..d6a79b1 100644
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
