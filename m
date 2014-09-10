Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaIJOJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:09:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:38422 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaIJOJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:09:36 -0400
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
Subject: [PATCH 04/14] perf evlist: We need to poll all event file descriptors
Date: Wed, 10 Sep 2014 11:08:39 -0300
Message-Id: <1410358129-9965-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Because we want to notice when they get POLLHUP'ed, so that we can
figure out when all threads exited in a workload being monitored.

We can't just monitor the fds that were mmaped, we need to notice when
all the fds that were PERF_EVENT_IOC_SET_OUTPUT'ed too, because the mmap
stays even after the fd that originally was used to do the mmap call
went away, its only when all the set-output fds for a mmap are gone that
the mmap is.

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
Link: http://lkml.kernel.org/r/20140908151016.GH17728@krava.brq.redhat.com
Link: http://lkml.kernel.org/n/tip-24omlq5asrfg4uo3muuzn2bl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 502cd11ab17e..6b13bfa7ac2c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -717,8 +717,6 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 		evlist->mmap[idx].base = NULL;
 		return -1;
 	}
-
-	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
 
@@ -745,6 +743,8 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 				return -1;
 		}
 
+		perf_evlist__add_pollfd(evlist, fd);
+
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
 			return -1;
-- 
1.9.3

