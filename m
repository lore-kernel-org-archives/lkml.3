Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3EZA1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 20:27:10 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37269 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748Ab3EZA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 20:27:07 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@kernel.org, fweisbec@gmail.com,
        peterz@infradead.org, jolsa@redhat.com, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com, runzhen@linux.vnet.ibm.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 16/16] perf kvm: set live mode refresh time dynamically
Date: Sat, 25 May 2013 18:24:56 -0600
Message-Id: <1369527896-3650-17-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David's patch (https://lkml.org/lkml/2013/5/9/125 ) add a live mode for
perf kvm stat, but his patch can't set the refresh frequency
dynamically.

This patch accepts user's input and changes the value of
kvm->display_time variable.

For example, when the live mode is running, you press any key, it will
prints:

Mapped keys:
     [d]     set refresh frequency
     [q]     quit

Enter selection, or unmapped key to continue:
Enter refresh frequency(seconds): 2

Then, the live mode will refresh the screen every 2 seconds.

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   42 ++++++++++++++++++++++++++++++++++++++----
 tools/perf/util/top.c    |    4 ++++
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 7392538..3e3f6e2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -111,7 +111,7 @@ struct perf_kvm_stat {
 	struct rb_root result;
 
 	int timerfd;
-	unsigned int display_time;
+	int display_time;
 	bool live;
 };
 
@@ -1021,17 +1021,51 @@ static int fd_set_nonblock(int fd)
 	return 0;
 }
 
+static void perf_kvm_live__print_mapped_keys(void)
+{
+	fprintf(stdout, "\nMapped keys:\n");
+	fprintf(stdout, "\t[d]     set refresh frequency\n");
+	fprintf(stdout, "\t[q]     quit\n");
+}
+
 static
-int perf_kvm__handle_stdin(struct termios *tc_now, struct termios *tc_save)
+int perf_kvm__handle_stdin(struct perf_kvm_stat *kvm,
+			   struct termios *tc_now,
+			   struct termios *tc_save)
 {
 	int c;
+	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN};
 
 	tcsetattr(0, TCSANOW, tc_now);
 	c = getc(stdin);
 	tcsetattr(0, TCSAFLUSH, tc_save);
 
+	if (c == -1)
+		return 0;
 	if (c == 'q')
 		return 1;
+	perf_kvm_live__print_mapped_keys();
+	fprintf(stdout, "\nEnter selection, or unmapped key to continue: ");
+	fflush(stdout);
+
+	tcsetattr(0, TCSANOW, tc_now);
+	poll(&stdin_poll, 1, -1);
+	c = getc(stdin);
+	tcsetattr(0, TCSAFLUSH, tc_save);
+
+	switch (c) {
+	case 'q':
+		return 1;
+	case 'd':
+		prompt_integer(&kvm->display_time,
+			       "Enter refresh frequency(seconds)");
+		if (kvm->display_time < 1)
+			kvm->display_time = 1;
+		if (perf_kvm__timerfd_set(kvm) < 0)
+			return 1;
+	default:
+		break;
+	}
 
 	return 0;
 }
@@ -1108,7 +1142,7 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 			goto out;
 
 		if (pollfds[nr_stdin].revents & POLLIN)
-			done = perf_kvm__handle_stdin(&tc, &save);
+			done = perf_kvm__handle_stdin(kvm, &tc, &save);
 
 		if (!rc && !done)
 			err = poll(pollfds, nr_fds, 100);
@@ -1349,7 +1383,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 			"be more verbose (show counter open errors, etc)"),
 		OPT_BOOLEAN('a', "all-cpus", &kvm->opts.target.system_wide,
 			"system-wide collection from all CPUs"),
-		OPT_UINTEGER('d', "display", &kvm->display_time,
+		OPT_INTEGER('d', "display", &kvm->display_time,
 			"time in seconds between display updates"),
 		OPT_STRING(0, "event", &kvm->report_event, "report event",
 			"event for reporting: vmexit, mmio, ioport"),
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 1a2eaec..10bff6d 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -121,8 +121,12 @@ void prompt_integer(int *target, const char *msg)
 	char *buf = malloc(0), *p;
 	size_t dummy = 0;
 	int tmp;
+	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN};
 
 	fprintf(stdout, "\n%s: ", msg);
+	fflush(stdout);
+	poll(&stdin_poll, 1, -1);
+
 	if (getline(&buf, &dummy, stdin) < 0)
 		return;
 
-- 
1.7.10.1

