Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaHKIuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:50:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaHKIut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:50:49 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/20] perf tools: Introduce perf_evsel__fd function
Date: Mon, 11 Aug 2014 10:49:59 +0200
Message-Id: <1407747014-18394-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm about to make the fd entry more complex, so adding
perf_evsel__fd helper to keep the FD macro sane.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evlist.c | 2 +-
 tools/perf/util/evsel.c  | 2 +-
 tools/perf/util/evsel.h  | 5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3b366c085021..4e0f0670b655 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -25,7 +25,7 @@
 #include <linux/bitops.h>
 #include <linux/hash.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define FD(e, x, y) (*perf_evsel__fd(e, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
 
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0c8919decac8..1ec1a7ec1cfb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -32,7 +32,7 @@ static struct {
 	bool cloexec;
 } perf_missing_features;
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define FD(e, x, y) (*perf_evsel__fd(e, x, y))
 
 int __perf_evsel__sample_size(u64 sample_type)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index d7f93ce0ebc1..fe8794fa73ed 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -364,4 +364,9 @@ for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
      (_evsel) && (_evsel)->leader == (_leader);					\
      (_evsel) = list_entry((_evsel)->node.next, struct perf_evsel, node))
 
+static inline int *perf_evsel__fd(struct perf_evsel *evsel, int cpu, int thread)
+{
+	return (int *) xyarray__entry(evsel->fd, cpu, thread);
+}
+
 #endif /* __PERF_EVSEL_H */
-- 
1.8.3.1

