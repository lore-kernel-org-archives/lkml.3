Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaLVPaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:30:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:54044 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaLVPas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:30:48 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf ui/tui: Print backtrace symbols when segfault occurs
Date: Mon, 22 Dec 2014 12:30:07 -0300
Message-Id: <1419262209-9464-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419262209-9464-1-git-send-email-acme@kernel.org>
References: <1419262209-9464-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The output will look like below.  (I added an error into ui__init() for
the test).

  $ perf report
  perf: Segmentation fault
  -------- backtrace --------
  perf[0x503781]
  /usr/lib/libc.so.6(+0x33b20)[0x7f1a14f04b20]
  perf(ui__init+0xd5)[0x503645]
  perf(setup_browser+0x97)[0x4ce4e7]
  perf(cmd_report+0xcea)[0x4392ba]
  perf[0x428493]
  perf(main+0x60a)[0x427c0a]
  /usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f1a14ef1040]
  perf[0x427d29]
  [0x0]

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1419223455-4362-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/tui/setup.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 2f612562978c..3c38f25b1695 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -1,5 +1,8 @@
 #include <signal.h>
 #include <stdbool.h>
+#ifdef HAVE_BACKTRACE_SUPPORT
+#include <execinfo.h>
+#endif
 
 #include "../../util/cache.h"
 #include "../../util/debug.h"
@@ -88,6 +91,25 @@ int ui__getch(int delay_secs)
 	return SLkp_getkey();
 }
 
+#ifdef HAVE_BACKTRACE_SUPPORT
+static void ui__signal_backtrace(int sig)
+{
+	void *stackdump[32];
+	size_t size;
+
+	ui__exit(false);
+	psignal(sig, "perf");
+
+	printf("-------- backtrace --------\n");
+	size = backtrace(stackdump, ARRAY_SIZE(stackdump));
+	backtrace_symbols_fd(stackdump, size, STDOUT_FILENO);
+
+	exit(0);
+}
+#else
+# define ui__signal_backtrace  ui__signal
+#endif
+
 static void ui__signal(int sig)
 {
 	ui__exit(false);
@@ -122,8 +144,8 @@ int ui__init(void)
 	ui_browser__init();
 	tui_progress__init();
 
-	signal(SIGSEGV, ui__signal);
-	signal(SIGFPE, ui__signal);
+	signal(SIGSEGV, ui__signal_backtrace);
+	signal(SIGFPE, ui__signal_backtrace);
 	signal(SIGINT, ui__signal);
 	signal(SIGQUIT, ui__signal);
 	signal(SIGTERM, ui__signal);
-- 
1.9.3

