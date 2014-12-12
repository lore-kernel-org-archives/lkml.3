Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965810AbaLLIUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:20:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414AbaLLIUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:20:37 -0500
Date: Fri, 12 Dec 2014 00:19:56 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-2g3gczfwyz0xt3we0s15mqqt@git.kernel.org>
Cc: paulus@samba.org, jolsa@redhat.com, mingo@kernel.org,
        adrian.hunter@intel.com, bp@suse.de, tglx@linutronix.de,
        peterz@infradead.org, namhyung@kernel.org, eranian@google.com,
        hpa@zytor.com, dzickus@redhat.com, acme@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org, efault@gmx.de
Reply-To: paulus@samba.org, jolsa@redhat.com, mingo@kernel.org,
        adrian.hunter@intel.com, bp@suse.de, peterz@infradead.org,
        tglx@linutronix.de, eranian@google.com, hpa@zytor.com,
        namhyung@kernel.org, dzickus@redhat.com, acme@redhat.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Introduce strerror_mmap method
Git-Commit-ID: 956fa57106d1ad3ffbe73f4534b9f3b3bc92dd6c
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

Commit-ID:  956fa57106d1ad3ffbe73f4534b9f3b3bc92dd6c
Gitweb:     http://git.kernel.org/tip/956fa57106d1ad3ffbe73f4534b9f3b3bc92dd6c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 11 Dec 2014 18:03:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 11 Dec 2014 18:03:01 -0300

perf evlist: Introduce strerror_mmap method

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
index cfbe2b9..bb5dfc5 100644
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
index 649b0c5..0ba93f6 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -185,6 +185,7 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__strerror_tp(struct perf_evlist *evlist, int err, char *buf, size_t size);
 int perf_evlist__strerror_open(struct perf_evlist *evlist, int err, char *buf, size_t size);
+int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, size_t size);
 
 static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 {
