Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3KLOsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:48:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53814 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab3KLOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:47:18 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf record: mmap output file - v5
Date: Tue, 12 Nov 2013 07:46:56 -0700
Message-Id: <1384267617-3446-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When recording raw_syscalls for the entire system, e.g.,
    perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1

you end up with a negative feedback loop as perf itself calls write() fairly
often. This patch handles the problem by mmap'ing the file in chunks of 64M at
a time and copies events from the event buffers to the file avoiding write
system calls.

Before (with write syscall):

    perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
    [ perf record: Woken up 0 times to write data ]
    [ perf record: Captured and wrote 81.843 MB /tmp/perf.data (~3575786 samples) ]

After (using mmap):

    perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
    [ perf record: Woken up 31 times to write data ]
    [ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]

In addition to perf-trace benefits using mmap lowers the overhead of
perf-record. For example,

  perf stat -i -- perf record -g -o /tmp/perf.data openssl speed aes

shows a drop in time, CPU cycles, and instructions all drop by more than a
factor of 3. Jiri also ran a test that showed a big improvement.

v5: Addressed misc comments from Jiri, Adrian and Arnaldo. Added -O shortcut
    for --out-pages. Added -O 0 as a means to fall back to write

v4: Refactoring per Ingo's comments

v3: Removed use of bytes_at_mmap_start at the stat() that set it
    Added user option to control the size of the mmap for writing file.

v2: Removed msync call before munmap per Jiri's suggestion

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-record.txt |   7 ++
 tools/perf/builtin-record.c              | 164 +++++++++++++++++++++++++++++++
 tools/perf/util/evlist.c                 |  23 +++++
 tools/perf/util/evlist.h                 |   3 +
 4 files changed, 197 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 052f7c4dc00c..7c67dad9e341 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -201,6 +201,13 @@ abort events and some memory events in precise mode on modern Intel CPUs.
 --transaction::
 Record transaction flags for transaction related events.
 
+-O::
+--out-pages=::
+Number of pages to mmap for writing data to file or size specification
+with appended unit character - B/K/M/G. The size is rounded up to have nearest
+pages power of two value. 0 falls back to write instead of mmap. Default size
+is 64M.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 880227eae20f..1a4fa5df215b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -30,6 +30,9 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+/* output file mmap'ed N chunks at a time */
+#define MMAP_OUTPUT_SIZE   (64*1024*1024)
+
 #ifndef HAVE_ON_EXIT_SUPPORT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
@@ -65,6 +68,16 @@ static void __handle_on_exit_funcs(void)
 struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
+
+	/* for MMAP based file writes */
+	struct {
+		void		*addr;
+		u64		offset;     /* current location within mmap */
+		unsigned int	out_pages;  /* user configurable option */
+		size_t		out_size;   /* size of mmap segments */
+		bool		use;
+	} mmap;
+
 	u64			bytes_written;
 	struct perf_data_file	file;
 	struct perf_evlist	*evlist;
@@ -76,6 +89,95 @@ struct perf_record {
 	long			samples;
 };
 
+static int mmap_next_segment(struct perf_record *rec, off_t offset)
+{
+	struct perf_data_file *file = &rec->file;
+
+	/* extend file to include a new mmap segment */
+	if (ftruncate(file->fd, offset + rec->mmap.out_size) != 0) {
+		pr_err("ftruncate failed\n");
+		return -1;
+	}
+
+	rec->mmap.addr = mmap(NULL, rec->mmap.out_size,
+			      PROT_WRITE | PROT_READ, MAP_SHARED,
+			      file->fd, offset);
+
+	if (rec->mmap.addr == MAP_FAILED) {
+		pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
+
+		/* reset file size */
+		if (ftruncate(file->fd, offset) != 0)
+			pr_err("ftruncate failed too. Is it Halloween?\n");
+
+		return -1;
+	}
+
+	return 0;
+}
+
+static off_t next_mmap_offset(struct perf_record *rec)
+{
+	off_t offset;
+
+	/*
+	 * for first segment, mmap offset is current amount of data
+	 * already written to file. For follow on segments the output
+	 * starts at 0.
+	 */
+	offset = rec->session->header.data_offset + rec->bytes_written;
+	if (offset < (ssize_t) rec->mmap.out_size) {
+		rec->mmap.offset = offset;
+		offset = 0;
+	} else {
+		rec->mmap.offset = 0;
+	}
+
+	/* returning offset within file - used for mmap of next segment */
+	return offset;
+}
+
+static int do_mmap_output(struct perf_record *rec, void *buf, size_t size)
+{
+	u64 remaining;
+	off_t offset;
+
+	if (rec->mmap.addr == NULL) {
+next_segment:
+		offset = next_mmap_offset(rec);
+		if (mmap_next_segment(rec, offset) != 0)
+			return -1;
+	}
+
+	/* amount of space in current mmap segment */
+	remaining = rec->mmap.out_size - rec->mmap.offset;
+
+	/*
+	 * if current size to write is more than the available
+	 * space write what we can then go back and create the
+	 * next segment
+	 */
+	if (size > remaining) {
+		memcpy(rec->mmap.addr + rec->mmap.offset, buf, remaining);
+		rec->bytes_written += remaining;
+
+		size -= remaining;
+		buf  += remaining;
+
+		munmap(rec->mmap.addr, rec->mmap.out_size);
+		goto next_segment;
+	}
+
+	/* more data to copy and it fits in the current segment */
+	if (size) {
+		memcpy(rec->mmap.addr + rec->mmap.offset, buf, size);
+		rec->bytes_written += size;
+		rec->mmap.offset += size;
+	}
+
+	return 0;
+}
+
 static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
@@ -99,6 +201,9 @@ static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 
 static int write_output(struct perf_record *rec, void *buf, size_t size)
 {
+	if (rec->mmap.use)
+		return do_mmap_output(rec, buf, size);
+
 	return do_write_output(rec, buf, size);
 }
 
@@ -361,6 +466,52 @@ static void perf_record__init_features(struct perf_record *rec)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 }
 
+static int mmap_output_fini(struct perf_record *rec)
+{
+	off_t len;
+	int fd;
+
+	if (!rec->mmap.use)
+		return 0;
+
+	rec->mmap.use = false;
+
+	len = rec->session->header.data_offset + rec->bytes_written;
+	fd = rec->file.fd;
+
+	munmap(rec->mmap.addr, rec->mmap.out_size);
+	rec->mmap.addr = NULL;
+
+	if (ftruncate(fd, len) != 0) {
+		pr_err("ftruncate failed\n");
+		return -1;
+	}
+
+	/*
+	 * Set output pointer to end of file
+	 * eg., needed for buildid processing
+	 */
+	if (lseek(fd, 0, SEEK_END) == (off_t) -1) {
+		pr_err("ftruncate failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+static void mmap_output_init(struct perf_record *rec)
+{
+	struct perf_data_file *file = &rec->file;
+
+	if (file->is_pipe)
+		return;
+
+	rec->mmap.out_size = rec->mmap.out_pages * page_size;
+
+	if (rec->mmap.out_size)
+		rec->mmap.use = true;
+}
+
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	int err;
@@ -434,6 +585,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
+	mmap_output_init(rec);
+
 	machine = &session->machines.host;
 
 	if (file->is_pipe) {
@@ -541,6 +694,11 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
+	if (mmap_output_fini(rec) != 0) {
+		err = -1;
+		goto out_delete_session;
+	}
+
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
@@ -802,6 +960,9 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
+	.mmap = {
+		.out_size = MMAP_OUTPUT_SIZE,
+	},
 };
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
@@ -888,6 +1049,9 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
+	OPT_CALLBACK('O', "out-pages", &record.mmap.out_pages, "pages",
+		     "Number of pages or size with units to use for output (default 64M)",
+		     perf_evlist__parse_out_pages),
 	OPT_END()
 };
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cb19044601bb..3d1f7faa30d7 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -767,6 +767,29 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	return 0;
 }
 
+int perf_evlist__parse_out_pages(const struct option *opt, const char *str,
+				  int unset __maybe_unused)
+{
+	unsigned int *out_pages = opt->value;
+	unsigned long max = UINT_MAX;
+	long pages;
+
+	if (max < SIZE_MAX / page_size)
+		max = SIZE_MAX / page_size;
+
+	pages = parse_pages_arg(str, 0, max);
+	if (pages < 0) {
+		pr_err("Invalid argument for --out-pages/-O\n");
+		return -1;
+	}
+
+	if (pages == 0)
+		pr_debug("Reverting to write instead of mmap for output file\n");
+
+	*out_pages = pages;
+	return 0;
+}
+
 /**
  * perf_evlist__mmap - Create mmaps to receive events.
  * @evlist: list of events
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ecaa582f40e2..749488147276 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -107,6 +107,9 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  bool want_signal);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
+int perf_evlist__parse_out_pages(const struct option *opt,
+				  const char *str, int unset);
+
 int perf_evlist__parse_mmap_pages(const struct option *opt,
 				  const char *str,
 				  int unset);
-- 
1.8.3.4 (Apple Git-47)

