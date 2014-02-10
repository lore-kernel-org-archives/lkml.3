Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaBJRg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:36:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaBJRat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:49 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 08/21] perf, c2c: Rework setup code to prepare for features
Date: Mon, 10 Feb 2014 12:29:03 -0500
Message-Id: <1392053356-23024-9-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A basic patch that re-arranges some of the c2c code and adds a couple
of small features to lay the ground work for the rest of the patch
series.

Changes include:

o reworking the report path
o creating an initial entry struct
o replace preprocess_sample with simpler calls
o rework raw output to handle separators
o remove phys id gunk
o add some generic options

There isn't much meat in this patch just a bunch of code movement and cleanups.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 163 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 129 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index a5dc412..b062485 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -5,6 +5,7 @@
 #include "util/parse-options.h"
 #include "util/session.h"
 #include "util/tool.h"
+#include "util/debug.h"
 
 #include <linux/compiler.h>
 #include <linux/kernel.h>
@@ -14,6 +15,15 @@ struct perf_c2c {
 	bool		 raw_records;
 };
 
+struct c2c_entry {
+	struct thread		*thread;
+	struct mem_info		*mi;
+	u32			cpu;
+	u8			cpumode;
+	int			weight;
+	int			period;
+};
+
 enum { OP, LVL, SNP, LCK, TLB };
 
 static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
@@ -105,34 +115,69 @@ static int perf_c2c__fprintf_header(FILE *fp)
 }
 
 static int perf_sample__fprintf(struct perf_sample *sample, char tag,
-				const char *reason, struct addr_location *al, FILE *fp)
+				const char *reason, struct mem_info *mi, FILE *fp)
 {
 	char data_src[61];
+	const char *fmt, *sep;
+	struct map *map = mi->iaddr.map;
 
 	perf_c2c__scnprintf_data_src(data_src, sizeof(data_src), sample->data_src);
 
-	return fprintf(fp, "%c %-16s  %6d  %6d  %4d  %#18" PRIx64 "  %#18" PRIx64 "  %#18" PRIx64 "  %6" PRIu64 "  %#10" PRIx64 " %-60.60s %s:%s\n",
-		       tag,
-		       reason ?: "valid record",
-		       sample->pid,
-		       sample->tid,
-		       sample->cpu,
-		       sample->ip,
-		       sample->addr,
-		       0UL,
-		       sample->weight,
-		       sample->data_src,
-		       data_src,
-		       al->map ? (al->map->dso ? al->map->dso->long_name : "???") : "???",
-		       al->sym ? al->sym->name : "???");
+	if (symbol_conf.field_sep) {
+		fmt = "%c%s%s%s%d%s%d%s%d%s%#"PRIx64"%s%#"PRIx64"%s"
+		      "%"PRIu64"%s%#"PRIx64"%s%s%s%s:%s\n";
+		sep = symbol_conf.field_sep;
+	} else {
+		fmt = "%c%s%-16s%s%6d%s%6d%s%4d%s%#18"PRIx64"%s%#18"PRIx64"%s"
+		      "%6"PRIu64"%s%#10"PRIx64"%s%-60.60s%s%s:%s\n";
+		sep = " ";
+	}
+
+	return fprintf(fp, fmt,
+		       tag,				sep,
+		       reason ?: "valid record",	sep,
+		       sample->pid,			sep,
+		       sample->tid,			sep,
+		       sample->cpu,			sep,
+		       sample->ip,			sep,
+		       sample->addr,			sep,
+		       sample->weight,			sep,
+		       sample->data_src,		sep,
+		       data_src,			sep,
+		       map ? (map->dso ? map->dso->long_name : "???") : "???",
+		       mi->iaddr.sym ? mi->iaddr.sym->name : "???");
 }
 
-static int perf_c2c__process_load_store(struct perf_c2c *c2c,
-					struct perf_sample *sample,
-					struct addr_location *al)
+static struct c2c_entry *c2c_entry__new(struct perf_sample *sample,
+					struct thread *thread,
+					struct mem_info *mi,
+					u8 cpumode)
 {
-	if (c2c->raw_records)
-		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
+	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
+	struct c2c_entry *entry = zalloc(sizeof(*entry) + callchain_size);
+
+	if (entry != NULL) {
+		entry->thread = thread;
+		entry->mi = mi;
+		entry->cpu = sample->cpu;
+		entry->cpumode = cpumode;
+		entry->weight = sample->weight;
+		if (sample->period)
+			entry->period = sample->period;
+		else
+			entry->period = 1;
+	}
+
+	return entry;
+}
+
+static int perf_c2c__process_load_store(struct perf_c2c *c2c __maybe_unused,
+				  struct perf_sample *sample __maybe_unused,
+				  struct c2c_entry *entry)
+{
+	/* don't lose the maps if remapped */
+	entry->mi->iaddr.map->referenced = true;
+	entry->mi->daddr.map->referenced = true;
 
 	return 0;
 }
@@ -144,7 +189,7 @@ static const struct perf_evsel_str_handler handlers[] = {
 
 typedef int (*sample_handler)(struct perf_c2c *c2c,
 			      struct perf_sample *sample,
-			      struct addr_location *al);
+			      struct c2c_entry *entry);
 
 static int perf_c2c__process_sample(struct perf_tool *tool,
 				    union perf_event *event,
@@ -153,20 +198,63 @@ static int perf_c2c__process_sample(struct perf_tool *tool,
 				    struct machine *machine)
 {
 	struct perf_c2c *c2c = container_of(tool, struct perf_c2c, tool);
-	struct addr_location al;
-	int err = 0;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct mem_info *mi;
+	struct thread *thread;
+	struct c2c_entry *entry;
+	sample_handler f;
+	int err = -1;
+
+	if (evsel->handler.func == NULL)
+		return 0;
+
+	thread = machine__find_thread(machine, sample->tid);
+	if (thread == NULL)
+		goto err;
+
+	mi = machine__resolve_mem(machine, thread, sample, cpumode);
+	if (mi == NULL)
+		goto err;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
-		pr_err("problem processing %d event, skipping it.\n",
-		       event->header.type);
-		return -1;
+	if (c2c->raw_records) {
+		perf_sample__fprintf(sample, ' ', "raw input", mi, stdout);
+		free(mi);
+		return 0;
 	}
 
-	if (evsel->handler.func != NULL) {
-		sample_handler f = evsel->handler.func;
-		err = f(c2c, sample, &al);
+	entry = c2c_entry__new(sample, thread, mi, cpumode);
+	if (entry == NULL)
+		goto err_mem;
+
+	f = evsel->handler.func;
+	err = f(c2c, sample, entry);
+	if (err)
+		goto err_entry;
+
+	return 0;
+
+err_entry:
+	free(entry);
+err_mem:
+	free(mi);
+err:
+	if (err > 0)
+		err = 0;
+	return err;
+}
+
+static int perf_c2c__process_events(struct perf_session *session,
+				    struct perf_c2c *c2c)
+{
+	int err = -1;
+
+	err = perf_session__process_events(session, &c2c->tool);
+	if (err) {
+		pr_err("Failed to process count events, error %d\n", err);
+		goto err;
 	}
 
+err:
 	return err;
 }
 
@@ -184,9 +272,7 @@ static int perf_c2c__read_events(struct perf_c2c *c2c)
 	if (perf_evlist__set_handlers(session->evlist, handlers))
 		goto out_delete;
 
-	err = perf_session__process_events(session, &c2c->tool);
-	if (err)
-		pr_err("Failed to process events, error %d", err);
+	err = perf_c2c__process_events(session, c2c);
 
 out_delete:
 	perf_session__delete(session);
@@ -210,7 +296,6 @@ static int perf_c2c__record(int argc, const char **argv)
 	const char **rec_argv;
 	const char * const record_args[] = {
 		"record",
-		/* "--phys-addr", */
 		"-W",
 		"-d",
 		"-a",
@@ -243,6 +328,8 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_c2c c2c = {
 		.tool = {
 			.sample		 = perf_c2c__process_sample,
+			.mmap2           = perf_event__process_mmap2,
+			.mmap            = perf_event__process_mmap,
 			.comm		 = perf_event__process_comm,
 			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
@@ -252,6 +339,14 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 	};
 	const struct option c2c_options[] = {
 	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose (show counter open errors, etc)"),
+	OPT_STRING('i', "input", &input_name, "file",
+		   "the input file to process"),
+	OPT_STRING('x', "field-separator", &symbol_conf.field_sep,
+		   "separator",
+		   "separator for columns, no spaces will be added"
+		   " between columns '.' is reserved."),
 	OPT_END()
 	};
 	const char * const c2c_usage[] = {
-- 
1.7.11.7

