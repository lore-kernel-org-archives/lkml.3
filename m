Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbaJNVFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:05:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:44483 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbaJNVFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:05:00 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Milian Wolff <mail@milianw.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/24] perf kvm stat live: Use fdarray object instead of pollfd
Date: Tue, 14 Oct 2014 18:04:12 -0300
Message-Id: <1413320673-5784-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The reason is that we don't need to count the number of file descriptors
because it's already handled in fdarray object.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1412179229-19466-5-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index dc7d704735bd..460a4ce9c044 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -896,8 +896,7 @@ static int perf_kvm__handle_stdin(void)
 
 static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 {
-	struct pollfd *pollfds = NULL;
-	int nr_fds, nr_stdin, ret, err = -EINVAL;
+	int nr_stdin, ret, err = -EINVAL;
 	struct termios save;
 
 	/* live flag must be set first */
@@ -919,9 +918,6 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
 
-	/* use pollfds -- need to add timerfd and stdin */
-	nr_fds = kvm->evlist->pollfd.nr;
-
 	/* add timer fd */
 	if (perf_kvm__timerfd_create(kvm) < 0) {
 		err = -1;
@@ -931,22 +927,18 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd) < 0)
 		goto out;
 
-	nr_fds++;
-
 	nr_stdin = perf_evlist__add_pollfd(kvm->evlist, fileno(stdin));
 	if (nr_stdin < 0)
 		goto out;
 
-	nr_fds++;
 	if (fd_set_nonblock(fileno(stdin)) != 0)
 		goto out;
 
-	pollfds	 = kvm->evlist->pollfd.entries;
-
 	/* everything is good - enable the events and process */
 	perf_evlist__enable(kvm->evlist);
 
 	while (!done) {
+		struct fdarray *fda = &kvm->evlist->pollfd;
 		int rc;
 
 		rc = perf_kvm__mmap_read(kvm);
@@ -957,11 +949,11 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		if (err)
 			goto out;
 
-		if (pollfds[nr_stdin].revents & POLLIN)
+		if (fda->entries[nr_stdin].revents & POLLIN)
 			done = perf_kvm__handle_stdin();
 
 		if (!rc && !done)
-			err = poll(pollfds, nr_fds, 100);
+			err = fdarray__poll(fda, 100);
 	}
 
 	perf_evlist__disable(kvm->evlist);
-- 
1.9.3

