Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaHVVAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:00:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:43289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaHVVAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:00:06 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/10] perf evlist: Introduce perf_evlist__filter_pollfd method
Date: Fri, 22 Aug 2014 17:59:41 -0300
Message-Id: <1408741190-5123-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408741190-5123-1-git-send-email-acme@kernel.org>
References: <1408741190-5123-1-git-send-email-acme@kernel.org>
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

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ki3oqbfjg84si3f9amhyqvzb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 16 ++++++++++++++++
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a3e28b49128a..bd7896073d10 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -428,6 +428,22 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
+int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
+{
+	int fd = 0, nr_fds = 0;
+
+	while (fd < evlist->nr_fds) {
+		if ((evlist->pollfd[fd].revents & revents_and_mask) == 0)
+			++nr_fds;
+
+		if (++fd != nr_fds)
+			evlist->pollfd[nr_fds] = evlist->pollfd[fd];
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

