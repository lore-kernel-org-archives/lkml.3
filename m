Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab3LKMjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:64824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab3LKMjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450497541"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 17/71] perf tools: Add perf_evlist__can_select_event()
Date: Wed, 11 Dec 2013 14:36:29 +0200
Message-Id: <1386765443-26966-18-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to determine whether an event can be
selected.

This function is needed to allow a tool to automatically
select additional events, but only if they are available.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.h |  2 ++
 tools/perf/util/record.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649d6ea..8a04aae 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -193,4 +193,6 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	pc->data_tail = tail;
 }
 
+bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index c8845b1..e510453 100644
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
1.8.5.1

