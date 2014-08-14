Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaHNIoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:44:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbaHNIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:44:08 -0400
Date: Thu, 14 Aug 2014 01:43:48 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-d5b4130ae636e1fd0eaaea7152170198c34fbf62@git.kernel.org>
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
In-Reply-To: <1407747014-18394-16-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-16-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Fix stdin handling for 'kvm stat live'
  command
Git-Commit-ID: d5b4130ae636e1fd0eaaea7152170198c34fbf62
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

Commit-ID:  d5b4130ae636e1fd0eaaea7152170198c34fbf62
Gitweb:     http://git.kernel.org/tip/d5b4130ae636e1fd0eaaea7152170198c34fbf62
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 11 Aug 2014 10:50:09 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 12:42:24 -0300

perf kvm: Fix stdin handling for 'kvm stat live' command

Currently the initial ~(ICANON | ECHO) terminal mode is not set, so we
dont get stdin data until we press ENTER.

Fixing this by early setting of the ~(ICANON | ECHO) mode and leaving
this mode for whole life of the command, because canonical mode is not
needed.

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
Link: http://lkml.kernel.org/r/1407747014-18394-16-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7cccead..ff40475 100644
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
