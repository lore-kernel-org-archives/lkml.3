Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaJATvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:51:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:47765 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaJATvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:51:04 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chang Hyun Park <heartinpiece@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/8] perf trace: Fix mmap return address truncation to 32-bit
Date: Wed,  1 Oct 2014 16:50:37 -0300
Message-Id: <1412193043-15493-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412193043-15493-1-git-send-email-acme@kernel.org>
References: <1412193043-15493-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chang Hyun Park <heartinpiece@gmail.com>

Using 'perf trace' for mmap is truncating return values by stripping the
top 32 bits, actually printing only the lower 32 bits.

This was because the ret value was of an 'int' type and not a 'long'
type.

  The Problem:

  991258501.244 ( 0.004 ms): mmap(len: 40001536, prot: READ|WRITE, flags: PRIVATE|ANONYMOUS, fd: -1) = 0x56691000
  991258501.257 ( 0.000 ms): minfault [_int_malloc+0x1038] => //anon@0x7fa056691008 //(d.)

The first line shows an mmap, which succeeds and returns 0x56691000.

However the next line shows a memory access to that virtual memory area,
specifically to 0x7fa056691008. The upper 32 bit is lost due to the
problem mentioned above, and thus mmap's return value didn't have the
upper 0x7fa0.

Tested on 3.17-rc5 from the linus's tree, and the HEAD of tip/master

Signed-off-by: Chang Hyun Park <heartinpiece@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1411736041-8017-1-git-send-email-heartinpiece@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c70e69ea1c5d..09bcf2393910 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1695,7 +1695,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 			   union perf_event *event __maybe_unused,
 			   struct perf_sample *sample)
 {
-	int ret;
+	long ret;
 	u64 duration = 0;
 	struct thread *thread;
 	int id = perf_evsel__sc_tp_uint(evsel, id, sample);
@@ -1748,7 +1748,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 
 	if (sc->fmt == NULL) {
 signed_print:
-		fprintf(trace->output, ") = %d", ret);
+		fprintf(trace->output, ") = %ld", ret);
 	} else if (ret < 0 && sc->fmt->errmsg) {
 		char bf[STRERR_BUFSIZE];
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
@@ -1758,7 +1758,7 @@ signed_print:
 	} else if (ret == 0 && sc->fmt->timeout)
 		fprintf(trace->output, ") = 0 Timeout");
 	else if (sc->fmt->hexret)
-		fprintf(trace->output, ") = %#x", ret);
+		fprintf(trace->output, ") = %#lx", ret);
 	else
 		goto signed_print;
 
-- 
1.9.3

