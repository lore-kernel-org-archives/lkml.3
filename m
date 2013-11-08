Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3KHEXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:23:43 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42366 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3KHEXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:23:36 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf record: mmap output file - v4
Date: Thu,  7 Nov 2013 21:23:25 -0700
Message-Id: <1383884605-30968-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com>
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

v4: Refactoring per Ingo's comments

v3: Removed use of bytes_at_mmap_start at the stat() that set it
    Added user option to control the size of the mmap for writing file.

v2: Removed msync call before munmap per Jiri's suggestion

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-record.txt |   5 +
 tools/perf/builtin-record.c              | 155 +++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 052f7c4dc00c..af11c2dd2360 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -201,6 +201,11 @@ abort events and some memory events in precise mode on modern Intel CPUs.
 --transaction::
 Record transaction flags for transaction related events.
 
+--out-pages=::
+Number of pages to mmap for writing data to file or size specification
+with appended unit character - B/K/M/G. The size is rounded up to have nearest
+pages power of two value.  Default size is 64M.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6e6a41856c41..72dd983832f5 100644
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
 
@@ -361,6 +466,46 @@ static void perf_record__init_features(struct perf_record *rec)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 }
 
+static void mmap_output_fini(struct perf_record *rec)
+{
+	off_t len;
+	int fd;
+
+	if (!rec->mmap.use)
+		return;
+
+	rec->mmap.use = false;
+
+	len = rec->session->header.data_offset + rec->bytes_written;
+	fd = rec->file.fd;
+
+	munmap(rec->mmap.addr, rec->mmap.out_size);
+	rec->mmap.addr = NULL;
+
+	if (ftruncate(fd, len) != 0)
+		pr_err("ftruncate failed\n");
+
+	/*
+	 * Set output pointer to end of file
+	 * eg., needed for buildid processing
+	 */
+	lseek(fd, len, SEEK_SET);
+}
+
+static void mmap_output_init(struct perf_record *rec)
+{
+	struct perf_data_file *file = &rec->file;
+
+	if (file->is_pipe)
+		return;
+
+	if (rec->mmap.out_pages)
+		rec->mmap.out_size = rec->mmap.out_pages * page_size;
+
+	if (rec->mmap.out_size)
+		rec->mmap.use = true;
+}
+
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	int err;
@@ -434,6 +579,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
+	mmap_output_init(rec);
+
 	machine = &session->machines.host;
 
 	if (file->is_pipe) {
@@ -549,6 +696,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
+	mmap_output_fini(rec);
+
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
@@ -810,6 +959,9 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
+	.mmap = {
+		.out_size = MMAP_OUTPUT_SIZE,
+	},
 };
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
@@ -896,6 +1048,9 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
+	OPT_CALLBACK(0, "out-pages", &record.mmap.out_pages, "pages",
+		     "Number of pages or size with units to use for output (default 64M)",
+		     perf_evlist__parse_mmap_pages),
 	OPT_END()
 };
 
-- 
1.8.3.4 (Apple Git-47)

