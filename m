Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaIXLtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:49:41 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37486 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXLti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:49:38 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, cebbert.lkml@gmail.com
Subject: [PATCH v7 3/6] perf tools: add core support for sampling intr machine state regs
Date: Wed, 24 Sep 2014 13:48:39 +0200
Message-Id: <1411559322-16548-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411559322-16548-1-git-send-email-eranian@google.com>
References: <1411559322-16548-1-git-send-email-eranian@google.com>
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
 tools/perf/util/header.c  |    1 +
 tools/perf/util/session.c |   44 ++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 87 insertions(+), 6 deletions(-)

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
index 7eb7107..d6e79f3 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -162,6 +162,7 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
+	struct regs_dump  intr_regs;
 	struct stack_dump user_stack;
 	struct sample_read read;
 };
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b38de58..5c2e784 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -628,6 +628,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->call_graph_enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel, opts);
 
+	if (opts->sample_intr_regs) {
+		attr->sample_regs_intr = PERF_REGS_MASK;
+		perf_evsel__set_sample_bit(evsel, REGS_INTR);
+	}
+
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
@@ -1005,6 +1010,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR_X64(branch_sample_type);
 	ret += PRINT_ATTR_X64(sample_regs_user);
 	ret += PRINT_ATTR_U32(sample_stack_user);
+	ret += PRINT_ATTR_X64(sample_regs_intr);
 
 	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
 
@@ -1504,6 +1510,23 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
 
@@ -1599,6 +1622,16 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
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
 
@@ -1777,6 +1810,17 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
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
 
@@ -1906,7 +1950,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
-		bit_name(IDENTIFIER),
+		bit_name(IDENTIFIER), bit_name(REGS_INTR),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 158c787..62514a7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2458,6 +2458,7 @@ static const int attr_file_abi_sizes[] = {
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
 	[3] = PERF_ATTR_SIZE_VER3,
+	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6d2d50d..dc7a8d1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -581,15 +581,46 @@ static void regs_dump__printf(u64 mask, u64 *regs)
 	}
 }
 
+static const char *regs_abi[] = {
+	[PERF_SAMPLE_REGS_ABI_NONE] = "none",
+	[PERF_SAMPLE_REGS_ABI_32] = "32-bit",
+	[PERF_SAMPLE_REGS_ABI_64] = "64-bit",
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
@@ -688,6 +719,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (sample_type & PERF_SAMPLE_REGS_USER)
 		regs_user__printf(sample);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		regs_intr__printf(sample);
+
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
 
-- 
1.7.9.5

