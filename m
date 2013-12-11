Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab3LKMvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:51:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:64865 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab3LKMko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448280708"
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
Subject: [PATCH v0 34/71] perf evlist: Add perf_evlist__enable_event_idx()
Date: Wed, 11 Dec 2013 14:36:46 +0200
Message-Id: <1386765443-26966-35-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to enable a specific event
within a specific perf event buffer.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7ae3139..e750a21 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -350,6 +350,53 @@ int perf_evlist__enable_event(struct perf_evlist *evlist,
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
+				PERF_EVENT_IOC_ENABLE, 0);
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
index 2c8d068..f0ce3bf 100644
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
1.8.5.1

