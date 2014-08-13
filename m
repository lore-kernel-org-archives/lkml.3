Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaHMWvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:51:41 -0400
Received: from mail.kernel.org ([198.145.19.201]:55802 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbaHMWvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:36 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 41/41] perf evlist: Add perf_evlist__enable_event_idx()
Date: Wed, 13 Aug 2014 19:48:27 -0300
Message-Id: <1407970107-24540-42-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to enable a specific event within a specific perf event
buffer.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-14-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 49 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 9d863db3f4b2..5dcd28c79c6e 100644
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
index e0084f90c271..106de53a6a74 100644
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
1.9.3

