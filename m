Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbaLKV1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:27:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:44564 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965517AbaLKV1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:27:38 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/18] perf evlist: Introduce strerror_mmap method
Date: Thu, 11 Dec 2014 18:26:05 -0300
Message-Id: <1418333166-15429-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418333166-15429-1-git-send-email-acme@kernel.org>
References: <1418333166-15429-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To pretty print hints about perf_evlist__mmap errors. Will be used in
'trace' in the next patch.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-2g3gczfwyz0xt3we0s15mqqt@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 23 +++++++++++++++++++++++
 tools/perf/util/evlist.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cfbe2b99b9aa..bb5dfc5d1e75 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -8,6 +8,7 @@
  */
 #include "util.h"
 #include <api/fs/debugfs.h>
+#include <api/fs/fs.h>
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
@@ -1483,6 +1484,28 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 	return 0;
 }
 
+int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size)
+{
+	char sbuf[STRERR_BUFSIZE], *emsg = strerror_r(err, sbuf, sizeof(sbuf));
+	int value;
+
+	switch (err) {
+	case EPERM:
+		sysctl__read_int("kernel/perf_event_mlock_kb", &value);
+		scnprintf(buf, size, "Error:\t%s.\n"
+				     "Hint:\tCheck /proc/sys/kernel/perf_event_mlock_kb (%d kB) setting.\n"
+				     "Hint:\tTried using %zd kB.\n"
+				     "Hint:\tTry using a bigger -m/--mmap-pages value.",
+				     emsg, value, evlist->mmap_len / 1024);
+		break;
+	default:
+		scnprintf(buf, size, "%s", emsg);
+		break;
+	}
+
+	return 0;
+}
+
 void perf_evlist__to_front(struct perf_evlist *evlist,
 			   struct perf_evsel *move_evsel)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649b0c597283..0ba93f67ab94 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -185,6 +185,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
 int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
+int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size);
 
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
-- 
1.9.3

