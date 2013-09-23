Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3IWCGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:06:08 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40736 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3IWCGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:06:06 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf record: mmap output file - RFC
Date: Sun, 22 Sep 2013 20:05:59 -0600
Message-Id: <1379901959-5285-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When recording raw_syscalls for the entire system, e.g.,
    perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 1

you end up with a negative feedback loop as perf itself calls
write() fairly often. This patch mmap's the file in chunks of 64M
at a time and copies events from the event buffers to the file
avoiding write system calls.

Before (with write syscall):

perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 81.843 MB /tmp/perf.data (~3575786 samples) ]

After (using mmap):

perf record -o /tmp/perf.data -e raw_syscalls:*,sched:sched_switch -a -- sleep 1
[ perf record: Woken up 31 times to write data ]
[ perf record: Captured and wrote 8.203 MB /tmp/perf.data (~358388 samples) ]

Before I get too far down this path I wanted to get comments on the approach.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c |   87 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index da13840..45bb565 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -29,6 +29,9 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+/* mmap file big chunks at a time */
+#define MMAP_OUTPUT_SIZE   (64*1024*1024)
+
 #ifndef HAVE_ON_EXIT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
@@ -64,6 +67,14 @@ static void __handle_on_exit_funcs(void)
 struct perf_record {
 	struct perf_tool	tool;
 	struct perf_record_opts	opts;
+
+	/* for MMAP based file writes */
+	void			*mmap_addr;
+	u64			bytes_at_mmap_start; /* bytes in file when mmap use starts */
+	u64			mmap_offset;    /* current location within mmap */
+	size_t			mmap_size;      /* size of mmap segments */
+	bool			use_mmap;
+
 	u64			bytes_written;
 	const char		*output_name;
 	struct perf_evlist	*evlist;
@@ -82,8 +93,66 @@ static void advance_output(struct perf_record *rec, size_t size)
 	rec->bytes_written += size;
 }
 
+static int do_mmap_output(struct perf_record *rec, void *buf, size_t size)
+{
+	u64 remaining;
+	off_t offset;
+
+	if (rec->mmap_addr == NULL) {
+do_mmap:
+		offset = rec->bytes_at_mmap_start + rec->bytes_written;
+		if (offset < (ssize_t) rec->mmap_size) {
+			rec->mmap_offset = offset;
+			offset = 0;
+		} else
+			rec->mmap_offset = 0;
+
+		rec->mmap_addr = mmap(NULL, rec->mmap_size,
+				     PROT_WRITE | PROT_READ,
+				     MAP_SHARED,
+				     rec->output,
+				     offset);
+
+		if (rec->mmap_addr == MAP_FAILED) {
+			pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
+			return -1;
+		}
+
+		/* expand file to include this mmap segment */
+		if (ftruncate(rec->output, offset + rec->mmap_size) != 0) {
+			pr_err("ftruncate failed\n");
+			return -1;
+		}
+	}
+
+	remaining = rec->mmap_size - rec->mmap_offset;
+
+	if (size > remaining) {
+		memcpy(rec->mmap_addr + rec->mmap_offset, buf, remaining);
+		rec->bytes_written += remaining;
+
+		size -= remaining;
+		buf  += remaining;
+
+		msync(rec->mmap_addr, rec->mmap_size, MS_ASYNC);
+		munmap(rec->mmap_addr, rec->mmap_size);
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
+	if (rec->use_mmap)
+		return do_mmap_output(rec, buf, size);
+
 	while (size) {
 		int ret = write(rec->output, buf, size);
 
@@ -546,6 +615,11 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(evsel_list);
 
+	if (!rec->opts.pipe_output && stat(output_name, &st) == 0) {
+		rec->use_mmap = true;
+		rec->bytes_at_mmap_start = st.st_size - rec->bytes_written;
+	}
+
 	for (;;) {
 		int hits = rec->samples;
 
@@ -572,6 +646,18 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		}
 	}
 
+	if (rec->use_mmap) {
+		off_t len = rec->bytes_at_mmap_start + rec->bytes_written;
+
+		rec->use_mmap = false;
+		msync(rec->mmap_addr, rec->mmap_size, MS_ASYNC);
+		munmap(rec->mmap_addr, rec->mmap_size);
+		rec->mmap_addr = NULL;
+
+		if (ftruncate(rec->output, len) != 0)
+			pr_err("ftruncate failed\n");
+	}
+
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
@@ -804,6 +890,7 @@ static struct perf_record record = {
 			.uses_mmap   = true,
 		},
 	},
+	.mmap_size = MMAP_OUTPUT_SIZE,
 };
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
-- 
1.7.10.1

