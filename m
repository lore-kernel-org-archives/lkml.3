Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3LMPNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:13:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45295 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3LMPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:23 -0500
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
Subject: [PATCH 05/20] perf tools: Move mem_bswap32/64 to util.c
Date: Fri, 13 Dec 2013 12:11:51 -0300
Message-Id: <1386947526-7118-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Move functions mem_bswap_32() and mem_bswap_64() so they can be reused.

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
Link: http://lkml.kernel.org/r/1386765443-26966-21-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 21 ---------------------
 tools/perf/util/session.h |  2 --
 tools/perf/util/util.c    | 22 ++++++++++++++++++++++
 tools/perf/util/util.h    |  3 +++
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e748f29c53cf..989b2e377626 100644
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
index 2a3955ea4fd8..9c25d49900af 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -74,8 +74,6 @@ int perf_session__resolve_callchain(struct perf_session *session,
 
 bool perf_session__has_traces(struct perf_session *session, const char *msg);
 
-void mem_bswap_64(void *src, int byte_size);
-void mem_bswap_32(void *src, int byte_size);
 void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *session);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8f63dba212d7..42ad667bb317 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <errno.h>
 #include <limits.h>
+#include <byteswap.h>
 #include <linux/kernel.h>
 
 /*
@@ -515,3 +516,24 @@ int perf_event_paranoid(void)
 
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
index 1e7d4136cc82..a1eea3e809a3 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -323,5 +323,8 @@ int filename__read_int(const char *filename, int *value);
 int filename__read_str(const char *filename, char **buf, size_t *sizep);
 int perf_event_paranoid(void);
 
+void mem_bswap_64(void *src, int byte_size);
+void mem_bswap_32(void *src, int byte_size);
+
 const char *get_filename_for_perf_kvm(void);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

