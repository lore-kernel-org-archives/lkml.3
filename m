Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbaIZJUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:20:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaIZJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:20:32 -0400
Date: Fri, 26 Sep 2014 02:19:52 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-a4fslwspov0bs69nj825hqpq@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Monitor POLLERR and POLLHUP events too
Git-Commit-ID: 8179672c2f7b9c41a7ef3e8c907d214fa92ed614
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

Commit-ID:  8179672c2f7b9c41a7ef3e8c907d214fa92ed614
Gitweb:     http://git.kernel.org/tip/8179672c2f7b9c41a7ef3e8c907d214fa92ed614
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Aug 2014 11:26:21 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:54 -0300

perf evlist: Monitor POLLERR and POLLHUP events too

We want to know when the fd went away, like when a monitored thread
exits.

If we do not monitor such events, then the tools will wait forever on
events from a vanished thread, like when running:

 $ sleep 5s &
 $ perf record -p `pidof sleep`

This builds upon the kernel patch by Jiri Olsa that actually makes a
poll on those file descriptors to return POLLHUP.

It is also needed to change the tools to use
perf_evlist__filter_pollfd() to check if there are remainings fds to
monitor or if all are gone, in which case they will exit the
poll/mmap/read loop.

Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-a4fslwspov0bs69nj825hqpq@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 023bc38..502cd11 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -424,7 +424,7 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 {
 	fcntl(fd, F_SETFL, O_NONBLOCK);
 	evlist->pollfd[evlist->nr_fds].fd = fd;
-	evlist->pollfd[evlist->nr_fds].events = POLLIN;
+	evlist->pollfd[evlist->nr_fds].events = POLLIN | POLLERR | POLLHUP;
 	evlist->nr_fds++;
 }
 
