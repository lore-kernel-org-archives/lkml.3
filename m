Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaGOAcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:32:10 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51813 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaGOAbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:31:55 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH v2 3/5] perf tools: add core support for sampling intr machine state regs
Date: Tue, 15 Jul 2014 02:31:42 +0200
Message-Id: <1405384304-26816-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405384304-26816-1-git-send-email-eranian@google.com>
References: <1405384304-26816-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the infrastructure to setup, collect and report the interrupt
machine state regs which can be captured by the kernel.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/perf.h         |    1 +
 tools/perf/util/event.h   |    1 +
 tools/perf/util/evsel.c   |   46 ++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/session.c |   44 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 510c65f..309d956 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -54,6 +54,7 @@ struct record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     sample_intr_regs;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index e5dd40a..4e36967 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -160,6 +160,7 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
+	struct regs_dump  intr_regs;
 	struct stack_dump user_stack;
 	struct sample_read read;
 };
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8606175..2ba3403 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -626,6 +626,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->call_graph_enabled)
 		perf_evsel__config_callgraph(evsel, opts);
 
+	if (opts->sample_intr_regs) {
+		attr->sample_regs_intr = PERF_REGS_MASK;
+		perf_evsel__set_sample_bit(evsel, REGS_INTR);
+	}
+
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
@@ -979,6 +984,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR_X64(branch_sample_type);
 	ret += PRINT_ATTR_X64(sample_regs_user);
 	ret += PRINT_ATTR_U32(sample_stack_user);
+	ret += PRINT_ATTR_X64(sample_regs_intr);
 
 	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
 
@@ -1468,6 +1474,23 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 	}
 
+	data->intr_regs.abi = PERF_SAMPLE_REGS_ABI_NONE;
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		OVERFLOW_CHECK_u64(array);
+		data->intr_regs.abi = *array;
+		array++;
+
+		if (data->intr_regs.abi != PERF_SAMPLE_REGS_ABI_NONE) {
+			u64 mask = evsel->attr.sample_regs_intr;
+
+			sz = hweight_long(mask) * sizeof(u64);
+			OVERFLOW_CHECK(array, sz, max_size);
+			data->intr_regs.mask = mask;
+			data->intr_regs.regs = (u64 *)array;
+			array = (void *)array + sz;
+		}
+	}
+
 	return 0;
 }
 
@@ -1563,6 +1586,16 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_TRANSACTION)
 		result += sizeof(u64);
 
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		if (sample->intr_regs.abi) {
+			result += sizeof(u64);
+			sz = hweight_long(sample->intr_regs.mask) * sizeof(u64);
+			result += sz;
+		} else {
+			result += sizeof(u64);
+		}
+	}
+
 	return result;
 }
 
@@ -1741,6 +1774,17 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_REGS_INTR) {
+		if (sample->intr_regs.abi) {
+			*array++ = sample->intr_regs.abi;
+			sz = hweight_long(sample->intr_regs.mask) * sizeof(u64);
+			memcpy(array, sample->intr_regs.regs, sz);
+			array = (void *)array + sz;
+		} else {
+			*array++ = 0;
+		}
+	}
+
 	return 0;
 }
 
@@ -1870,7 +1914,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
-		bit_name(IDENTIFIER),
+		bit_name(IDENTIFIER), bit_name(REGS_INTR),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64a186e..9da3eda 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -702,15 +702,46 @@ static void regs_dump__printf(u64 mask, u64 *regs)
 	}
 }
 
+static const char *regs_abi[]= {
+ [PERF_SAMPLE_REGS_ABI_NONE] = "none",
+ [PERF_SAMPLE_REGS_ABI_32] = "32-bit",
+ [PERF_SAMPLE_REGS_ABI_64] = "64-bit",
+};
+
+static inline const char *regs_dump_abi(struct regs_dump *d)
+{
+	if (d->abi > PERF_SAMPLE_REGS_ABI_64)
+		return "unknown";
+
+	return regs_abi[d->abi];
+}
+
+static void regs__printf(const char *type, struct regs_dump *regs)
+{
+	u64 mask = regs->mask;
+
+	printf("... %s regs: mask 0x%" PRIx64 " ABI %s\n",
+	       type,
+	       mask,
+	       regs_dump_abi(regs));
+
+	regs_dump__printf(mask, regs->regs);
+}
+
 static void regs_user__printf(struct perf_sample *sample)
 {
 	struct regs_dump *user_regs = &sample->user_regs;
 
-	if (user_regs->regs) {
-		u64 mask = user_regs->mask;
-		printf("... user regs: mask 0x%" PRIx64 "\n", mask);
-		regs_dump__printf(mask, user_regs->regs);
-	}
+	if (user_regs->regs)
+		regs__printf("user", user_regs);
+}
+
+static void regs_intr__printf(struct perf_sample *sample)
+{
+	struct regs_dump *intr_regs = &sample->intr_regs;
+
+	if (intr_regs->regs)
+		regs__printf("intr", intr_regs);
 }
 
 static void stack_user__printf(struct stack_dump *dump)
@@ -809,6 +840,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (sample_type & PERF_SAMPLE_REGS_USER)
 		regs_user__printf(sample);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		regs_intr__printf(sample);
+
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
 
-- 
1.7.9.5

