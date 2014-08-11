Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaHKIvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaHKIvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:08 -0400
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
Subject: [PATCH 14/20] perf top: Use poller object for display thread stdin
Date: Mon, 11 Aug 2014 10:50:08 +0200
Message-Id: <1407747014-18394-15-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using poller object to handle user input for stdio top.

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
 tools/perf/builtin-top.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9b4edf0bd49f..8d0ed211fd7b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -422,26 +422,22 @@ static int perf_top__key_mapped(struct perf_top *top, int c)
 	return 0;
 }
 
-static bool perf_top__handle_keypress(struct perf_top *top, int c)
+static bool perf_top__handle_keypress(struct perf_top *top, int c,
+				      struct poller *poller)
 {
 	bool ret = true;
 
 	if (!perf_top__key_mapped(top, c)) {
-		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-		struct termios tc, save;
+		struct termios save;
 
 		perf_top__print_mapped_keys(top);
 		fprintf(stdout, "\nEnter selection, or unmapped key to continue: ");
 		fflush(stdout);
 
-		tcgetattr(0, &save);
-		tc = save;
-		tc.c_lflag &= ~(ICANON | ECHO);
-		tc.c_cc[VMIN] = 0;
-		tc.c_cc[VTIME] = 0;
-		tcsetattr(0, TCSANOW, &tc);
+		set_term_quiet_input(&save);
+		if (poller__poll(poller, -1) < 0)
+			return 0;
 
-		poll(&stdin_poll, 1, -1);
 		c = getc(stdin);
 
 		tcsetattr(0, TCSAFLUSH, &save);
@@ -595,11 +591,19 @@ static void display_setup_sig(void)
 
 static void *display_thread(void *arg)
 {
-	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
+	struct poller poller;
+	struct poller_item in = {
+		.fd = fileno(stdin),
+	};
 	struct termios save;
 	struct perf_top *top = arg;
 	int delay_msecs, c;
 
+	if (poller__add(&poller, &in)) {
+		done = 1;
+		return NULL;
+	}
+
 	display_setup_sig();
 	pthread__unblock_sigwinch();
 repeat:
@@ -610,23 +614,14 @@ repeat:
 
 	while (!done) {
 		perf_top__print_sym_table(top);
-		/*
-		 * Either timeout expired or we got an EINTR due to SIGWINCH,
-		 * refresh screen in both cases.
-		 */
-		switch (poll(&stdin_poll, 1, delay_msecs)) {
-		case 0:
-			continue;
-		case -1:
-			if (errno == EINTR)
-				continue;
-			/* Fall trhu */
-		default:
+
+		if (poller__poll(&poller, delay_msecs) > 0) {
 			c = getc(stdin);
 			tcsetattr(0, TCSAFLUSH, &save);
 
-			if (perf_top__handle_keypress(top, c))
+			if (perf_top__handle_keypress(top, c, &poller))
 				goto repeat;
+
 			done = 1;
 		}
 	}
-- 
1.8.3.1

