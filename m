Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3KLOr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:47:29 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44262 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab3KLOrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:47:24 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/5] perf record: Handle out of space failures writing data with mmap
Date: Tue, 12 Nov 2013 07:46:57 -0700
Message-Id: <1384267617-3446-6-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
References: <1384267617-3446-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the filesystem where a file is written using mmap fills perf record
gets a SIGBUS and terminated. Handle the SIGBUS by using longjmp to
bounce out of the memcpy and fail the write.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1a4fa5df215b..48d6535d144f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -29,9 +29,11 @@
 #include <unistd.h>
 #include <sched.h>
 #include <sys/mman.h>
+#include <setjmp.h>
 
 /* output file mmap'ed N chunks at a time */
 #define MMAP_OUTPUT_SIZE   (64*1024*1024)
+sigjmp_buf mmap_jmp;
 
 #ifndef HAVE_ON_EXIT_SUPPORT
 #ifndef ATEXIT_MAX
@@ -141,6 +143,7 @@ static int do_mmap_output(struct perf_record *rec, void *buf, size_t size)
 {
 	u64 remaining;
 	off_t offset;
+	volatile size_t total_len = 0;
 
 	if (rec->mmap.addr == NULL) {
 next_segment:
@@ -157,20 +160,23 @@ next_segment:
 	 * space write what we can then go back and create the
 	 * next segment
 	 */
-	if (size > remaining) {
-		memcpy(rec->mmap.addr + rec->mmap.offset, buf, remaining);
+	if (setjmp(mmap_jmp) != 0) {
+		pr_err("mmap copy failed.\n");
+		return -1;
+	}
+	if (size-total_len > remaining) {
+		memcpy(rec->mmap.addr + rec->mmap.offset, buf+total_len, remaining);
 		rec->bytes_written += remaining;
 
-		size -= remaining;
-		buf  += remaining;
+		total_len += remaining;
 
 		munmap(rec->mmap.addr, rec->mmap.out_size);
 		goto next_segment;
 	}
 
 	/* more data to copy and it fits in the current segment */
-	if (size) {
-		memcpy(rec->mmap.addr + rec->mmap.offset, buf, size);
+	if (size - total_len) {
+		memcpy(rec->mmap.addr + rec->mmap.offset, buf+total_len, size-total_len);
 		rec->bytes_written += size;
 		rec->mmap.offset += size;
 	}
@@ -272,6 +278,9 @@ static void sig_handler(int sig)
 	if (sig == SIGCHLD)
 		child_finished = 1;
 
+	if (sig == SIGBUS)
+		longjmp(mmap_jmp, 1);
+
 	done = 1;
 	signr = sig;
 }
@@ -532,6 +541,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
+	signal(SIGBUS, sig_handler);
 
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
-- 
1.8.3.4 (Apple Git-47)

