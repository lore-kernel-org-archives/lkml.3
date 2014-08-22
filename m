Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbaHVNGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbaHVNF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:05:59 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/5] perf tools: Add support to traverse xyarrays
Date: Fri, 22 Aug 2014 15:05:16 +0200
Message-Id: <1408712718-19656-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
References: <1408712718-19656-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding xyarray__for_each define to allow sequentially
traverse xyarrays. It will be handy in following patch.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf        |  1 +
 tools/perf/tests/builtin-test.c |  4 ++++
 tools/perf/tests/tests.h        |  1 +
 tools/perf/tests/xyarray.c      | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/xyarray.c       |  4 +++-
 tools/perf/util/xyarray.h       |  6 ++++++
 6 files changed, 48 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/tests/xyarray.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1ea31e275b4d..555acea22f20 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -425,6 +425,7 @@ endif
 endif
 LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
+LIB_OBJS += $(OUTPUT)tests/xyarray.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 99481361b19f..43d40273565f 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test xyarray",
+		.func = test__xyarray,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790a395f..d11378f04126 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__xyarray(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
diff --git a/tools/perf/tests/xyarray.c b/tools/perf/tests/xyarray.c
new file mode 100644
index 000000000000..e1a1d6a45106
--- /dev/null
+++ b/tools/perf/tests/xyarray.c
@@ -0,0 +1,33 @@
+#include "tests.h"
+#include "xyarray.h"
+#include "debug.h"
+
+struct krava {
+	int a;
+};
+
+#define X 100
+#define Y 100
+
+int test__xyarray(void)
+{
+	struct xyarray *a;
+	struct krava *k;
+	int x, y;
+
+	a = xyarray__new(X, Y, sizeof(struct krava));
+	TEST_ASSERT_VAL("failed to allocate xyarray", a);
+
+	for (x = 0; x < X; x++) {
+		for (y = 0; y < Y; y++) {
+			k = xyarray__entry(a, x, y);
+			k->a = x * X + y;
+		}
+	}
+
+	y = 0;
+	xyarray__for_each(a, k)
+		TEST_ASSERT_VAL("wrong array value", k->a == y++);
+
+	return 0;
+}
diff --git a/tools/perf/util/xyarray.c b/tools/perf/util/xyarray.c
index 22afbf6c536a..077e8240fe98 100644
--- a/tools/perf/util/xyarray.c
+++ b/tools/perf/util/xyarray.c
@@ -4,11 +4,13 @@
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size)
 {
 	size_t row_size = ylen * entry_size;
-	struct xyarray *xy = zalloc(sizeof(*xy) + xlen * row_size);
+	size_t size = xlen * row_size;
+	struct xyarray *xy = zalloc(sizeof(*xy) + size);
 
 	if (xy != NULL) {
 		xy->entry_size = entry_size;
 		xy->row_size   = row_size;
+		xy->size       = size;
 	}
 
 	return xy;
diff --git a/tools/perf/util/xyarray.h b/tools/perf/util/xyarray.h
index c488a07275dd..e4efa075fd76 100644
--- a/tools/perf/util/xyarray.h
+++ b/tools/perf/util/xyarray.h
@@ -6,6 +6,7 @@
 struct xyarray {
 	size_t row_size;
 	size_t entry_size;
+	size_t size;
 	char contents[];
 };
 
@@ -17,4 +18,9 @@ static inline void *xyarray__entry(struct xyarray *xy, int x, int y)
 	return &xy->contents[x * xy->row_size + y * xy->entry_size];
 }
 
+#define xyarray__for_each(array, entry)					\
+	for (entry = (void *) &array->contents[0];			\
+	     (void *) entry < ((void *) array->contents + array->size);	\
+	     entry++)
+
 #endif /* _PERF_XYARRAY_H_ */
-- 
1.8.3.1

