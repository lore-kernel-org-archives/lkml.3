Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3GPGc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:32:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:50769 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab3GPGcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:32:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,675,1367996400"; 
   d="scan'208";a="365882854"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V6 12/12] perf tools: add a sample parsing test
Date: Tue, 16 Jul 2013 09:38:18 +0300
Message-Id: <1373956698-27540-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
References: <1373956698-27540-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a test that checks that sample parsing is correctly
implemented.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Makefile               |   1 +
 tools/perf/tests/builtin-test.c   |   4 +
 tools/perf/tests/sample-parsing.c | 240 ++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h          |   1 +
 4 files changed, 246 insertions(+)
 create mode 100644 tools/perf/tests/sample-parsing.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5b7c6db..fe20130 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -389,6 +389,7 @@ LIB_OBJS += $(OUTPUT)tests/bp_signal.o
 LIB_OBJS += $(OUTPUT)tests/bp_signal_overflow.o
 LIB_OBJS += $(OUTPUT)tests/task-exit.o
 LIB_OBJS += $(OUTPUT)tests/sw-clock.o
+LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
 BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 35b45f1466..5ee3933 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -94,6 +94,10 @@ static struct test {
 		.func = test__sw_clock_freq,
 	},
 	{
+		.desc = "Test sample parsing",
+		.func = test__sample_parsing,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
new file mode 100644
index 0000000..c6e6813
--- /dev/null
+++ b/tools/perf/tests/sample-parsing.c
@@ -0,0 +1,240 @@
+#include <stdbool.h>
+#include <inttypes.h>
+
+#include "event.h"
+#include "evsel.h"
+
+#include "tests.h"
+
+#define COMP(m) {					\
+	while (s1->m != s2->m) {			\
+		pr_debug("Samples differ at '"#m"'\n");	\
+		return false;				\
+	}						\
+}
+
+#define MCOMP(m) {					\
+	while (memcmp(&s1->m, &s2->m, sizeof(s1->m))) {	\
+		pr_debug("Samples differ at '"#m"'\n");	\
+		return false;				\
+	}						\
+}
+
+static bool samples_same(const struct perf_sample *s1,
+			 const struct perf_sample *s2, u64 type, u64 regs_user)
+{
+	size_t i;
+
+	if (type & PERF_SAMPLE_IDENTIFIER)
+		COMP(id);
+
+	if (type & PERF_SAMPLE_IP)
+		COMP(ip);
+
+	if (type & PERF_SAMPLE_TID) {
+		COMP(pid);
+		COMP(tid);
+	}
+
+	if (type & PERF_SAMPLE_TIME)
+		COMP(time);
+
+	if (type & PERF_SAMPLE_ADDR)
+		COMP(addr);
+
+	if (type & PERF_SAMPLE_ID)
+		COMP(id);
+
+	if (type & PERF_SAMPLE_STREAM_ID)
+		COMP(stream_id);
+
+	if (type & PERF_SAMPLE_CPU)
+		COMP(cpu);
+
+	if (type & PERF_SAMPLE_PERIOD)
+		COMP(period);
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		COMP(callchain->nr);
+		for (i = 0; i < s1->callchain->nr; i++)
+			COMP(callchain->ips[i]);
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		COMP(raw_size);
+		if (memcmp(s1->raw_data, s2->raw_data, s1->raw_size)) {
+			pr_debug("Samples differ at 'raw_data'\n");
+			return false;
+		}
+	}
+
+	if (type & PERF_SAMPLE_BRANCH_STACK) {
+		COMP(branch_stack->nr);
+		for (i = 0; i < s1->branch_stack->nr; i++)
+			MCOMP(branch_stack->entries[i]);
+	}
+
+	if (type & PERF_SAMPLE_REGS_USER) {
+		size_t sz = hweight_long(regs_user) * sizeof(u64);
+
+		if ((sz && (!s1->user_regs.regs || !s2->user_regs.regs)) ||
+		    memcmp(s1->user_regs.regs, s2->user_regs.regs, sz)) {
+			pr_debug("Samples differ at 'user_regs'\n");
+			return false;
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK_USER) {
+		COMP(user_stack.size);
+		if (memcmp(s1->user_stack.data, s1->user_stack.data,
+			   s1->user_stack.size)) {
+			pr_debug("Samples differ at 'user_stack'\n");
+			return false;
+		}
+	}
+
+	if (type & PERF_SAMPLE_WEIGHT)
+		COMP(weight);
+
+	if (type & PERF_SAMPLE_DATA_SRC)
+		COMP(data_src);
+
+	return true;
+}
+
+static int do_test(u64 sample_type, u64 sample_regs_user)
+{
+	struct perf_evsel evsel = {
+		.needs_swap = false,
+		.attr = {
+			.sample_type = sample_type,
+			.sample_regs_user = sample_regs_user,
+		},
+	};
+	union perf_event event = {
+		.header = {
+			.type = PERF_RECORD_SAMPLE,
+			.size = sizeof(union perf_event),
+		},
+	};
+	union {
+		struct ip_callchain callchain;
+		u64 data[64];
+	} callchain = {
+		/* 3 ips */
+		.data = {3, 201, 202, 203},
+	};
+	union {
+		struct branch_stack branch_stack;
+		u64 data[64];
+	} branch_stack = {
+		/* 1 branch_entry */
+		.data = {1, 211, 212, 213},
+	};
+	u64 user_regs[64];
+	const u64 raw_data[] = {0x123456780a0b0c0dULL, 0x1102030405060708ULL};
+	const u64 data[] = {0x2211443366558877ULL, 0, 0xaabbccddeeff4321ULL};
+	const struct perf_sample sample = {
+		.ip		= 101,
+		.pid		= 102,
+		.tid		= 103,
+		.time		= 104,
+		.addr		= 105,
+		.id		= 106,
+		.stream_id	= 107,
+		.period		= 108,
+		.weight		= 109,
+		.cpu		= 110,
+		.raw_size	= sizeof(raw_data),
+		.data_src	= 111,
+		.raw_data	= (void *)raw_data,
+		.callchain	= &callchain.callchain,
+		.branch_stack	= &branch_stack.branch_stack,
+		.user_regs	= {
+			.regs	= user_regs,
+		},
+		.user_stack	= {
+			.size	= sizeof(data),
+			.data	= (void *)data,
+		},
+	};
+	struct perf_sample sample_out;
+	size_t i;
+	int err;
+
+	for (i = 0; i < sizeof(user_regs); i++)
+		*(u8 *)user_regs = i;
+
+	err = perf_event__synthesize_sample(&event, sample_type,
+					    sample_regs_user, &sample, false);
+	if (err) {
+		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
+			 "perf_event__synthesize_sample", sample_type, err);
+		return -1;
+	}
+
+	evsel.sample_size = __perf_evsel__sample_size(sample_type);
+
+	err = perf_evsel__parse_sample(&evsel, &event, &sample_out);
+	if (err) {
+		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
+			 "perf_evsel__parse_sample", sample_type, err);
+		return -1;
+	}
+
+	if (!samples_same(&sample, &sample_out, sample_type,
+			  sample_regs_user)) {
+		pr_debug("parsing failed for sample_type %#"PRIx64"\n",
+			 sample_type);
+		return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * test__sample_parsing - test sample parsing.
+ *
+ * This function implements a test that synthesizes a sample event, parses it
+ * and then checks that the parsed sample matches the original sample.  The test
+ * checks sample format bits separately and together.  If the test passes %0 is
+ * returned, otherwise %-1 is returned.
+ */
+int test__sample_parsing(void)
+{
+	u64 sample_type;
+	u64 sample_regs_user;
+	int err;
+
+	/*
+	 * Fail the test if it has not been updated when new sample format bits
+	 * were added.
+	 */
+	if (PERF_SAMPLE_MAX > PERF_SAMPLE_IDENTIFIER << 1) {
+		pr_debug("sample format has changed - test needs updating\n");
+		return -1;
+	}
+
+	/* Test each sample format bit separately */
+	for (sample_type = 1; sample_type != PERF_SAMPLE_MAX;
+	     sample_type <<= 1) {
+		if (sample_type == PERF_SAMPLE_READ)
+			continue;
+		if (sample_type == PERF_SAMPLE_REGS_USER)
+			sample_regs_user = 0x3fff;
+		else
+			sample_regs_user = 0;
+		err = do_test(sample_type, sample_regs_user);
+		if (err)
+			return err;
+	}
+
+	/* Test all sample format bits together */
+	sample_type = (PERF_SAMPLE_MAX - 1) & (~PERF_SAMPLE_READ);
+	sample_regs_user = 0x3fff;
+	err = do_test(sample_type, sample_regs_user);
+	if (err)
+		return err;
+
+	return 0;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 07a92f9..90e3056 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -35,5 +35,6 @@ int test__bp_signal(void);
 int test__bp_signal_overflow(void);
 int test__task_exit(void);
 int test__sw_clock_freq(void);
+int test__sample_parsing(void);
 
 #endif /* TESTS_H */
-- 
1.7.11.7

