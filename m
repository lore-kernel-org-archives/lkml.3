Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaIZJVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:21:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbaIZJVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:21:12 -0400
Date: Fri, 26 Sep 2014 02:20:51 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2hvp9iromiheh6rl4oaa08x5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm stat live: Use perf_evlist__add_pollfd()
  instead of local equivalent
Git-Commit-ID: 0a04c9e0b2181aff8348b5e80d9d96ec8df1ffb3
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

Commit-ID:  0a04c9e0b2181aff8348b5e80d9d96ec8df1ffb3
Gitweb:     http://git.kernel.org/tip/0a04c9e0b2181aff8348b5e80d9d96ec8df1ffb3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 18 Aug 2014 17:12:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:54 -0300

perf kvm stat live: Use perf_evlist__add_pollfd() instead of local equivalent

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
index f5d3ae4..a440219 100644
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
 
