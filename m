Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaHMWtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:54864 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbaHMWtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:03 -0400
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
Subject: [PATCH 05/41] perf top: Setup signals for terminal output
Date: Wed, 13 Aug 2014 19:47:51 -0300
Message-Id: <1407970107-24540-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The TUI code setup standard signals handling, while the stdio display
code does not. This leads to premature termination of display thread
when signal is received and leaving terminal in wrong state.

Also adding terminal cleanup at the end of display thread, to ensure we
get the old terminal state in case of signal interruption.

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
Link: http://lkml.kernel.org/r/1407747014-18394-14-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e8459e260c3b..0ab3ea7f7525 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -577,6 +577,20 @@ static void *display_thread_tui(void *arg)
 	return NULL;
 }
 
+static void display_sig(int sig __maybe_unused)
+{
+	done = 1;
+}
+
+static void display_setup_sig(void)
+{
+	signal(SIGSEGV, display_sig);
+	signal(SIGFPE,  display_sig);
+	signal(SIGINT,  display_sig);
+	signal(SIGQUIT, display_sig);
+	signal(SIGTERM, display_sig);
+}
+
 static void *display_thread(void *arg)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
@@ -584,6 +598,7 @@ static void *display_thread(void *arg)
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
+	display_setup_sig();
 	pthread__unblock_sigwinch();
 repeat:
 	delay_msecs = top->delay_secs * 1000;
@@ -614,6 +629,7 @@ repeat:
 		}
 	}
 
+	tcsetattr(0, TCSAFLUSH, &save);
 	return NULL;
 }
 
-- 
1.9.3

