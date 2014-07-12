Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaGLXuF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:50:05 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54203 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaGLXuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:50:02 -0400
Date: Sun, 13 Jul 2014 01:49:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/11] perf, tools, test: Add test case for alias and
 JSON parsing
Message-ID: <20140712234959.GY18735@two.firstfloor.org>
References: <1405123165-22666-1-git-send-email-andi@firstfloor.org>
 <1405123165-22666-11-git-send-email-andi@firstfloor.org>
 <20140712231005.GB29028@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712231005.GB29028@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> missing the tests/aliases.o file
> 
>   AR       libperf.a
> ar: tests/aliases.o: No such file or directory

Fixed here (and in git)

---

From: Andi Kleen <ak@linux.intel.com>

Add a simple test case to perf test that runs perf download and parses
all the available events, including json events.

This needs adding an all event iterator to pmu.c

v2: Rename identifiers
v3: Only iterate cpu pmu to avoid bogus errors.
Move pmu iterator to extra patch
v4: Include aliases.c again
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 0600425..6adb37f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -419,6 +419,7 @@ endif
 LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
+LIB_OBJS += $(OUTPUT)tests/aliases.o
 ifndef NO_DWARF_UNWIND
 ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
diff --git a/tools/perf/tests/aliases.c b/tools/perf/tests/aliases.c
new file mode 100644
index 0000000..08a5f01
--- /dev/null
+++ b/tools/perf/tests/aliases.c
@@ -0,0 +1,58 @@
+/* Check if we can set up all aliases and can read JSON files */
+#include <stdlib.h>
+#include "tests.h"
+#include "pmu.h"
+#include "evlist.h"
+#include "parse-events.h"
+
+static struct perf_evlist *evlist;
+
+static int num_events;
+static int failed;
+
+static int test__event(const char *pmu, const char *name)
+{
+	int ret;
+
+	/* Not supported for now */
+	if (strcmp(pmu, "cpu"))
+		return 0;
+
+	ret = parse_events(evlist, name);
+
+	if (ret) {
+		/*
+		 * We only print on failure because common perf setups
+		 * have events that cannot be parsed.
+		 */
+		fprintf(stderr, "invalid or unsupported event: '%s'\n", name);
+		ret = 0;
+		failed++;
+	} else
+		num_events++;
+	return ret;
+}
+
+int test__aliases(void)
+{
+	int err;
+
+	/* Download JSON files */
+	/* XXX assumes perf is installed */
+	/* For now user must manually download */
+	if (0 && system("perf download > /dev/null") < 0) {
+		/* Don't error out for this for now */
+		fprintf(stderr, "perf download failed\n");
+	}
+
+	evlist = perf_evlist__new();
+	if (evlist == NULL)
+		return -ENOMEM;
+
+	err = pmu_iterate_events(test__event);
+	fprintf(stderr, " Parsed %d events :", num_events);
+	if (failed > 0)
+		pr_debug(" %d events failed", failed);
+	perf_evlist__delete(evlist);
+	return err;
+}
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01b..bb37ac2 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -154,6 +154,10 @@ static struct test {
 		.func = test__hists_cumulate,
 	},
 	{
+		.desc = "Test parsing JSON aliases",
+		.func = test__aliases,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790..ab92ad9 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -48,6 +48,7 @@ int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 int test__hists_output(void);
 int test__hists_cumulate(void);
+int test__aliases(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
