Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaBVSDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:03:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaBVSDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:03:30 -0500
Date: Sat, 22 Feb 2014 09:58:06 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-352ea45a7229df8f5ae83c0757f6d426ba0f41b5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-9-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain: Add mask into struct regs_dump
Git-Commit-ID: 352ea45a7229df8f5ae83c0757f6d426ba0f41b5
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

Commit-ID:  352ea45a7229df8f5ae83c0757f6d426ba0f41b5
Gitweb:     http://git.kernel.org/tip/352ea45a7229df8f5ae83c0757f6d426ba0f41b5
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:25 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:48 -0300

perf callchain: Add mask into struct regs_dump

Adding mask info into struct regs_dump to make the registers information
compact.

The mask was always passed along, so logically the mask info fits more
into the struct regs_dump.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/tests/dwarf-unwind.c |  1 +
 tools/perf/builtin-inject.c              |  1 -
 tools/perf/tests/dwarf-unwind.c          |  2 +-
 tools/perf/tests/sample-parsing.c        | 17 ++++++++---------
 tools/perf/util/event.h                  |  5 +++--
 tools/perf/util/evsel.c                  | 13 +++++++------
 tools/perf/util/machine.c                |  3 +--
 tools/perf/util/session.c                |  5 +++--
 tools/perf/util/unwind.c                 | 20 ++++++++------------
 tools/perf/util/unwind.h                 |  2 --
 10 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/x86/tests/dwarf-unwind.c
index 371f849..b602ad9 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/x86/tests/dwarf-unwind.c
@@ -53,6 +53,7 @@ int test__arch_unwind_sample(struct perf_sample *sample,
 	perf_regs_load(buf);
 	regs->abi  = PERF_SAMPLE_REGS_ABI;
 	regs->regs = buf;
+	regs->mask = PERF_REGS_MASK;
 
 	return sample_ustack(sample, thread, buf);
 }
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index b346601..3a73875 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -312,7 +312,6 @@ found:
 	sample_sw.period = sample->period;
 	sample_sw.time	 = sample->time;
 	perf_event__synthesize_sample(event_sw, evsel->attr.sample_type,
-				      evsel->attr.sample_regs_user,
 				      evsel->attr.read_format, &sample_sw,
 				      false);
 	build_id__mark_dso_hit(tool, event_sw, &sample_sw, evsel, machine);
diff --git a/tools/perf/tests/dwarf-unwind.c b/tools/perf/tests/dwarf-unwind.c
index a203c0c..f16ea28 100644
--- a/tools/perf/tests/dwarf-unwind.c
+++ b/tools/perf/tests/dwarf-unwind.c
@@ -72,7 +72,7 @@ static int unwind_thread(struct thread *thread, struct machine *machine)
 	}
 
 	err = unwind__get_entries(unwind_entry, &cnt, machine, thread,
-				  PERF_REGS_MASK, &sample, MAX_STACK);
+				  &sample, MAX_STACK);
 	if (err)
 		pr_debug("unwind failed\n");
 	else if (cnt != MAX_STACK) {
diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index 1b67720..0014d3c 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -22,8 +22,8 @@
 } while (0)
 
 static bool samples_same(const struct perf_sample *s1,
-			 const struct perf_sample *s2, u64 type, u64 regs_user,
-			 u64 read_format)
+			 const struct perf_sample *s2,
+			 u64 type, u64 read_format)
 {
 	size_t i;
 
@@ -95,8 +95,9 @@ static bool samples_same(const struct perf_sample *s1,
 	}
 
 	if (type & PERF_SAMPLE_REGS_USER) {
-		size_t sz = hweight_long(regs_user) * sizeof(u64);
+		size_t sz = hweight_long(s1->user_regs.mask) * sizeof(u64);
 
+		COMP(user_regs.mask);
 		COMP(user_regs.abi);
 		if (s1->user_regs.abi &&
 		    (!s1->user_regs.regs || !s2->user_regs.regs ||
@@ -174,6 +175,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		.branch_stack	= &branch_stack.branch_stack,
 		.user_regs	= {
 			.abi	= PERF_SAMPLE_REGS_ABI_64,
+			.mask	= sample_regs_user,
 			.regs	= user_regs,
 		},
 		.user_stack	= {
@@ -201,8 +203,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		sample.read.one.id    = 99;
 	}
 
-	sz = perf_event__sample_event_size(&sample, sample_type,
-					   sample_regs_user, read_format);
+	sz = perf_event__sample_event_size(&sample, sample_type, read_format);
 	bufsz = sz + 4096; /* Add a bit for overrun checking */
 	event = malloc(bufsz);
 	if (!event) {
@@ -215,8 +216,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 	event->header.misc = 0;
 	event->header.size = sz;
 
-	err = perf_event__synthesize_sample(event, sample_type,
-					    sample_regs_user, read_format,
+	err = perf_event__synthesize_sample(event, sample_type, read_format,
 					    &sample, false);
 	if (err) {
 		pr_debug("%s failed for sample_type %#"PRIx64", error %d\n",
@@ -244,8 +244,7 @@ static int do_test(u64 sample_type, u64 sample_regs_user, u64 read_format)
 		goto out_free;
 	}
 
-	if (!samples_same(&sample, &sample_out, sample_type,
-			  sample_regs_user, read_format)) {
+	if (!samples_same(&sample, &sample_out, sample_type, read_format)) {
 		pr_debug("parsing failed for sample_type %#"PRIx64"\n",
 			 sample_type);
 		goto out_free;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 851fa06..38457d4 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -85,6 +85,7 @@ struct sample_event {
 
 struct regs_dump {
 	u64 abi;
+	u64 mask;
 	u64 *regs;
 };
 
@@ -259,9 +260,9 @@ int perf_event__preprocess_sample(const union perf_event *event,
 const char *perf_event__name(unsigned int id);
 
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
-				     u64 sample_regs_user, u64 read_format);
+				     u64 read_format);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
-				  u64 sample_regs_user, u64 read_format,
+				  u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8201abe..adc94dd 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1396,10 +1396,11 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 		array++;
 
 		if (data->user_regs.abi) {
-			u64 regs_user = evsel->attr.sample_regs_user;
+			u64 mask = evsel->attr.sample_regs_user;
 
-			sz = hweight_long(regs_user) * sizeof(u64);
+			sz = hweight_long(mask) * sizeof(u64);
 			OVERFLOW_CHECK(array, sz, max_size);
+			data->user_regs.mask = mask;
 			data->user_regs.regs = (u64 *)array;
 			array = (void *)array + sz;
 		}
@@ -1451,7 +1452,7 @@ int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 }
 
 size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
-				     u64 sample_regs_user, u64 read_format)
+				     u64 read_format)
 {
 	size_t sz, result = sizeof(struct sample_event);
 
@@ -1517,7 +1518,7 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 	if (type & PERF_SAMPLE_REGS_USER) {
 		if (sample->user_regs.abi) {
 			result += sizeof(u64);
-			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			sz = hweight_long(sample->user_regs.mask) * sizeof(u64);
 			result += sz;
 		} else {
 			result += sizeof(u64);
@@ -1546,7 +1547,7 @@ size_t perf_event__sample_event_size(const struct perf_sample *sample, u64 type,
 }
 
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
-				  u64 sample_regs_user, u64 read_format,
+				  u64 read_format,
 				  const struct perf_sample *sample,
 				  bool swapped)
 {
@@ -1687,7 +1688,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 	if (type & PERF_SAMPLE_REGS_USER) {
 		if (sample->user_regs.abi) {
 			*array++ = sample->user_regs.abi;
-			sz = hweight_long(sample_regs_user) * sizeof(u64);
+			sz = hweight_long(sample->user_regs.mask) * sizeof(u64);
 			memcpy(array, sample->user_regs.regs, sz);
 			array = (void *)array + sz;
 		} else {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6c08ab0..ac37d78 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1383,8 +1383,7 @@ int machine__resolve_callchain(struct machine *machine,
 		return 0;
 
 	return unwind__get_entries(unwind_entry, &callchain_cursor, machine,
-				   thread, evsel->attr.sample_regs_user,
-				   sample, max_stack);
+				   thread, sample, max_stack);
 
 }
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5da6ce7..1d555d6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -702,11 +702,12 @@ static void regs_dump__printf(u64 mask, u64 *regs)
 	}
 }
 
-static void regs_user__printf(struct perf_sample *sample, u64 mask)
+static void regs_user__printf(struct perf_sample *sample)
 {
 	struct regs_dump *user_regs = &sample->user_regs;
 
 	if (user_regs->regs) {
+		u64 mask = user_regs->mask;
 		printf("... user regs: mask 0x%" PRIx64 "\n", mask);
 		regs_dump__printf(mask, user_regs->regs);
 	}
@@ -806,7 +807,7 @@ static void dump_sample(struct perf_evsel *evsel, union perf_event *event,
 		branch_stack__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_REGS_USER)
-		regs_user__printf(sample, evsel->attr.sample_regs_user);
+		regs_user__printf(sample);
 
 	if (sample_type & PERF_SAMPLE_STACK_USER)
 		stack_user__printf(&sample->user_stack);
diff --git a/tools/perf/util/unwind.c b/tools/perf/util/unwind.c
index 3b70181..720a4ca 100644
--- a/tools/perf/util/unwind.c
+++ b/tools/perf/util/unwind.c
@@ -86,7 +86,6 @@ struct unwind_info {
 	struct perf_sample	*sample;
 	struct machine		*machine;
 	struct thread		*thread;
-	u64			sample_uregs;
 };
 
 #define dw_read(ptr, type, end) ({	\
@@ -391,16 +390,16 @@ static int access_dso_mem(struct unwind_info *ui, unw_word_t addr,
 	return !(size == sizeof(*data));
 }
 
-static int reg_value(unw_word_t *valp, struct regs_dump *regs, int id,
-		     u64 sample_regs)
+static int reg_value(unw_word_t *valp, struct regs_dump *regs, int id)
 {
 	int i, idx = 0;
+	u64 mask = regs->mask;
 
-	if (!(sample_regs & (1 << id)))
+	if (!(mask & (1 << id)))
 		return -EINVAL;
 
 	for (i = 0; i < id; i++) {
-		if (sample_regs & (1 << i))
+		if (mask & (1 << i))
 			idx++;
 	}
 
@@ -424,8 +423,7 @@ static int access_mem(unw_addr_space_t __maybe_unused as,
 		return 0;
 	}
 
-	ret = reg_value(&start, &ui->sample->user_regs, PERF_REG_SP,
-			ui->sample_uregs);
+	ret = reg_value(&start, &ui->sample->user_regs, PERF_REG_SP);
 	if (ret)
 		return ret;
 
@@ -475,7 +473,7 @@ static int access_reg(unw_addr_space_t __maybe_unused as,
 	if (id < 0)
 		return -EINVAL;
 
-	ret = reg_value(valp, &ui->sample->user_regs, id, ui->sample_uregs);
+	ret = reg_value(valp, &ui->sample->user_regs, id);
 	if (ret) {
 		pr_err("unwind: can't read reg %d\n", regnum);
 		return ret;
@@ -572,13 +570,11 @@ static int get_entries(struct unwind_info *ui, unwind_entry_cb_t cb,
 
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine, struct thread *thread,
-			u64 sample_uregs, struct perf_sample *data,
-			int max_stack)
+			struct perf_sample *data, int max_stack)
 {
 	unw_word_t ip;
 	struct unwind_info ui = {
 		.sample       = data,
-		.sample_uregs = sample_uregs,
 		.thread       = thread,
 		.machine      = machine,
 	};
@@ -587,7 +583,7 @@ int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 	if (!data->user_regs.regs)
 		return -EINVAL;
 
-	ret = reg_value(&ip, &data->user_regs, PERF_REG_IP, sample_uregs);
+	ret = reg_value(&ip, &data->user_regs, PERF_REG_IP);
 	if (ret)
 		return ret;
 
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index d5966f49..356e1d6 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -17,7 +17,6 @@ typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
-			u64 sample_uregs,
 			struct perf_sample *data, int max_stack);
 int unwind__arch_reg_id(int regnum);
 #else
@@ -26,7 +25,6 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 		    void *arg __maybe_unused,
 		    struct machine *machine __maybe_unused,
 		    struct thread *thread __maybe_unused,
-		    u64 sample_uregs __maybe_unused,
 		    struct perf_sample *data __maybe_unused,
 		    int max_stack __maybe_unused)
 {
