Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3KDScm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:32:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3KDScY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:32:24 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/2] perf tools: Add perf_data_file__write mmap support
Date: Mon,  4 Nov 2013 19:31:45 +0100
Message-Id: <1383589905-10208-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
References: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When recording raw_syscalls for the entire system, e.g.,
  perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 10

you end up with a negative feedback loop as perf itself calls
write() fairly often. This patch handles the problem by mmap'ing the
file in chunks of 64M at a time and copies events from the event buffers
to the file avoiding write system calls.

Before (with write syscall):
  # time ./perf.old record -e raw_syscalls:*,sched:sched_switch -a -- sleep 10
  [ perf record: Woken up 0 times to write data ]
  [ perf record: Captured and wrote 914.717 MB perf.data (~39964591 samples) ]

  real    0m11.390s
  user    0m2.029s
  sys     0m9.311s

After (using mmap):
  # time ./perf record -e raw_syscalls:*,sched:sched_switch -a -- sleep 10
  [ perf record: Woken up 74 times to write data ]
  [ perf record: Captured and wrote 19.231 MB perf.data (~840219 samples) ]

  real    0m10.182s
  user    0m0.067s
  sys     0m0.121s

In addition to perf-trace benefits using mmap lowers the overhead of
perf-record.

v3: moved David's code into perf_data_file object, also used
    most of his changelog

Original-patch-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c |  11 ++---
 tools/perf/util/data.c      | 100 +++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/data.h      |   8 ++++
 3 files changed, 112 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5201677..45722fc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -240,12 +240,8 @@ out:
 
 static int process_buildids(struct perf_record *rec)
 {
-	struct perf_data_file *file  = &rec->file;
 	struct perf_session *session = rec->session;
-
-	u64 size = lseek(file->fd, 0, SEEK_CUR);
-	if (size == 0)
-		return 0;
+	u64 size = perf_data_file__size(&rec->file);
 
 	return __perf_session__process_events(session, rec->post_processing_offset,
 					      size - rec->post_processing_offset,
@@ -535,6 +531,11 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
+	if (perf_data_file__munmap(file)) {
+		pr_err("data file unmap failed\n");
+		goto out_delete_session;
+	}
+
 	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
 
 	/*
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index cce1256..af5d644 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -4,10 +4,13 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <string.h>
+#include <sys/mman.h>
 
 #include "data.h"
 #include "util.h"
 
+#define MMAP_WRITE_SIZE   (64*1024*1024)
+
 static bool check_pipe(struct perf_data_file *file)
 {
 	struct stat st;
@@ -111,6 +114,9 @@ int perf_data_file__open(struct perf_data_file *file)
 	if (!file->path)
 		file->path = "perf.data";
 
+	if (!file->mmap_size)
+		file->mmap_size = MMAP_WRITE_SIZE;
+
 	return open_file(file);
 }
 
@@ -119,8 +125,70 @@ void perf_data_file__close(struct perf_data_file *file)
 	close(file->fd);
 }
 
-ssize_t perf_data_file__write(struct perf_data_file *file,
-			      void *buf, size_t size)
+static int do_mmap(struct perf_data_file *file, u64 offset)
+{
+	u64 mmap_size = file->mmap_size;
+
+	file->mmap_off  = offset % mmap_size;
+	file->mmap_foff = (offset / mmap_size) * mmap_size;
+
+	file->mmap_addr = mmap(NULL, mmap_size,
+			       PROT_WRITE | PROT_READ,
+			       MAP_SHARED,
+			       file->fd,
+			       file->mmap_foff);
+
+	if (file->mmap_addr == MAP_FAILED) {
+		pr_err("mmap failed: %d: %s\n", errno, strerror(errno));
+		return -1;
+	}
+
+	/* Expand file to include this mmap segment. */
+	if (ftruncate(file->fd, file->mmap_foff + file->mmap_size) != 0) {
+		pr_err("ftruncate failed: %d: %s\n", errno, strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static ssize_t write_mmap(struct perf_data_file *file,
+			  void *buf, size_t size)
+{
+	ssize_t total = size;
+
+	if (!file->mmap_addr) {
+		off_t offset = lseek(file->fd, 0, SEEK_CUR);
+		if (offset < 0)
+			return -1;
+
+		if (do_mmap(file, offset))
+			return -1;
+	}
+
+	while (size) {
+		u64 remain = file->mmap_size - file->mmap_off;
+
+		if (size > remain) {
+			memcpy(file->mmap_addr + file->mmap_off, buf, remain);
+			size -= remain;
+			buf  += remain;
+
+			munmap(file->mmap_addr, file->mmap_size);
+			if (do_mmap(file, file->mmap_foff + file->mmap_size))
+				return -1;
+		} else {
+			memcpy(file->mmap_addr + file->mmap_off, buf, size);
+			file->mmap_off += size;
+			size = 0;
+		}
+	}
+
+	return total;
+}
+
+static ssize_t write_raw(struct perf_data_file *file,
+			 void *buf, size_t size)
 {
 	ssize_t total = size;
 
@@ -138,3 +206,31 @@ ssize_t perf_data_file__write(struct perf_data_file *file,
 
 	return total;
 }
+
+ssize_t perf_data_file__write(struct perf_data_file *file,
+			      void *buf, size_t size)
+{
+	return file->is_pipe ? write_raw(file, buf, size) :
+			       write_mmap(file, buf, size);
+}
+
+int perf_data_file__munmap(struct perf_data_file *file)
+{
+	if (file->mmap_addr) {
+		int ret;
+
+		munmap(file->mmap_addr, file->mmap_size);
+
+		file->mmap_addr = NULL;
+		file->size = file->mmap_foff + file->mmap_off;
+
+		ret = ftruncate(file->fd, file->size);
+		if (ret)
+			pr_err("ftruncate failed: %d: %s\n", errno,
+			       strerror(errno));
+
+		return ret;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 02c53dc..de59ee0 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -2,6 +2,7 @@
 #define __PERF_DATA_H
 
 #include <stdbool.h>
+#include "types.h"
 
 enum perf_data_mode {
 	PERF_DATA_MODE_WRITE,
@@ -15,6 +16,12 @@ struct perf_data_file {
 	bool			 force;
 	unsigned long		 size;
 	enum perf_data_mode	 mode;
+
+	/* for MMAP based file writes */
+	void			*mmap_addr;
+	u64			 mmap_off;
+	u64			 mmap_foff;
+	u64			 mmap_size;
 };
 
 static inline bool perf_data_file__is_read(struct perf_data_file *file)
@@ -46,4 +53,5 @@ int perf_data_file__open(struct perf_data_file *file);
 void perf_data_file__close(struct perf_data_file *file);
 ssize_t perf_data_file__write(struct perf_data_file *file,
 			      void *buf, size_t size);
+int perf_data_file__munmap(struct perf_data_file *file);
 #endif /* __PERF_DATA_H */
-- 
1.7.11.7

