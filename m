Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbaKUJcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:32:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbaKUJb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:31:57 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/11] perf tools: Introduce perf_evsel__read_cb function
Date: Fri, 21 Nov 2014 10:31:07 +0100
Message-Id: <1416562275-12404-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_evsel__read_cb read function that retuns count
values via callback. It will be used later in stat command
as single way to retrieve counter values.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c | 16 ++++++++++++++++
 tools/perf/util/evsel.h |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6dc7a67e6d35..2d26b7ad6fe0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -917,6 +917,22 @@ void perf_counts_values__scale(struct perf_counts_values *count,
 		*pscaled = scaled;
 }
 
+int perf_evsel__read_cb(struct perf_evsel *evsel, int cpu, int thread,
+			perf_evsel__read_cb_t cb)
+{
+	struct perf_counts_values count;
+
+	memset(&count, 0, sizeof(count));
+
+	if (FD(evsel, cpu, thread) < 0)
+		return -EINVAL;
+
+	if (readn(FD(evsel, cpu, thread), &count, sizeof(count)) < 0)
+		return -errno;
+
+	return cb(evsel, cpu, thread, &count);
+}
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7af0377ceb18..5c93bed8e8d9 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -233,6 +233,13 @@ static inline bool perf_evsel__match2(struct perf_evsel *e1,
 	 (a)->attr.type == (b)->attr.type &&	\
 	 (a)->attr.config == (b)->attr.config)
 
+typedef int (perf_evsel__read_cb_t)(struct perf_evsel *evsel,
+				    int cpu, int thread,
+				    struct perf_counts_values *count);
+
+int perf_evsel__read_cb(struct perf_evsel *evsel, int cpu, int thread,
+			perf_evsel__read_cb_t cb);
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale);
 
-- 
1.9.3

