Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3LKMj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:60200 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab3LKMjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442368514"
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
Subject: [PATCH v0 20/71] perf tools: Move mem_bswap32/64 to util.c
Date: Wed, 11 Dec 2013 14:36:32 +0200
Message-Id: <1386765443-26966-21-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Move functions mem_bswap_32() and mem_bswap_64()
so they can be reused.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 21 ---------------------
 tools/perf/util/session.h |  2 --
 tools/perf/util/util.c    | 22 ++++++++++++++++++++++
 tools/perf/util/util.h    |  3 +++
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 10ac07a..6bfb36b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -247,27 +247,6 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 	}
 }
  
-void mem_bswap_32(void *src, int byte_size)
-{
-	u32 *m = src;
-	while (byte_size > 0) {
-		*m = bswap_32(*m);
-		byte_size -= sizeof(u32);
-		++m;
-	}
-}
-
-void mem_bswap_64(void *src, int byte_size)
-{
-	u64 *m = src;
-
-	while (byte_size > 0) {
-		*m = bswap_64(*m);
-		byte_size -= sizeof(u64);
-		++m;
-	}
-}
-
 static void swap_sample_id_all(union perf_event *event, void *data)
 {
 	void *end = (void *) event + event->header.size;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ca1d734..69e3bad 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -76,8 +76,6 @@ int perf_session__resolve_callchain(struct perf_session *session,
 
 bool perf_session__has_traces(struct perf_session *session, const char *msg);
 
-void mem_bswap_64(void *src, int byte_size);
-void mem_bswap_32(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *session);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 3aed4af..6df02a9 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <errno.h>
 #include <limits.h>
+#include <byteswap.h>
 #include <linux/kernel.h>
 
 /*
@@ -501,3 +502,24 @@ int perf_event_paranoid(void)
 
 	return value;
 }
+
+void mem_bswap_32(void *src, int byte_size)
+{
+	u32 *m = src;
+	while (byte_size > 0) {
+		*m = bswap_32(*m);
+		byte_size -= sizeof(u32);
+		++m;
+	}
+}
+
+void mem_bswap_64(void *src, int byte_size)
+{
+	u64 *m = src;
+
+	while (byte_size > 0) {
+		*m = bswap_64(*m);
+		byte_size -= sizeof(u64);
+		++m;
+	}
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 4b6b260..24da45e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -312,4 +312,7 @@ int filename__read_str(const char *filename, char **buf, size_t *sizep);
 
 int perf_event_paranoid(void);
 
+void mem_bswap_64(void *src, int byte_size);
+void mem_bswap_32(void *src, int byte_size);
+
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.5.1

