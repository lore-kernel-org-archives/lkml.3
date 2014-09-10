Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbaIJOJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:09:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:38348 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaIJOJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:09:11 -0400
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
Subject: [PATCH 01/14] perf evlist: Introduce perf_evlist__filter_pollfd method
Date: Wed, 10 Sep 2014 11:08:36 -0300
Message-Id: <1410358129-9965-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To remove all entries in evlist->pollfd[] that have revents matching at
least one of the bits in the specified mask.

It'll adjust evlist->nr_fds to the number of unfiltered fds and will
return this value, as a convenience and to avoid requiring direct access
to internal state of perf_evlist objects.

This will be used after polling the evlist fds so that we remove fds
that were closed by the kernel.

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
Link: http://lkml.kernel.org/n/tip-y2sca7z3wicvvy40a50lozwm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 21 +++++++++++++++++++++
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a3e28b49128a..023bc3873ae9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -428,6 +428,27 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
+int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
+{
+	int fd, nr_fds = 0;
+
+	if (evlist->nr_fds == 0)
+		return 0;
+
+	for (fd = 0; fd < evlist->nr_fds; ++fd) {
+		if (evlist->pollfd[fd].revents & revents_and_mask)
+			continue;
+
+		if (fd != nr_fds)
+			evlist->pollfd[nr_fds] = evlist->pollfd[fd];
+
+		++nr_fds;
+	}
+
+	evlist->nr_fds = nr_fds;
+	return nr_fds;
+}
+
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
 				 struct perf_evsel *evsel,
 				 int cpu, int thread, u64 id)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 106de53a6a74..1082420951f9 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -84,6 +84,8 @@ void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
+int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask);
+
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
-- 
1.9.3

