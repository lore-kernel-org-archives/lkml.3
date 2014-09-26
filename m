Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaIZMyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:54:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47525 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaIZMyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:54:14 -0400
From: Chang Hyun Park <heartinpiece@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH 1/1] perf: Fixed perf trace, 32bit return values to 64bit
Date: Fri, 26 Sep 2014 21:54:01 +0900
Message-Id: <1411736041-8017-1-git-send-email-heartinpiece@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf trace for syscalls resulted in mmap return values being stripped of
the top 32 bits, and actually printing only the lower 32 bits. This was
because the ret value was of an 'int' type and not a 'long' type.

The Problem:
991258501.244 ( 0.004 ms): mmap(len: 40001536, prot: READ|WRITE, flags:
		PRIVATE|ANONYMOUS, fd: -1) = 0x56691000
991258501.257 ( 0.000 ms): minfault [_int_malloc+0x1038] =>
			    //anon@0x7fa056691008 //(d.)

The first line shows an mmap, which succeeds and returns 0x56691000.
However the next line shows a memory access to that virtual memory area,
specifically to 0x7fa056691008. The upper 32 bit is lost due to the
problem mentioned above, and thus mmap's return value didn't have the
upper 0x7fa0.

Tested on 3.17-rc5 from the linus's tree, and the HEAD of tip/master

Signed-off-by: Chang Hyun Park <heartinpiece@gmail.com>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a6c3752..31a7b69 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1669,7 +1669,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 			   union perf_event *event __maybe_unused,
 			   struct perf_sample *sample)
 {
-	int ret;
+	long ret;
 	u64 duration = 0;
 	struct thread *thread;
 	int id = perf_evsel__sc_tp_uint(evsel, id, sample);
@@ -1722,7 +1722,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 
 	if (sc->fmt == NULL) {
 signed_print:
-		fprintf(trace->output, ") = %d", ret);
+		fprintf(trace->output, ") = %ld", ret);
 	} else if (ret < 0 && sc->fmt->errmsg) {
 		char bf[256];
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
@@ -1732,7 +1732,7 @@ signed_print:
 	} else if (ret == 0 && sc->fmt->timeout)
 		fprintf(trace->output, ") = 0 Timeout");
 	else if (sc->fmt->hexret)
-		fprintf(trace->output, ") = %#x", ret);
+		fprintf(trace->output, ") = %#lx", ret);
 	else
 		goto signed_print;
 
-- 
1.9.1

