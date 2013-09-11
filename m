Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3IKOxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:53:50 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:60243 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3IKOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:53:48 -0400
Date: Wed, 11 Sep 2013 11:53:41 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130911145341.GF1866@ghostprotocols.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
 <20130909194844.GB28428@ghostprotocols.net>
 <20130910130002.GD28428@ghostprotocols.net>
 <CABPqkBRgj71D8FkWtR-4K8g5ErWMt8YsV7FcmxQ3Uouj640Z0A@mail.gmail.com>
 <20130910131728.GE28428@ghostprotocols.net>
 <20130910195847.GA1866@ghostprotocols.net>
 <20130910201637.GB1866@ghostprotocols.net>
 <CABPqkBQvo9r5ArPKFBOyMap2LK+8mR5anMiCtvjL-WUmxJ3qgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQvo9r5ArPKFBOyMap2LK+8mR5anMiCtvjL-WUmxJ3qgg@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 11, 2013 at 04:42:57PM +0200, Stephane Eranian escreveu:
> Arnaldo,
> 
> Do you have all those changes in a git tree somewhere.
> I want to help test and debug this part too.
> Thanks.

Right now its all in my perf/urgent branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
 
For reference, the affected patch, with my updates, is here:

commit 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
Author: Stephane Eranian <eranian@google.com>
Date:   Wed Aug 21 12:10:25 2013 +0200

    perf tools: Add attr->mmap2 support
    
    This patch adds support for the new PERF_RECORD_MMAP2 record type
    exposed by the kernel. This is an extended PERF_RECORD_MMAP record.
    
    It adds for each file-backed mapping the device major, minor number and
    the inode number and generation.
    
    This triplet uniquely identifies the source of a file-backed mapping. It
    can be used to detect identical virtual mappings between processes, for
    instance.
    
    The patch will prefer MMAP2 over MMAP.
    
    Signed-off-by: Stephane Eranian <eranian@google.com>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Namhyung Kim <namhyung.kim@lge.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1377079825-19057-3-git-send-email-eranian@google.com
    [ Cope with 314add6 "Change machine__findnew_thread() to set thread pid",
      fix 'perf test' regression test entry affected,
      use perf_missing_features.mmap2 to fallback to not using .mmap2 in older kernels,
      so that new tools can work with kernels where this feature is not present ]
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f988d38..5ebd0c3 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -277,6 +277,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
+			.mmap2	= perf_event__process_mmap2,
 			.comm	= perf_event__process_comm,
 			.exit	= perf_event__process_exit,
 			.fork	= perf_event__process_fork,
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 9b336fd..423875c 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -123,6 +123,19 @@ static int perf_event__repipe_mmap(struct perf_tool *tool,
 	return err;
 }
 
+static int perf_event__repipe_mmap2(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_sample *sample,
+				   struct machine *machine)
+{
+	int err;
+
+	err = perf_event__process_mmap2(tool, event, sample, machine);
+	perf_event__repipe(tool, event, sample, machine);
+
+	return err;
+}
+
 static int perf_event__repipe_fork(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
@@ -339,6 +352,7 @@ static int __cmd_inject(struct perf_inject *inject)
 
 	if (inject->build_ids || inject->sched_stat) {
 		inject->tool.mmap	  = perf_event__repipe_mmap;
+		inject->tool.mmap2	  = perf_event__repipe_mmap2;
 		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
@@ -390,6 +404,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= perf_event__repipe_sample,
 			.mmap		= perf_event__repipe,
+			.mmap2		= perf_event__repipe,
 			.comm		= perf_event__repipe,
 			.fork		= perf_event__repipe,
 			.exit		= perf_event__repipe,
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 791b432..253133a 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -190,6 +190,7 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		= process_sample_event,
 			.mmap		= perf_event__process_mmap,
+			.mmap2		= perf_event__process_mmap2,
 			.comm		= perf_event__process_comm,
 			.lost		= perf_event__process_lost,
 			.fork		= perf_event__process_fork,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9725aa3..8e50d8d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -744,6 +744,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		.tool = {
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
+			.mmap2		 = perf_event__process_mmap2,
 			.comm		 = perf_event__process_comm,
 			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 93a34ce..7f31a3d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -542,6 +542,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool perf_script = {
 	.sample		 = process_sample_event,
 	.mmap		 = perf_event__process_mmap,
+	.mmap2		 = perf_event__process_mmap2,
 	.comm		 = perf_event__process_comm,
 	.exit		 = perf_event__process_exit,
 	.fork		 = perf_event__process_fork,
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 72d8881..b8a7056 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -50,7 +50,7 @@ int test__PERF_RECORD(void)
 	struct perf_sample sample;
 	const char *cmd = "sleep";
 	const char *argv[] = { cmd, "1", NULL, };
-	char *bname;
+	char *bname, *mmap_filename;
 	u64 prev_time = 0;
 	bool found_cmd_mmap = false,
 	     found_libc_mmap = false,
@@ -212,6 +212,7 @@ int test__PERF_RECORD(void)
 
 				if ((type == PERF_RECORD_COMM ||
 				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_MMAP2 ||
 				     type == PERF_RECORD_FORK ||
 				     type == PERF_RECORD_EXIT) &&
 				     (pid_t)event->comm.pid != evlist->workload.pid) {
@@ -220,7 +221,8 @@ int test__PERF_RECORD(void)
 				}
 
 				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP) &&
+				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_MMAP2) &&
 				     event->comm.pid != event->comm.tid) {
 					pr_debug("%s with different pid/tid!\n", name);
 					++errs;
@@ -236,7 +238,12 @@ int test__PERF_RECORD(void)
 				case PERF_RECORD_EXIT:
 					goto found_exit;
 				case PERF_RECORD_MMAP:
-					bname = strrchr(event->mmap.filename, '/');
+					mmap_filename = event->mmap.filename;
+					goto check_bname;
+				case PERF_RECORD_MMAP2:
+					mmap_filename = event->mmap2.filename;
+				check_bname:
+					bname = strrchr(mmap_filename, '/');
 					if (bname != NULL) {
 						if (!found_cmd_mmap)
 							found_cmd_mmap = !strcmp(bname + 1, cmd);
@@ -245,7 +252,7 @@ int test__PERF_RECORD(void)
 						if (!found_ld_mmap)
 							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
 					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
+						found_vdso_mmap = !strcmp(mmap_filename, "[vdso]");
 					break;
 
 				case PERF_RECORD_SAMPLE:
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index fb58409..7ded71d 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -67,6 +67,7 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 struct perf_tool build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.fork	= perf_event__process_fork,
 	.exit	= perf_event__exit_del_thread,
 	.attr		 = perf_event__process_attr,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 8d51f21..9b393e7 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -11,6 +11,7 @@
 static const char *perf_event__names[] = {
 	[0]					= "TOTAL",
 	[PERF_RECORD_MMAP]			= "MMAP",
+	[PERF_RECORD_MMAP2]			= "MMAP2",
 	[PERF_RECORD_LOST]			= "LOST",
 	[PERF_RECORD_COMM]			= "COMM",
 	[PERF_RECORD_EXIT]			= "EXIT",
@@ -186,7 +187,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		return -1;
 	}
 
-	event->header.type = PERF_RECORD_MMAP;
+	event->header.type = PERF_RECORD_MMAP2;
 	/*
 	 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
 	 */
@@ -197,7 +198,9 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		char prot[5];
 		char execname[PATH_MAX];
 		char anonstr[] = "//anon";
+		unsigned int ino;
 		size_t size;
+		ssize_t n;
 
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
@@ -206,9 +209,16 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 		strcpy(execname, "");
 
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
-		       &event->mmap.start, &event->mmap.len, prot,
-		       &event->mmap.pgoff, execname);
+		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
+		       &event->mmap2.start, &event->mmap2.len, prot,
+		       &event->mmap2.pgoff, &event->mmap2.maj,
+		       &event->mmap2.min,
+		       &ino, execname);
+
+		event->mmap2.ino = (u64)ino;
+
+		if (n != 8)
+			continue;
 
 		if (prot[2] != 'x')
 			continue;
@@ -217,15 +227,15 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			strcpy(execname, anonstr);
 
 		size = strlen(execname) + 1;
-		memcpy(event->mmap.filename, execname, size);
+		memcpy(event->mmap2.filename, execname, size);
 		size = PERF_ALIGN(size, sizeof(u64));
-		event->mmap.len -= event->mmap.start;
-		event->mmap.header.size = (sizeof(event->mmap) -
-					   (sizeof(event->mmap.filename) - size));
-		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
-		event->mmap.header.size += machine->id_hdr_size;
-		event->mmap.pid = tgid;
-		event->mmap.tid = pid;
+		event->mmap2.len -= event->mmap.start;
+		event->mmap2.header.size = (sizeof(event->mmap2) -
+					(sizeof(event->mmap2.filename) - size));
+		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
+		event->mmap2.header.size += machine->id_hdr_size;
+		event->mmap2.pid = tgid;
+		event->mmap2.tid = pid;
 
 		if (process(tool, event, &synth_sample, machine) != 0) {
 			rc = -1;
@@ -527,6 +537,17 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 		       event->mmap.len, event->mmap.pgoff, event->mmap.filename);
 }
 
+size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64
+			   " %02x:%02x %"PRIu64" %"PRIu64"]: %s\n",
+		       event->mmap2.pid, event->mmap2.tid, event->mmap2.start,
+		       event->mmap2.len, event->mmap2.pgoff, event->mmap2.maj,
+		       event->mmap2.min, event->mmap2.ino,
+		       event->mmap2.ino_generation,
+		       event->mmap2.filename);
+}
+
 int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
@@ -535,6 +556,14 @@ int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 	return machine__process_mmap_event(machine, event);
 }
 
+int perf_event__process_mmap2(struct perf_tool *tool __maybe_unused,
+			     union perf_event *event,
+			     struct perf_sample *sample __maybe_unused,
+			     struct machine *machine)
+{
+	return machine__process_mmap2_event(machine, event);
+}
+
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, "(%d:%d):(%d:%d)\n",
@@ -574,6 +603,9 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	case PERF_RECORD_MMAP:
 		ret += perf_event__fprintf_mmap(event, fp);
 		break;
+	case PERF_RECORD_MMAP2:
+		ret += perf_event__fprintf_mmap2(event, fp);
+		break;
 	default:
 		ret += fprintf(fp, "\n");
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 93130d8..c67ecc4 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -17,6 +17,19 @@ struct mmap_event {
 	char filename[PATH_MAX];
 };
 
+struct mmap2_event {
+	struct perf_event_header header;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
+	u32 maj;
+	u32 min;
+	u64 ino;
+	u64 ino_generation;
+	char filename[PATH_MAX];
+};
+
 struct comm_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -159,6 +172,7 @@ struct tracing_data_event {
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
+	struct mmap2_event		mmap2;
 	struct comm_event		comm;
 	struct fork_event		fork;
 	struct lost_event		lost;
@@ -208,6 +222,10 @@ int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
+int perf_event__process_mmap2(struct perf_tool *tool,
+			     union perf_event *event,
+			     struct perf_sample *sample,
+			     struct machine *machine);
 int perf_event__process_fork(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
@@ -238,6 +256,7 @@ int perf_event__synthesize_sample(union perf_event *event, u64 type,
 
 size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 3612183..0ce9feb 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -27,6 +27,7 @@
 static struct {
 	bool sample_id_all;
 	bool exclude_guest;
+	bool mmap2;
 } perf_missing_features;
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
@@ -676,8 +677,9 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	if (opts->sample_weight)
 		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
 
-	attr->mmap = track;
-	attr->comm = track;
+	attr->mmap  = track;
+	attr->mmap2 = track && !perf_missing_features.mmap2;
+	attr->comm  = track;
 
 	/*
 	 * XXX see the function comment above
@@ -1016,6 +1018,8 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 fallback_missing_features:
+	if (perf_missing_features.mmap2)
+		evsel->attr.mmap2 = 0;
 	if (perf_missing_features.exclude_guest)
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 retry_sample_id:
@@ -1080,8 +1084,11 @@ try_fallback:
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
-	if (!perf_missing_features.exclude_guest &&
-	    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
+	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
+		perf_missing_features.mmap2 = true;
+		goto fallback_missing_features;
+	} else if (!perf_missing_features.exclude_guest &&
+		   (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
 		perf_missing_features.exclude_guest = true;
 		goto fallback_missing_features;
 	} else if (!perf_missing_features.sample_id_all) {
@@ -1925,6 +1932,7 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(exclude_hv);
 		if_print(exclude_idle);
 		if_print(mmap);
+		if_print(mmap2);
 		if_print(comm);
 		if_print(freq);
 		if_print(inherit_stat);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index a33197a..26441d0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1351,6 +1351,9 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 
 		fprintf(fp, ", precise_ip = %d", evsel->attr.precise_ip);
 
+		fprintf(fp, ", attr_mmap2 = %d", evsel->attr.mmap2);
+		fprintf(fp, ", attr_mmap  = %d", evsel->attr.mmap);
+		fprintf(fp, ", attr_mmap_data = %d", evsel->attr.mmap_data);
 		if (evsel->ids) {
 			fprintf(fp, ", id = {");
 			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 1dca61f..933d14f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -997,6 +997,54 @@ out_problem:
 	return -1;
 }
 
+int machine__process_mmap2_event(struct machine *machine,
+				 union perf_event *event)
+{
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct thread *thread;
+	struct map *map;
+	enum map_type type;
+	int ret = 0;
+
+	if (dump_trace)
+		perf_event__fprintf_mmap2(event, stdout);
+
+	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
+	    cpumode == PERF_RECORD_MISC_KERNEL) {
+		ret = machine__process_kernel_mmap_event(machine, event);
+		if (ret < 0)
+			goto out_problem;
+		return 0;
+	}
+
+	thread = machine__findnew_thread(machine, event->mmap2.pid,
+					event->mmap2.pid);
+	if (thread == NULL)
+		goto out_problem;
+
+	if (event->header.misc & PERF_RECORD_MISC_MMAP_DATA)
+		type = MAP__VARIABLE;
+	else
+		type = MAP__FUNCTION;
+
+	map = map__new(&machine->user_dsos, event->mmap2.start,
+			event->mmap2.len, event->mmap2.pgoff,
+			event->mmap2.pid, event->mmap2.maj,
+			event->mmap2.min, event->mmap2.ino,
+			event->mmap2.ino_generation,
+			event->mmap2.filename, type);
+
+	if (map == NULL)
+		goto out_problem;
+
+	thread__insert_map(thread, map);
+	return 0;
+
+out_problem:
+	dump_printf("problem processing PERF_RECORD_MMAP2, skipping event.\n");
+	return 0;
+}
+
 int machine__process_mmap_event(struct machine *machine, union perf_event *event)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -1028,7 +1076,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 
 	map = map__new(&machine->user_dsos, event->mmap.start,
 			event->mmap.len, event->mmap.pgoff,
-			event->mmap.pid, event->mmap.filename,
+			event->mmap.pid, 0, 0, 0, 0,
+			event->mmap.filename,
 			type);
 
 	if (map == NULL)
@@ -1101,6 +1150,8 @@ int machine__process_event(struct machine *machine, union perf_event *event)
 		ret = machine__process_comm_event(machine, event); break;
 	case PERF_RECORD_MMAP:
 		ret = machine__process_mmap_event(machine, event); break;
+	case PERF_RECORD_MMAP2:
+		ret = machine__process_mmap2_event(machine, event); break;
 	case PERF_RECORD_FORK:
 		ret = machine__process_fork_event(machine, event); break;
 	case PERF_RECORD_EXIT:
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 0df925b..58a6be1 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -45,6 +45,7 @@ int machine__process_exit_event(struct machine *machine, union perf_event *event
 int machine__process_fork_event(struct machine *machine, union perf_event *event);
 int machine__process_lost_event(struct machine *machine, union perf_event *event);
 int machine__process_mmap_event(struct machine *machine, union perf_event *event);
+int machine__process_mmap2_event(struct machine *machine, union perf_event *event);
 int machine__process_event(struct machine *machine, union perf_event *event);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 9e8304c..4f6680d 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -48,7 +48,8 @@ void map__init(struct map *map, enum map_type type,
 }
 
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
+		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
+		     u64 ino_gen, char *filename,
 		     enum map_type type)
 {
 	struct map *map = malloc(sizeof(*map));
@@ -62,6 +63,11 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
 
+		map->maj = d_maj;
+		map->min = d_min;
+		map->ino = ino;
+		map->ino_generation = ino_gen;
+
 		if (anon) {
 			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
 			filename = newfilename;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 2cc93cb..4886ca2 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -36,6 +36,9 @@ struct map {
 	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
+	u32			maj, min; /* only valid for MMAP2 record */
+	u64			ino;      /* only valid for MMAP2 record */
+	u64			ino_generation;/* only valid for MMAP2 record */
 
 	/* ip -> dso rip */
 	u64			(*map_ip)(struct map *, u64);
@@ -88,8 +91,9 @@ typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso);
 struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
-		     u64 pgoff, u32 pid, char *filename,
-		     enum map_type type);
+		     u64 pgoff, u32 pid, u32 d_maj, u32 d_min, u64 ino,
+		     u64 ino_gen,
+		     char *filename, enum map_type type);
 struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 void map__delete(struct map *map);
 struct map *map__clone(struct map *map);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0308d9e..51f5edf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -351,6 +351,25 @@ static void perf_event__mmap_swap(union perf_event *event,
 	}
 }
 
+static void perf_event__mmap2_swap(union perf_event *event,
+				  bool sample_id_all)
+{
+	event->mmap2.pid   = bswap_32(event->mmap2.pid);
+	event->mmap2.tid   = bswap_32(event->mmap2.tid);
+	event->mmap2.start = bswap_64(event->mmap2.start);
+	event->mmap2.len   = bswap_64(event->mmap2.len);
+	event->mmap2.pgoff = bswap_64(event->mmap2.pgoff);
+	event->mmap2.maj   = bswap_32(event->mmap2.maj);
+	event->mmap2.min   = bswap_32(event->mmap2.min);
+	event->mmap2.ino   = bswap_64(event->mmap2.ino);
+
+	if (sample_id_all) {
+		void *data = &event->mmap2.filename;
+
+		data += PERF_ALIGN(strlen(data) + 1, sizeof(u64));
+		swap_sample_id_all(event, data);
+	}
+}
 static void perf_event__task_swap(union perf_event *event, bool sample_id_all)
 {
 	event->fork.pid	 = bswap_32(event->fork.pid);
@@ -455,6 +474,7 @@ typedef void (*perf_event__swap_op)(union perf_event *event,
 
 static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_MMAP]		  = perf_event__mmap_swap,
+	[PERF_RECORD_MMAP2]		  = perf_event__mmap2_swap,
 	[PERF_RECORD_COMM]		  = perf_event__comm_swap,
 	[PERF_RECORD_FORK]		  = perf_event__task_swap,
 	[PERF_RECORD_EXIT]		  = perf_event__task_swap,
@@ -851,7 +871,8 @@ static struct machine *
 	     (cpumode == PERF_RECORD_MISC_GUEST_USER))) {
 		u32 pid;
 
-		if (event->header.type == PERF_RECORD_MMAP)
+		if (event->header.type == PERF_RECORD_MMAP
+		    || event->header.type == PERF_RECORD_MMAP2)
 			pid = event->mmap.pid;
 		else
 			pid = sample->pid;
@@ -978,6 +999,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
+	case PERF_RECORD_MMAP2:
+		return tool->mmap2(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
 		return tool->comm(tool, event, sample, machine);
 	case PERF_RECORD_FORK:
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 62b16b6..4385816 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -29,6 +29,7 @@ struct perf_tool {
 	event_sample	sample,
 			read;
 	event_op	mmap,
+			mmap2,
 			comm,
 			fork,
 			exit,
