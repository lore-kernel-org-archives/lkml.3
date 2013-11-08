Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879Ab3KHQwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:52:21 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42477 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3KHQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:52:20 -0500
Message-ID: <527D16C1.3070206@gmail.com>
Date: Fri, 08 Nov 2013 09:52:17 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com> <1383884605-30968-3-git-send-email-dsahern@gmail.com> <20131108093455.GA1230@krava.brq.redhat.com>
In-Reply-To: <20131108093455.GA1230@krava.brq.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------070406010002070303000208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070406010002070303000208
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

On 11/8/13, 2:34 AM, Jiri Olsa wrote:
>> +	if (ftruncate(fd, len) != 0)
>> +		pr_err("ftruncate failed\n");
>
> I think we should fail here and dont let the finishing
> code run on probably corrupted file.
>
> the code that process build IDs could even get stuck

Yes, I'll fix that in v5.

It also got me to thinking about failure scenarios -- like out of space. 
I was looking at this path using a size-limited tmpfs (max 1M) and 
writing perf.data into it.

Today (without this mmap output page) if the write() fails due to lack 
of space then perf emits the message:
   failed to write perf data, error: No space left on device

and stops — killing the workload too. Trying to read and process the 
perf.data file fails with a SIGBUS error.  I just sent a patch this 
addresses that problem.

Using that patch as a start point and moving to mmap-based output if the 
filesystem runs out of space the memcpy generates a SIGBUS and we need 
to jump out of the memcpy. The attached fixes that problem.

Any objections to using a sigjmp? Other option is to die in the signal 
handler.  That option is harder to clean up.

David




--------------070406010002070303000208
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="perf-record-handle-mmap-write-failure.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf-record-handle-mmap-write-failure.patch"

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 947970e182a5..b50f384d9a36 100644
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
@@ -526,6 +535,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
+	signal(SIGBUS, sig_handler);
 
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {

--------------070406010002070303000208--
