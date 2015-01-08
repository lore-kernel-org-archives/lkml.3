Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbbAHMzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:55:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:35459 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbbAHMz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:55:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437999978"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V4 23/23] perf tools: Add build option NO_ITRACE to exclude Instruction Tracing
Date: Thu,  8 Jan 2015 14:52:27 +0200
Message-Id: <1420721547-26470-24-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
References: <1420721547-26470-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add build option NO_ITRACE to exclude compiling support
for Instruction Tracing. Support for both recording and
processing is excluded and by implication any future
additions such as Intel PT and Intel BTS will also not
be compiled in with this option.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile.perf    |   4 ++
 tools/perf/builtin-inject.c |  53 ++++++++++++--------
 tools/perf/builtin-record.c |  13 +++++
 tools/perf/config/Makefile  |   4 ++
 tools/perf/tests/make       |   2 +
 tools/perf/util/itrace.h    | 114 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 171 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index a126e7a..2c537aa 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -68,6 +68,8 @@ include config/utilities.mak
 # for reading the x32 mode 32-bit compatibility VDSO in 64-bit mode
 #
 # Define NO_ZLIB if you do not want to support compressed kernel modules
+#
+# Define NO_ITRACE if you do not want Instruction Tracing support
 
 
 ifeq ($(srctree),)
@@ -409,7 +411,9 @@ LIB_OBJS += $(OUTPUT)util/data.o
 LIB_OBJS += $(OUTPUT)util/tsc.o
 LIB_OBJS += $(OUTPUT)util/cloexec.o
 LIB_OBJS += $(OUTPUT)util/thread-stack.o
+ifndef NO_ITRACE
 LIB_OBJS += $(OUTPUT)util/itrace.o
+endif
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 285f159..e6a2136 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -53,25 +53,6 @@ static int output_bytes(struct perf_inject *inject, void *buf, size_t sz)
 	return 0;
 }
 
-static int copy_bytes(struct perf_inject *inject, int fd, off_t size)
-{
-	char buf[4096];
-	ssize_t ssz;
-	int ret;
-
-	while (size > 0) {
-		ssz = read(fd, buf, MIN(size, sizeof(buf)));
-		if (ssz < 0)
-			return -errno;
-		ret = output_bytes(inject, buf, ssz);
-		if (ret)
-			return ret;
-		size -= ssz;
-	}
-
-	return 0;
-}
-
 static int perf_event__repipe_synth(struct perf_tool *tool,
 				    union perf_event *event)
 {
@@ -107,6 +88,27 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	return perf_event__repipe_synth(tool, event);
 }
 
+#ifdef HAVE_ITRACE_SUPPORT
+
+static int copy_bytes(struct perf_inject *inject, int fd, off_t size)
+{
+	char buf[4096];
+	ssize_t ssz;
+	int ret;
+
+	while (size > 0) {
+		ssz = read(fd, buf, MIN(size, sizeof(buf)));
+		if (ssz < 0)
+			return -errno;
+		ret = output_bytes(inject, buf, ssz);
+		if (ret)
+			return ret;
+		size -= ssz;
+	}
+
+	return 0;
+}
+
 static s64 perf_event__repipe_itrace(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_session *session
@@ -146,6 +148,19 @@ static s64 perf_event__repipe_itrace(struct perf_tool *tool,
 	return event->itrace.size;
 }
 
+#else
+
+static s64
+perf_event__repipe_itrace(struct perf_tool *tool __maybe_unused,
+			  union perf_event *event __maybe_unused,
+			  struct perf_session *session __maybe_unused)
+{
+	pr_err("Instruction Tracing not supported\n");
+	return -EINVAL;
+}
+
+#endif
+
 static int perf_event__repipe(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __maybe_unused,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 182a42c..3ed5312 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -112,6 +112,8 @@ out:
 	return rc;
 }
 
+#ifdef HAVE_ITRACE_SUPPORT
+
 static int record__process_itrace(struct perf_tool *tool,
 				  union perf_event *event, void *data1,
 				  size_t len1, void *data2, size_t len2)
@@ -164,6 +166,17 @@ static int record__itrace_mmap_read(struct record *rec,
 	return 0;
 }
 
+#else
+
+static inline
+int record__itrace_mmap_read(struct record *rec __maybe_unused,
+			     struct itrace_mmap *mm __maybe_unused)
+{
+	return 0;
+}
+
+#endif
+
 static volatile int done = 0;
 static volatile int signr = -1;
 static volatile int child_finished = 0;
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039..ad33202 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -661,6 +661,10 @@ else
   NO_PERF_READ_VDSOX32 := 1
 endif
 
+ifndef NO_ITRACE
+  CFLAGS += -DHAVE_ITRACE_SUPPORT
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 75709d2..2677337 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -32,6 +32,7 @@ make_no_backtrace   := NO_BACKTRACE=1
 make_no_libnuma     := NO_LIBNUMA=1
 make_no_libaudit    := NO_LIBAUDIT=1
 make_no_libbionic   := NO_LIBBIONIC=1
+make_no_itrace      := NO_ITRACE=1
 make_tags           := tags
 make_cscope         := cscope
 make_help           := help
@@ -74,6 +75,7 @@ run += make_no_backtrace
 run += make_no_libnuma
 run += make_no_libaudit
 run += make_no_libbionic
+run += make_no_itrace
 run += make_help
 run += make_doc
 run += make_perf_o
diff --git a/tools/perf/util/itrace.h b/tools/perf/util/itrace.h
index 25e3540..233b378 100644
--- a/tools/perf/util/itrace.h
+++ b/tools/perf/util/itrace.h
@@ -25,6 +25,7 @@
 
 #include "../perf.h"
 #include "session.h"
+#include "debug.h"
 
 union perf_event;
 struct perf_session;
@@ -294,6 +295,8 @@ struct itrace_record {
 	int (*read_finish)(struct itrace_record *itr, int idx);
 };
 
+#ifdef HAVE_ITRACE_SUPPORT
+
 static inline u64 itrace_mmap__read_head(struct itrace_mmap *mm __maybe_unused)
 {
 	/* Not yet implemented */
@@ -444,4 +447,115 @@ static inline void itrace__free(struct perf_session *session)
 	return session->itrace->free(session);
 }
 
+#else
+
+static inline struct itrace_record *
+itrace_record__init(struct perf_evlist *evlist __maybe_unused,
+		    int *err __maybe_unused)
+{
+	*err = 0;
+	return NULL;
+}
+
+static inline
+void itrace_record__free(struct itrace_record *itr __maybe_unused)
+{
+}
+
+static inline int
+perf_event__synthesize_itrace_info(struct itrace_record *itr __maybe_unused,
+				   struct perf_tool *tool __maybe_unused,
+				   struct perf_session *session __maybe_unused,
+				   perf_event__handler_t process __maybe_unused)
+{
+	return -EINVAL;
+}
+
+static inline
+int itrace_record__options(struct itrace_record *itr __maybe_unused,
+			   struct perf_evlist *evlist __maybe_unused,
+			   struct record_opts *opts __maybe_unused)
+{
+	return 0;
+}
+
+#define perf_event__process_itrace_info			0
+#define perf_event__process_itrace			0
+#define perf_event__count_itrace_error			0
+#define perf_event__process_itrace_error		0
+
+static inline
+int itrace_parse_synth_opts(const struct option *opt __maybe_unused,
+			    const char *str __maybe_unused,
+			    int unset __maybe_unused)
+{
+	pr_err("Instruction Tracing not supported\n");
+	return -EINVAL;
+}
+
+static inline
+int itrace__process_event(struct perf_session *session __maybe_unused,
+			  union perf_event *event __maybe_unused,
+			  struct perf_sample *sample __maybe_unused,
+			  struct perf_tool *tool __maybe_unused)
+{
+	return 0;
+}
+
+static inline
+int itrace__flush_events(struct perf_session *session __maybe_unused,
+			 struct perf_tool *tool __maybe_unused)
+{
+	return 0;
+}
+
+static inline
+void itrace__free_events(struct perf_session *session __maybe_unused)
+{
+}
+
+static inline
+void itrace_cache__free(struct itrace_cache *itrace_cache __maybe_unused)
+{
+}
+
+static inline
+void itrace__free(struct perf_session *session __maybe_unused)
+{
+}
+
+static inline
+int itrace_index__write(int fd __maybe_unused,
+			struct list_head *head __maybe_unused)
+{
+	return -EINVAL;
+}
+
+static inline
+int itrace_index__process(int fd __maybe_unused,
+			  u64 size __maybe_unused,
+			  struct perf_session *session __maybe_unused,
+			  bool needs_swap __maybe_unused)
+{
+	return -EINVAL;
+}
+
+static inline
+void itrace_index__free(struct list_head *head __maybe_unused)
+{
+}
+
+int itrace_mmap__mmap(struct itrace_mmap *mm,
+		      struct itrace_mmap_params *mp,
+		      void *userpg, int fd);
+void itrace_mmap__munmap(struct itrace_mmap *mm);
+void itrace_mmap_params__init(struct itrace_mmap_params *mp,
+			      off_t itrace_offset,
+			      unsigned int itrace_pages, bool itrace_overwrite);
+void itrace_mmap_params__set_idx(struct itrace_mmap_params *mp,
+				 struct perf_evlist *evlist, int idx,
+				 bool per_cpu);
+
+#endif
+
 #endif
-- 
1.9.1

