Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaHNIxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:53:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36740 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbaHNIxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:53:05 -0400
Date: Thu, 14 Aug 2014 01:52:13 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-1c65056c547141a0cb52fb8e6056f63524d2bbf2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406786474-9306-14-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-14-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Add perf_evlist__enable_event_idx()
Git-Commit-ID: 1c65056c547141a0cb52fb8e6056f63524d2bbf2
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

Commit-ID:  1c65056c547141a0cb52fb8e6056f63524d2bbf2
Gitweb:     http://git.kernel.org/tip/1c65056c547141a0cb52fb8e6056f63524d2bbf2
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:56 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:23:48 -0300

perf evlist: Add perf_evlist__enable_event_idx()

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
index 9d863db..5dcd28c 100644
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
