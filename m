Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3HaIOv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:14:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3HaIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:14:45 -0400
Date: Sat, 31 Aug 2013 01:14:04 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-faf967068e8c4d8df52f01f9361241101b3065a0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        namhyung@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-7-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-7-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Move perf_evlist__config()
  to a new source file
Git-Commit-ID: faf967068e8c4d8df52f01f9361241101b3065a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:14:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  faf967068e8c4d8df52f01f9361241101b3065a0
Gitweb:     http://git.kernel.org/tip/faf967068e8c4d8df52f01f9361241101b3065a0
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:08 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 15:49:10 -0300

perf evlist: Move perf_evlist__config() to a new source file

perf_evlist__config() must be moved to a separate source file to avoid
Python link errors when adding support for PERF_SAMPLE_IDENTIFIER.

It is appropriate to do this because perf_evlist__config() is a helper
function for event recording.  It is used by tools to apply recording
options to perf_evlist.  It is not used by the Python API.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |  1 +
 tools/perf/util/evlist.c | 22 ----------------------
 tools/perf/util/record.c | 25 +++++++++++++++++++++++++
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7d30a7d..845cc76 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -360,6 +360,7 @@ LIB_OBJS += $(OUTPUT)util/rblist.o
 LIB_OBJS += $(OUTPUT)util/intlist.o
 LIB_OBJS += $(OUTPUT)util/vdso.o
 LIB_OBJS += $(OUTPUT)util/stat.o
+LIB_OBJS += $(OUTPUT)util/record.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1f5105a..9d682e5 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -49,28 +49,6 @@ struct perf_evlist *perf_evlist__new(void)
 	return evlist;
 }
 
-void perf_evlist__config(struct perf_evlist *evlist,
-			struct perf_record_opts *opts)
-{
-	struct perf_evsel *evsel;
-	/*
-	 * Set the evsel leader links before we configure attributes,
-	 * since some might depend on this info.
-	 */
-	if (opts->group)
-		perf_evlist__set_leader(evlist);
-
-	if (evlist->cpus->map[0] < 0)
-		opts->no_inherit = true;
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts);
-
-		if (evlist->nr_entries > 1)
-			perf_evsel__set_sample_id(evsel);
-	}
-}
-
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
new file mode 100644
index 0000000..9b5ef79
--- /dev/null
+++ b/tools/perf/util/record.c
@@ -0,0 +1,25 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "cpumap.h"
+
+void perf_evlist__config(struct perf_evlist *evlist,
+			struct perf_record_opts *opts)
+{
+	struct perf_evsel *evsel;
+	/*
+	 * Set the evsel leader links before we configure attributes,
+	 * since some might depend on this info.
+	 */
+	if (opts->group)
+		perf_evlist__set_leader(evlist);
+
+	if (evlist->cpus->map[0] < 0)
+		opts->no_inherit = true;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__config(evsel, opts);
+
+		if (evlist->nr_entries > 1)
+			perf_evsel__set_sample_id(evsel);
+	}
+}
