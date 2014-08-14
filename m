Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaHNIn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:43:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaHNIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:43:54 -0400
Date: Thu, 14 Aug 2014 01:43:34 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-4a1a99712a8a13d97e9de818869bf1b88583d6bc@git.kernel.org>
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
In-Reply-To: <1407747014-18394-14-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-14-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Setup signals for terminal output
Git-Commit-ID: 4a1a99712a8a13d97e9de818869bf1b88583d6bc
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

Commit-ID:  4a1a99712a8a13d97e9de818869bf1b88583d6bc
Gitweb:     http://git.kernel.org/tip/4a1a99712a8a13d97e9de818869bf1b88583d6bc
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 11 Aug 2014 10:50:07 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 12:42:24 -0300

perf top: Setup signals for terminal output

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
index e8459e2..0ab3ea7 100644
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
 
