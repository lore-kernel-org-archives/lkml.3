Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaJOKCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:02:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaJOKCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:02:10 -0400
Date: Wed, 15 Oct 2014 03:01:48 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1ca72260e471a8b03f03fe9a6547deb088710042@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, hpa@zytor.com,
        namhyung@kernel.org, acme@redhat.com, paulus@samba.org,
        dsahern@gmail.com, mail@milianw.de, jolsa@kernel.org, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, adrian.hunter@intel.com
Reply-To: mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        jolsa@kernel.org, cjashfor@linux.vnet.ibm.com, adrian.hunter@intel.com,
        hpa@zytor.com, acme@redhat.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, paulus@samba.org,
        mail@milianw.de, dsahern@gmail.com
In-Reply-To: <1412179229-19466-5-git-send-email-jolsa@kernel.org>
References: <1412179229-19466-5-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm stat live:
  Use fdarray object instead of pollfd
Git-Commit-ID: 1ca72260e471a8b03f03fe9a6547deb088710042
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

Commit-ID:  1ca72260e471a8b03f03fe9a6547deb088710042
Gitweb:     http://git.kernel.org/tip/1ca72260e471a8b03f03fe9a6547deb088710042
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 1 Oct 2014 18:00:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 3 Oct 2014 09:39:48 -0300

perf kvm stat live: Use fdarray object instead of pollfd

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
index dc7d704..460a4ce 100644
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
