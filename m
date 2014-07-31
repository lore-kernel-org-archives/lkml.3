Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaGaGDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:03:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756339AbaGaGDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799941"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/31] perf evlist: Add perf_evlist__enable_event_idx()
Date: Thu, 31 Jul 2014 09:00:56 +0300
Message-Id: <1406786474-9306-14-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to enable a specific event
within a specific perf event buffer.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b08ad11..5a632bc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -355,6 +355,53 @@ int perf_evlist__enable_event(struct perf_evlist *evlist,
 	return 0;
 }
 
+static int perf_evlist__enable_event_cpu(struct perf_evlist *evlist,
+					 struct perf_evsel *evsel, int cpu)
+{
+	int thread, err;
+	int nr_threads = perf_evlist__nr_threads(evlist, evsel);
+
+	if (!evsel->fd)
+		return -EINVAL;
+
+	for (thread = 0; thread < nr_threads; thread++) {
+		err = ioctl(FD(evsel, cpu, thread),
+			    PERF_EVENT_IOC_ENABLE, 0);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+static int perf_evlist__enable_event_thread(struct perf_evlist *evlist,
+					    struct perf_evsel *evsel,
+					    int thread)
+{
+	int cpu, err;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+
+	if (!evsel->fd)
+		return -EINVAL;
+
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
+		err = ioctl(FD(evsel, cpu, thread), PERF_EVENT_IOC_ENABLE, 0);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+int perf_evlist__enable_event_idx(struct perf_evlist *evlist,
+				  struct perf_evsel *evsel, int idx)
+{
+	bool per_cpu_mmaps = !cpu_map__empty(evlist->cpus);
+
+	if (per_cpu_mmaps)
+		return perf_evlist__enable_event_cpu(evlist, evsel, idx);
+	else
+		return perf_evlist__enable_event_thread(evlist, evsel, idx);
+}
+
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nr_cpus = cpu_map__nr(evlist->cpus);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index e0084f9..106de53 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -122,6 +122,8 @@ int perf_evlist__disable_event(struct perf_evlist *evlist,
 			       struct perf_evsel *evsel);
 int perf_evlist__enable_event(struct perf_evlist *evlist,
 			      struct perf_evsel *evsel);
+int perf_evlist__enable_event_idx(struct perf_evlist *evlist,
+				  struct perf_evsel *evsel, int idx);
 
 void perf_evlist__set_selected(struct perf_evlist *evlist,
 			       struct perf_evsel *evsel);
-- 
1.8.3.2

