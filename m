Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaHKIvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaHKIvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:04 -0400
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
Subject: [PATCH 13/20] perf top: Setup signals for terminal output
Date: Mon, 11 Aug 2014 10:50:07 +0200
Message-Id: <1407747014-18394-14-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TUI code setup standard signals handling, while the stdio
display code does not. This leads to premature termination of
display thread when signal is received and leaving terminal in
wrong state.

Also adding terminal cleanup at the end of display thread,
to ensure we get the old terminal state in case of signal
interruption.

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
 tools/perf/builtin-top.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f19321282436..9b4edf0bd49f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -579,6 +579,20 @@ static void *display_thread_tui(void *arg)
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
@@ -586,6 +600,7 @@ static void *display_thread(void *arg)
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
+	display_setup_sig();
 	pthread__unblock_sigwinch();
 repeat:
 	delay_msecs = top->delay_secs * 1000;
@@ -616,6 +631,7 @@ repeat:
 		}
 	}
 
+	tcsetattr(0, TCSAFLUSH, &save);
 	return NULL;
 }
 
-- 
1.8.3.1

