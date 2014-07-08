Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaGHWQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:16:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32873 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaGHWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:16:51 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, namhyung@kernel.org
Subject: [PATCH 3/4] perf tools: add core support for sampling intr machine state regs
Date: Wed,  9 Jul 2014 00:15:58 +0200
Message-Id: <1404857759-25105-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404857759-25105-1-git-send-email-eranian@google.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the infrastructure to setup, collect and report the interrupt
machine state regs which can be captured by the kernel.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/perf.h         |  1 +
 tools/perf/util/event.h   |  7 +++++++
 tools/perf/util/evsel.c   | 25 ++++++++++++++++++++++++-
 tools/perf/util/session.c | 26 ++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 1 deletion(-)

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
index e5dd40a..4ce2e99 100644
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
@@ -290,6 +291,12 @@ int perf_event__preprocess_sample(const union perf_event *event,
 
 const char *perf_event__name(unsigned int id);
 
+int perf_event__parse_sample(const union perf_event *event, u64 type,
+			     int sample_size, bool sample_id_all,
+			     u64 sample_regs_user, u64 sample_stack_user,
+			     u64 sample_regs_intr,
+			     struct perf_sample *data, bool swapped);
+
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 				     u64 read_format);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8606175..00e45d1 100644
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
 
@@ -1870,7 +1893,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
-		bit_name(IDENTIFIER),
+		bit_name(IDENTIFIER), bit_name(REGS_INTR),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 64a186e..6f112ca 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -713,6 +713,29 @@ static void regs_user__printf(struct perf_sample *sample)
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
+		return "???";
+	return regs_abi[d->abi];
+}
+
+static void regs_intr__printf(struct perf_sample *sample, u64 mask)
+{
+	struct regs_dump *intr_regs = &sample->intr_regs;
+
+	if (intr_regs->regs) {
+		printf("... intr regs: mask 0x%" PRIx64 " ABI: %s\n", mask, regs_dump_abi(intr_regs));
+		regs_dump__printf(mask, intr_regs->regs);
+	}
+}
+
 static void stack_user__printf(struct stack_dump *dump)
 {
 	printf("... ustack: size %" PRIu64 ", offset 0x%x\n",
@@ -809,6 +832,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (sample_type & PERF_SAMPLE_REGS_USER)
 		regs_user__printf(sample);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		regs_intr__printf(sample, evsel->attr.sample_regs_intr);
+
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
 
-- 
1.8.3.2

