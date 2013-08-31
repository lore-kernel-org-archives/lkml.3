Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab3HaIPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:15:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab3HaIPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:15:12 -0400
Date: Sat, 31 Aug 2013 01:14:34 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d03f2170546d2f0c236a42706d211e15ffb64184@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1377591794-30553-10-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-10-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Expand perf_event__synthesize_sample(
 )
Git-Commit-ID: d03f2170546d2f0c236a42706d211e15ffb64184
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:14:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d03f2170546d2f0c236a42706d211e15ffb64184
Gitweb:     http://git.kernel.org/tip/d03f2170546d2f0c236a42706d211e15ffb64184
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 27 Aug 2013 11:23:11 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 16:14:20 -0300

perf tools: Expand perf_event__synthesize_sample()

Expand perf_event__synthesize_sample() to handle all sample format bits.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377591794-30553-10-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c |  4 +-
 tools/perf/util/event.h     |  1 +
 tools/perf/util/evsel.c     | 95 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index ffacd46..9b336fd 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -301,7 +301,9 @@ found:
 	sample_sw.period = sample->period;
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
-				      &sample_sw, false);
+				      evsel->attr.sample_regs_user,
+				      evsel->attr.read_format, &sample_sw,
+				      false);
 	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
 	return perf_event__repipe(tool, event_sw, &sample_sw, machine);
 }
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index f959801..1c80e13 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -230,6 +230,7 @@ int perf_event__preprocess_sample(const union perf_event *self,
 const char *perf_event__name(unsigned int id);
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  u64 sample_regs_user, u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1184188..7d62373 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1416,7 +1416,6 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		/* First u64 tells us if we have any regs in sample. */
 		OVERFLOW_CHECK_u64(array);
 		data->user_regs.abi = *array;
 		array++;
@@ -1467,11 +1466,12 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 }
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
+				  u64 sample_regs_user, u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped)
 {
 	u64 *array;
-
+	size_t sz;
 	/*
 	 * used for cross-endian analysis. See git commit 65014ab3
 	 * for why this goofiness is needed.
@@ -1544,6 +1544,97 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 		array++;
 	}
 
+	if (type & PERF_SAMPLE_READ) {
+		if (read_format & PERF_FORMAT_GROUP)
+			*array = sample->read.group.nr;
+		else
+			*array = sample->read.one.value;
+		array++;
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+			*array = sample->read.time_enabled;
+			array++;
+		}
+
+		if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+			*array = sample->read.time_running;
+			array++;
+		}
+
+		/* PERF_FORMAT_ID is forced for PERF_SAMPLE_READ */
+		if (read_format & PERF_FORMAT_GROUP) {
+			sz = sample->read.group.nr *
+			     sizeof(struct sample_read_value);
+			memcpy(array, sample->read.group.values, sz);
+			array = (void *)array + sz;
+		} else {
+			*array = sample->read.one.id;
+			array++;
+		}
+	}
+
+	if (type & PERF_SAMPLE_CALLCHAIN) {
+		sz = (sample->callchain->nr + 1) * sizeof(u64);
+		memcpy(array, sample->callchain, sz);
+		array = (void *)array + sz;
+	}
+
+	if (type & PERF_SAMPLE_RAW) {
+		u.val32[0] = sample->raw_size;
+		if (WARN_ONCE(swapped,
+			      "Endianness of raw data not corrected!\n")) {
+			/*
+			 * Inverse of what is done in perf_evsel__parse_sample
+			 */
+			u.val32[0] = bswap_32(u.val32[0]);
+			u.val32[1] = bswap_32(u.val32[1]);
+			u.val64 = bswap_64(u.val64);
+		}
+		*array = u.val64;
+		array = (void *)array + sizeof(u32);
+
+		memcpy(array, sample->raw_data, sample->raw_size);
+		array = (void *)array + sample->raw_size;
+	}
+
+	if (type & PERF_SAMPLE_BRANCH_STACK) {
+		sz = sample->branch_stack->nr * sizeof(struct branch_entry);
+		sz += sizeof(u64);
+		memcpy(array, sample->branch_stack, sz);
+		array = (void *)array + sz;
+	}
+
+	if (type & PERF_SAMPLE_REGS_USER) {
+		if (sample->user_regs.abi) {
+			*array++ = sample->user_regs.abi;
+			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			memcpy(array, sample->user_regs.regs, sz);
+			array = (void *)array + sz;
+		} else {
+			*array++ = 0;
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK_USER) {
+		sz = sample->user_stack.size;
+		*array++ = sz;
+		if (sz) {
+			memcpy(array, sample->user_stack.data, sz);
+			array = (void *)array + sz;
+			*array++ = sz;
+		}
+	}
+
+	if (type & PERF_SAMPLE_WEIGHT) {
+		*array = sample->weight;
+		array++;
+	}
+
+	if (type & PERF_SAMPLE_DATA_SRC) {
+		*array = sample->data_src;
+		array++;
+	}
+
 	return 0;
 }
 
