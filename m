Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaIJOJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:09:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:38399 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaIJOJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:09:28 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/14] perf evlist: Monitor POLLERR and POLLHUP events too
Date: Wed, 10 Sep 2014 11:08:38 -0300
Message-Id: <1410358129-9965-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 023bc3873ae9..502cd11ab17e 100644
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
 
-- 
1.9.3

