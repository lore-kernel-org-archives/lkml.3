Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaKPMiP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:38:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35685 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbaKPMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:37:13 -0500
Date: Sun, 16 Nov 2014 04:36:14 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-6a21c0b5c2abd2fdfa6fff79f11df3d6082c1873@git.kernel.org>
Cc: dzickus@redhat.com, torvalds@linux-foundation.org, wangnan0@huawei.com,
        jolsa@kernel.org, acme@kernel.org, peterz@infradead.org,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        jean.pihet@linaro.org, hpa@zytor.com, jolsa@redhat.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        namhyung@kernel.org, Waiman.Long@hp.com, eranian@google.com,
        paulus@samba.org, mingo@kernel.org
Reply-To: jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        dsahern@gmail.com, ak@linux.intel.com, eranian@google.com,
        Waiman.Long@hp.com, paulus@samba.org, mingo@kernel.org,
        torvalds@linux-foundation.org, dzickus@redhat.com,
        adrian.hunter@intel.com, peterz@infradead.org, jolsa@kernel.org,
        acme@kernel.org, wangnan0@huawei.com, jean.pihet@linaro.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <1411559322-16548-4-git-send-email-eranian@google.com>
References: <1411559322-16548-4-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add core support for sampling intr machine state regs
Git-Commit-ID: 6a21c0b5c2abd2fdfa6fff79f11df3d6082c1873
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

Commit-ID:  6a21c0b5c2abd2fdfa6fff79f11df3d6082c1873
Gitweb:     http://git.kernel.org/tip/6a21c0b5c2abd2fdfa6fff79f11df3d6082c1873
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 24 Sep 2014 13:48:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:41:59 +0100

perf tools: Add core support for sampling intr machine state regs

Add the infrastructure to setup, collect and report the interrupt
machine state regs which can be captured by the kernel.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: cebbert.lkml@gmail.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Wang Nan <wangnan0@huawei.com>
Link: http://lkml.kernel.org/r/1411559322-16548-4-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/perf.h         |  1 +
 tools/perf/util/event.h   |  1 +
 tools/perf/util/evsel.c   | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/header.c  |  1 +
 tools/perf/util/session.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 511c2831..1dabb85 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -52,6 +52,7 @@ struct record_opts {
 	bool	     sample_weight;
 	bool	     sample_time;
 	bool	     period;
+	bool	     sample_intr_regs;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 7be3897..09b9e8d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -188,6 +188,7 @@ struct perf_sample {
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
 	struct regs_dump  user_regs;
+	struct regs_dump  intr_regs;
 	struct stack_dump user_stack;
 	struct sample_read read;
 };
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 12b4396..34344ff 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -661,6 +661,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (callchain_param.enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel);
 
+	if (opts->sample_intr_regs) {
+		attr->sample_regs_intr = PERF_REGS_MASK;
+		perf_evsel__set_sample_bit(evsel, REGS_INTR);
+	}
+
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
 
@@ -1037,6 +1042,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR_X64(branch_sample_type);
 	ret += PRINT_ATTR_X64(sample_regs_user);
 	ret += PRINT_ATTR_U32(sample_stack_user);
+	ret += PRINT_ATTR_X64(sample_regs_intr);
 
 	ret += fprintf(fp, "%.60s\n", graph_dotted_line);
 
@@ -1536,6 +1542,23 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
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
 
@@ -1631,6 +1654,16 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
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
 
@@ -1809,6 +1842,17 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
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
 
@@ -1938,7 +1982,7 @@ static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
 		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
 		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
 		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
-		bit_name(IDENTIFIER),
+		bit_name(IDENTIFIER), bit_name(REGS_INTR),
 		{ .name = NULL, }
 	};
 #undef bit_name
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 76442ca..05fab7a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2143,6 +2143,7 @@ static const int attr_file_abi_sizes[] = {
 	[1] = PERF_ATTR_SIZE_VER1,
 	[2] = PERF_ATTR_SIZE_VER2,
 	[3] = PERF_ATTR_SIZE_VER3,
+	[4] = PERF_ATTR_SIZE_VER4,
 	0,
 };
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f4478ce..6ac62ae 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -592,15 +592,46 @@ static void regs_dump__printf(u64 mask, u64 *regs)
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
@@ -699,6 +730,9 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 	if (sample_type & PERF_SAMPLE_REGS_USER)
 		regs_user__printf(sample);
 
+	if (sample_type & PERF_SAMPLE_REGS_INTR)
+		regs_intr__printf(sample);
+
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
 
