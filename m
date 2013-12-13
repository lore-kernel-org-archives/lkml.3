Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab3LMPQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:16:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45275 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3LMPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/20] perf evlist: Add can_select_event() method
Date: Fri, 13 Dec 2013 12:11:50 -0300
Message-Id: <1386947526-7118-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to determine whether an event can be selected.

This function is needed to allow a tool to automatically select
additional events, but only if they are available.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386765443-26966-18-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.h |  2 ++
 tools/perf/util/record.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649d6ea98a84..8a04aae95a18 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -193,4 +193,6 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	pc->data_tail = tail;
 }
 
+bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index c8845b107f60..e5104538c354 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -177,3 +177,40 @@ int perf_record_opts__config(struct perf_record_opts *opts)
 {
 	return perf_record_opts__config_freq(opts);
 }
+
+bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
+{
+	struct perf_evlist *temp_evlist;
+	struct perf_evsel *evsel;
+	int err, fd, cpu;
+	bool ret = false;
+
+	temp_evlist = perf_evlist__new();
+	if (!temp_evlist)
+		return false;
+
+	err = parse_events(temp_evlist, str);
+	if (err)
+		goto out_delete;
+
+	evsel = perf_evlist__last(temp_evlist);
+
+	if (!evlist || cpu_map__empty(evlist->cpus)) {
+		struct cpu_map *cpus = cpu_map__new(NULL);
+
+		cpu =  cpus ? cpus->map[0] : 0;
+		cpu_map__delete(cpus);
+	} else {
+		cpu = evlist->cpus->map[0];
+	}
+
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	if (fd >= 0) {
+		close(fd);
+		ret = true;
+	}
+
+out_delete:
+	perf_evlist__delete(temp_evlist);
+	return ret;
+}
-- 
1.8.1.4

