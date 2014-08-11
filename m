Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaHKIws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:52:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaHKIvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:10 -0400
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
Subject: [PATCH 15/20] perf kvm: Fix stdin handling for 'kvm stat live' command
Date: Mon, 11 Aug 2014 10:50:09 +0200
Message-Id: <1407747014-18394-16-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the initial ~(ICANON | ECHO) terminal mode is
not set, so we dont get stdin data until we press ENTER.

Fixing this by early setting of the ~(ICANON | ECHO) mode
and leaving this mode for whole life of the command, because
canonical mode is not needed.

This fix is preparation for the poller object installation
into 'kvm stat live' command.

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
 tools/perf/builtin-kvm.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7ccceadcd9f8..ff404750d744 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -885,15 +885,11 @@ static int fd_set_nonblock(int fd)
 	return 0;
 }
 
-static
-int perf_kvm__handle_stdin(struct termios *tc_now, struct termios *tc_save)
+static int perf_kvm__handle_stdin(void)
 {
 	int c;
 
-	tcsetattr(0, TCSANOW, tc_now);
 	c = getc(stdin);
-	tcsetattr(0, TCSAFLUSH, tc_save);
-
 	if (c == 'q')
 		return 1;
 
@@ -904,7 +900,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 {
 	struct pollfd *pollfds = NULL;
 	int nr_fds, nr_stdin, ret, err = -EINVAL;
-	struct termios tc, save;
+	struct termios save;
 
 	/* live flag must be set first */
 	kvm->live = true;
@@ -919,14 +915,9 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		goto out;
 	}
 
+	set_term_quiet_input(&save);
 	init_kvm_event_record(kvm);
 
-	tcgetattr(0, &save);
-	tc = save;
-	tc.c_lflag &= ~(ICANON | ECHO);
-	tc.c_cc[VMIN] = 0;
-	tc.c_cc[VTIME] = 0;
-
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
 
@@ -972,7 +963,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 			goto out;
 
 		if (pollfds[nr_stdin].revents & POLLIN)
-			done = perf_kvm__handle_stdin(&tc, &save);
+			done = perf_kvm__handle_stdin();
 
 		if (!rc && !done)
 			err = poll(pollfds, nr_fds, 100);
@@ -989,6 +980,7 @@ out:
 	if (kvm->timerfd >= 0)
 		close(kvm->timerfd);
 
+	tcsetattr(0, TCSAFLUSH, &save);
 	free(pollfds);
 	return err;
 }
-- 
1.8.3.1

