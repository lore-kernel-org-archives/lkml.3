Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbbAAV3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 16:29:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44382 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbbAAV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 16:29:12 -0500
Date: Thu, 1 Jan 2015 13:28:51 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b11bc8e28f4829f693ef6c0178fe1811386ac828@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        dsahern@gmail.com, eranian@google.com, mingo@kernel.org, hpa@zytor.com,
        adrian.hunter@intel.com, jolsa@redhat.com, acme@redhat.com,
        tglx@linutronix.de
Reply-To: hpa@zytor.com, adrian.hunter@intel.com, mingo@kernel.org,
        jolsa@redhat.com, acme@redhat.com, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, eranian@google.com, namhyung@kernel.org
In-Reply-To: <1419223455-4362-4-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf ui/tui:
  Print backtrace symbols when segfault occurs
Git-Commit-ID: b11bc8e28f4829f693ef6c0178fe1811386ac828
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

Commit-ID:  b11bc8e28f4829f693ef6c0178fe1811386ac828
Gitweb:     http://git.kernel.org/tip/b11bc8e28f4829f693ef6c0178fe1811386ac828
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 22 Dec 2014 13:44:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 23 Dec 2014 12:05:59 -0300

perf ui/tui: Print backtrace symbols when segfault occurs

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
index 2f61256..3c38f25 100644
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
