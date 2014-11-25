Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaKYNXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:23:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:35835 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaKYNXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:23:08 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/12] perf evsel: Introduce perf_evsel__read_cb function
Date: Tue, 25 Nov 2014 10:22:08 -0300
Message-Id: <1416921730-5063-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Adding perf_evsel__read_cb read function that retuns count values via
callback. It will be used later in stat command as single way to
retrieve counter values.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1416562275-12404-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

