Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaHKIvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaHKIvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:13 -0400
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
Subject: [PATCH 16/20] perf kvm: Add support to see event's ERR and HUP poll errors
Date: Mon, 11 Aug 2014 10:50:10 +0200
Message-Id: <1407747014-18394-17-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding kvm command support to see when all events
are down and forcing it to stop in that case.

Like following kvm stat live session will stop if the
monitored pid (1234) exits:

      $ sudo perf kvm stat live -p 1234

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
 tools/perf/builtin-kvm.c   | 111 +++++++++++++++++++++++----------------------
 tools/perf/util/kvm-stat.h |   1 -
 2 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index ff404750d744..30057b6fb44b 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -808,10 +808,10 @@ static void sig_handler(int sig __maybe_unused)
 static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
 {
 	struct itimerspec new_value;
-	int rc = -1;
+	int fd;
 
-	kvm->timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
-	if (kvm->timerfd < 0) {
+	fd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
+	if (fd < 0) {
 		pr_err("timerfd_create failed\n");
 		goto out;
 	}
@@ -821,23 +821,24 @@ static int perf_kvm__timerfd_create(struct perf_kvm_stat *kvm)
 	new_value.it_interval.tv_sec = kvm->display_time;
 	new_value.it_interval.tv_nsec = 0;
 
-	if (timerfd_settime(kvm->timerfd, 0, &new_value, NULL) != 0) {
+	if (timerfd_settime(fd, 0, &new_value, NULL) != 0) {
 		pr_err("timerfd_settime failed: %d\n", errno);
-		close(kvm->timerfd);
-		goto out;
+		close(fd);
+		return -1;
 	}
 
-	rc = 0;
 out:
-	return rc;
+	return fd;
 }
 
-static int perf_kvm__handle_timerfd(struct perf_kvm_stat *kvm)
+static int perf_kvm__handle_timerfd(struct poller *p __maybe_unused,
+				    struct poller_item *item)
 {
+	struct perf_kvm_stat *kvm = item->data;
 	uint64_t c;
 	int rc;
 
-	rc = read(kvm->timerfd, &c, sizeof(uint64_t));
+	rc = read(item->fd, &c, sizeof(uint64_t));
 	if (rc < 0) {
 		if (errno == EAGAIN)
 			return 0;
@@ -867,40 +868,59 @@ static int perf_kvm__handle_timerfd(struct perf_kvm_stat *kvm)
 	return 0;
 }
 
-static int fd_set_nonblock(int fd)
+static int data_error(struct poller *p, struct poller_item *item)
 {
-	long arg = 0;
+	pr_debug("got HUP/ERROR on fd %d\n", item->fd);
 
-	arg = fcntl(fd, F_GETFL);
-	if (arg < 0) {
-		pr_err("Failed to get current flags for fd %d\n", fd);
-		return -1;
-	}
+	poller__del(p, item);
 
-	if (fcntl(fd, F_SETFL, arg | O_NONBLOCK) < 0) {
-		pr_err("Failed to set non-block option on fd %d\n", fd);
-		return -1;
+	/*
+	 * Only 2 remains (stdin and timerfd), that mean we are
+	 * out of events, time to leave.
+	 */
+	if (p->n == 2) {
+		pr_debug("All events closed, shutting down.\n");
+		done = 1;
 	}
-
 	return 0;
 }
 
-static int perf_kvm__handle_stdin(void)
+static
+int perf_kvm__handle_stdin(struct poller *p __maybe_unused,
+			   struct poller_item *item __maybe_unused)
 {
 	int c;
 
 	c = getc(stdin);
 	if (c == 'q')
-		return 1;
+		done = 1;
 
 	return 0;
 }
 
 static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 {
-	struct pollfd *pollfds = NULL;
-	int nr_fds, nr_stdin, ret, err = -EINVAL;
+	int ret, err = -EINVAL;
 	struct termios save;
+	struct poller *poller = &kvm->evlist->poller;
+	struct poller_item input = {
+		.fd  = fileno(stdin),
+		.ops = {
+			.data = perf_kvm__handle_stdin,
+		}
+	};
+	struct poller_item timer = {
+		.data = kvm,
+		.ops  = {
+			.data = perf_kvm__handle_timerfd,
+		},
+	};
+	struct poller_ops poller_ops = {
+		.error  = data_error,
+		.hup    = data_error,
+	};
+
+	poller__set_ops(poller, &poller_ops);
 
 	/* live flag must be set first */
 	kvm->live = true;
@@ -921,31 +941,22 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
 
-	/* copy pollfds -- need to add timerfd and stdin */
-	nr_fds = kvm->evlist->nr_fds;
-	pollfds = zalloc(sizeof(struct pollfd) * (nr_fds + 2));
-	if (!pollfds) {
-		err = -ENOMEM;
+	err = perf_evlist__set_poller(kvm->evlist);
+	if (err < 0)
 		goto out;
-	}
-	memcpy(pollfds, kvm->evlist->pollfd,
-		sizeof(struct pollfd) * kvm->evlist->nr_fds);
 
-	/* add timer fd */
-	if (perf_kvm__timerfd_create(kvm) < 0) {
+	/* create timer fd */
+	timer.fd = perf_kvm__timerfd_create(kvm);
+	if (timer.fd < 0) {
 		err = -1;
 		goto out;
 	}
 
-	pollfds[nr_fds].fd = kvm->timerfd;
-	pollfds[nr_fds].events = POLLIN;
-	nr_fds++;
+	err = -1;
 
-	pollfds[nr_fds].fd = fileno(stdin);
-	pollfds[nr_fds].events = POLLIN;
-	nr_stdin = nr_fds;
-	nr_fds++;
-	if (fd_set_nonblock(fileno(stdin)) != 0)
+	/* add stdin and timer into poller */
+	if (poller__add(poller, &timer) ||
+	    poller__add(poller, &input))
 		goto out;
 
 	/* everything is good - enable the events and process */
@@ -958,15 +969,8 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		if (rc < 0)
 			break;
 
-		err = perf_kvm__handle_timerfd(kvm);
-		if (err)
-			goto out;
-
-		if (pollfds[nr_stdin].revents & POLLIN)
-			done = perf_kvm__handle_stdin();
-
 		if (!rc && !done)
-			err = poll(pollfds, nr_fds, 100);
+			err = poller__poll(poller, 100);
 	}
 
 	perf_evlist__disable(kvm->evlist);
@@ -977,11 +981,10 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	}
 
 out:
-	if (kvm->timerfd >= 0)
-		close(kvm->timerfd);
+	if (timer.fd >= 0)
+		close(timer.fd);
 
 	tcsetattr(0, TCSAFLUSH, &save);
-	free(pollfds);
 	return err;
 }
 
diff --git a/tools/perf/util/kvm-stat.h b/tools/perf/util/kvm-stat.h
index 0b5a8cd2ee79..eb34bee83615 100644
--- a/tools/perf/util/kvm-stat.h
+++ b/tools/perf/util/kvm-stat.h
@@ -97,7 +97,6 @@ struct perf_kvm_stat {
 
 	struct rb_root result;
 
-	int timerfd;
 	unsigned int display_time;
 	bool live;
 };
-- 
1.8.3.1

