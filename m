Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaIJOKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:38574 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaIJOKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/14] perf kvm stat live: Use perf_evlist__add_pollfd() instead of local equivalent
Date: Wed, 10 Sep 2014 11:08:44 -0300
Message-Id: <1410358129-9965-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we can add file descriptors to the evlist pollfd and it will
autogrow, no need to copy all events to a local pollfd array, just add
the timer and stdin file descriptors.

Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-2hvp9iromiheh6rl4oaa08x5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f5d3ae483110..a440219b0be0 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -919,15 +919,8 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
 
-	/* copy pollfds -- need to add timerfd and stdin */
+	/* use pollfds -- need to add timerfd and stdin */
 	nr_fds = kvm->evlist->nr_fds;
-	pollfds = zalloc(sizeof(struct pollfd) * (nr_fds + 2));
-	if (!pollfds) {
-		err = -ENOMEM;
-		goto out;
-	}
-	memcpy(pollfds, kvm->evlist->pollfd,
-		sizeof(struct pollfd) * kvm->evlist->nr_fds);
 
 	/* add timer fd */
 	if (perf_kvm__timerfd_create(kvm) < 0) {
@@ -935,17 +928,21 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		goto out;
 	}
 
-	pollfds[nr_fds].fd = kvm->timerfd;
-	pollfds[nr_fds].events = POLLIN;
+	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd))
+		goto out;
+
 	nr_fds++;
 
-	pollfds[nr_fds].fd = fileno(stdin);
-	pollfds[nr_fds].events = POLLIN;
+	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)))
+		goto out;
+
 	nr_stdin = nr_fds;
 	nr_fds++;
 	if (fd_set_nonblock(fileno(stdin)) != 0)
 		goto out;
 
+	pollfds	 = kvm->evlist->pollfd;
+
 	/* everything is good - enable the events and process */
 	perf_evlist__enable(kvm->evlist);
 
@@ -979,7 +976,6 @@ out:
 		close(kvm->timerfd);
 
 	tcsetattr(0, TCSAFLUSH, &save);
-	free(pollfds);
 	return err;
 }
 
-- 
1.9.3

