Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaIJOg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaIJOg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:36:27 -0400
Date: Wed, 10 Sep 2014 16:35:35 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140910143535.GD2409@krava.brq.redhat.com>
References: <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908120140.GA17728@krava.brq.redhat.com>
 <20140908133428.GG6758@twins.programming.kicks-ass.net>
 <20140908151305.GU3588@twins.programming.kicks-ass.net>
 <20140908164524.GJ17728@krava.brq.redhat.com>
 <20140910135709.GB4783@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910135709.GB4783@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:57:09PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 06:45:24PM +0200, Jiri Olsa wrote:
> > 
> > now I need to recall what I used to test this ;-)
> > 
> 
> Hint, if you'd mentioned that in the changelog.... :-)

will try much better this time.. perf test attached ;-)
seems like the child state fix is a good one

jirka


---
>From dc1068c627b332b2a5feb4deedfd96db8e056b5f Mon Sep 17 00:00:00 2001
From: Jiri Olsa <jolsa@redhat.com>
Date: Wed, 10 Sep 2014 16:23:51 +0200
Subject: [PATCH] perf tests: Add test for optimized sched switch bug

---
 tools/perf/Makefile.perf            |    1 +
 tools/perf/tests/builtin-test.c     |    4 +
 tools/perf/tests/optimized_switch.c |  169 +++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h            |    1 +
 4 files changed, 175 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/tests/optimized_switch.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index da8fc07..75603ac 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -427,6 +427,7 @@ LIB_OBJS += $(OUTPUT)tests/mmap-thread-lookup.o
 LIB_OBJS += $(OUTPUT)tests/thread-mg-share.o
 LIB_OBJS += $(OUTPUT)tests/switch-tracking.o
 LIB_OBJS += $(OUTPUT)tests/xyarray.o
+LIB_OBJS += $(OUTPUT)tests/optimized_switch.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 5c90326..e092d17 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -162,6 +162,10 @@ static struct test {
 		.func = test__xyarray,
 	},
 	{
+		.desc = "Test optimized switch",
+		.func = test__optimized_switch,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/optimized_switch.c b/tools/perf/tests/optimized_switch.c
new file mode 100644
index 0000000..68f8705
--- /dev/null
+++ b/tools/perf/tests/optimized_switch.c
@@ -0,0 +1,169 @@
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/prctl.h>
+#include <linux/compiler.h>
+#include "tests.h"
+#include "debug.h"
+#include "evsel.h"
+#include "evlist.h"
+#include "thread_map.h"
+
+#define GROUPS	10
+#define WORKERS	10
+#define BYTES	100
+
+struct worker {
+	union {
+		int pipefd[2];
+		struct {
+			int read;
+			int write;
+		} fd;
+	};
+};
+
+#define pr_errsys(s) \
+	pr_err(s " failed: %s\n", strerror(errno))
+
+static void worker(int fd)
+{
+	unsigned char c = 0;
+	int cnt = BYTES;
+	ssize_t r;
+
+	while (cnt--) {
+		r = read(fd, &c, sizeof(c));
+		if (r != 1) {
+			pr_errsys("read");
+			exit(-1);
+		}
+	}
+
+	prctl(0, 0, 0, 0, 0);
+	exit(0);
+}
+
+static void write_round(struct worker *workers)
+{
+	unsigned char c = 0;
+	ssize_t r;
+	int i, j;
+
+	for (j = 0; j < BYTES; j++) {
+		for (i = 0; i < WORKERS; i++) {
+			struct worker *w = &workers[i];
+
+			r = write(w->fd.write, &c, sizeof(c));
+			if (r != 1) {
+				pr_errsys("write");
+				exit(-1);
+			}
+		}
+	}
+}
+
+static int group(void)
+{
+	struct worker workers[WORKERS];
+	int i;
+
+	for (i = 0; i < WORKERS; i++) {
+		struct worker *w = &workers[i];
+		int pid;
+
+		if (pipe(w->pipefd)) {
+			pr_errsys("pipe");
+			return -1;
+		}
+
+		pid = fork();
+		if (pid == -1) {
+			pr_errsys("fork");
+			return -1;
+		} else if (!pid) {
+			worker(w->fd.read);
+		}
+	}
+
+	write_round(workers);
+
+	for (i = 0; i < WORKERS; i++)
+		wait(NULL);
+
+	return 0;
+}
+
+static int child(void)
+{
+	int i;
+
+	for (i = 0; i < GROUPS; i++)
+		TEST_ASSERT_VAL("group failed", !group());
+
+	return 0;
+}
+
+int test__optimized_switch(void)
+{
+	ssize_t r __maybe_unused;
+	unsigned char c = 0;
+	int ready[2], pid;
+	struct thread_map *threads;
+	struct perf_evsel *evsel;
+	u64 total;
+
+	if (pipe(ready)) {
+		pr_errsys("pipe");
+		return -1;
+	}
+
+	pid = fork();
+	if (pid == -1) {
+		pr_errsys("fork");
+		return -1;
+	}
+
+	if (!pid) {
+		r = read(ready[0], &c, sizeof(c));
+		if (r != 1) {
+			pr_errsys("read");
+			exit(-1);
+		}
+
+		exit(child());
+	}
+
+	threads = thread_map__new(-1, pid, UINT_MAX);
+
+	evsel = perf_evsel__newtp("syscalls", "sys_enter_prctl");
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__open_per_thread failed\n");
+		return -1;
+	}
+
+	evsel->attr.inherit = 1;
+
+	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
+		pr_err("perf_evsel__newtp failed\n");
+		return -1;
+	}
+
+	r = write(ready[1], &c, sizeof(c));
+	if (r != 1) {
+		pr_errsys("write");
+		return -1;
+	}
+
+	wait(NULL);
+
+	if (perf_evsel__read_on_cpu(evsel, 0, 0) < 0) {
+		pr_err("perf_evsel__read_on_cpu failed\n");
+		return -1;
+	}
+
+	total = evsel->counts->cpu[0].val;
+
+	pr_debug("total count %lu, expected count %d\n", total, GROUPS * WORKERS);
+	TEST_ASSERT_VAL("wrong count", total == GROUPS * WORKERS);
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 8c3e7d1..466184b 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -50,6 +50,7 @@ int test__hists_output(void);
 int test__hists_cumulate(void);
 int test__switch_tracking(void);
 int test__xyarray(void);
+int test__optimized_switch(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
-- 
1.7.7.6

