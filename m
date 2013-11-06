Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3KFSm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:42:29 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63172 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3KFSlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:41:52 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf record: mmap output file - v3
Date: Wed,  6 Nov 2013 11:41:37 -0700
Message-Id: <1383763297-27066-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
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

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-record.txt |  5 ++
 tools/perf/builtin-record.c              | 97 ++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 052f7c4dc00c..5cd305eb1698 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -201,6 +201,11 @@ abort events and some memory events in precise mode on modern Intel CPUs.
 --transaction::
 Record transaction flags for transaction related events.
 
+--out-pages=::
+	Number of pages to mmap while writing data to file (must be a power of two).
+	Specification can be appended with unit character - B/K/M/G. The
+	size is rounded up to have nearest pages power of two value.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-list[1]
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 15280b5e5574..3cf563eb7896 100644
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
@@ -65,6 +68,14 @@ static void __handle_on_exit_funcs(void)
 struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
+
+	/* for MMAP based file writes */
+	void			*mmap_addr;
+	u64			mmap_offset;     /* current location within mmap */
+	unsigned int		mmap_out_pages;  /* user configurable option */
+	size_t			mmap_out_size;   /* size of mmap segments */
+	bool			use_mmap;
+
 	u64			bytes_written;
 	struct perf_data_file	file;
 	struct perf_evlist	*evlist;
@@ -76,10 +87,68 @@ struct perf_record {
 	long			samples;
 };
 
+static int do_mmap_output(struct perf_record *rec, void *buf, size_t size)
+{
+	struct perf_data_file *file = &rec->file;
+	u64 remaining;
+	off_t offset;
+
+	if (rec->mmap_addr == NULL) {
+do_mmap:
+		offset = rec->session->header.data_offset + rec->bytes_written;
+		if (offset < (ssize_t) rec->mmap_out_size) {
+			rec->mmap_offset = offset;
+			offset = 0;
+		} else
+			rec->mmap_offset = 0;
+
+		/* extend file to include a new mmap segment */
+		if (ftruncate(file->fd, offset + rec->mmap_out_size) != 0) {
+			pr_err("ftruncate failed\n");
+			return -1;
+		}
+
+		rec->mmap_addr = mmap(NULL, rec->mmap_out_size,
+				      PROT_WRITE | PROT_READ, MAP_SHARED,
+				      file->fd, offset);
+
+		if (rec->mmap_addr == MAP_FAILED) {
+			pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
+			/* reset file size */
+			ftruncate(file->fd, offset);
+			return -1;
+		}
+	}
+
+	remaining = rec->mmap_out_size - rec->mmap_offset;
+
+	if (size > remaining) {
+		memcpy(rec->mmap_addr + rec->mmap_offset, buf, remaining);
+		rec->bytes_written += remaining;
+
+		size -= remaining;
+		buf  += remaining;
+
+		munmap(rec->mmap_addr, rec->mmap_out_size);
+		goto do_mmap;
+	}
+
+	if (size) {
+		memcpy(rec->mmap_addr + rec->mmap_offset, buf, size);
+		rec->bytes_written += size;
+		rec->mmap_offset += size;
+	}
+
+	return 0;
+}
+
 static int write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
 
+	if (rec->use_mmap)
+		return do_mmap_output(rec, buf, size);
+
 	while (size) {
 		int ret = write(file->fd, buf, size);
 
@@ -429,6 +498,12 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
+	if (!file->is_pipe && rec->mmap_out_size) {
+		if (rec->mmap_out_pages)
+			rec->mmap_out_size = rec->mmap_out_pages * page_size;
+		rec->use_mmap = true;
+	}
+
 	machine = &session->machines.host;
 
 	if (file->is_pipe) {
@@ -544,6 +619,24 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
+	if (rec->use_mmap) {
+		off_t len = rec->session->header.data_offset + rec->bytes_written;
+		int fd = rec->file.fd;
+
+		rec->use_mmap = false;
+		munmap(rec->mmap_addr, rec->mmap_out_size);
+		rec->mmap_addr = NULL;
+
+		if (ftruncate(fd, len) != 0)
+			pr_err("ftruncate failed\n");
+
+		/*
+		 * Set output pointer to end of file
+		 * eg., needed for buildid processing
+		 */
+		lseek(fd, len, SEEK_SET);
+	}
+
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
@@ -805,6 +898,7 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
+	.mmap_out_size = MMAP_OUTPUT_SIZE,
 };
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
@@ -891,6 +985,9 @@ const struct option record_options[] = {
 		    "sample by weight (on special events only)"),
 	OPT_BOOLEAN(0, "transaction", &record.opts.sample_transaction,
 		    "sample transaction flags (special events only)"),
+	OPT_CALLBACK(0, "out-pages", &record.mmap_out_pages, "pages",
+		     "number of pages to use for output chunks.",
+		     perf_evlist__parse_mmap_pages),
 	OPT_END()
 };
 
-- 
1.8.3.4 (Apple Git-47)

