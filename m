Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJCFZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:25:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJCFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:25:47 -0400
Date: Thu, 2 Oct 2014 22:25:28 -0700
From: tip-bot for Chang Hyun Park <tipbot@zytor.com>
Message-ID: <tip-2c82c3ad56921c47f28af9eb8ed96b6d99b47623@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, heartinpiece@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de,
        heartinpiece@gmail.com
In-Reply-To: <1411736041-8017-1-git-send-email-heartinpiece@gmail.com>
References: <1411736041-8017-1-git-send-email-heartinpiece@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Fix mmap return address truncation to 32-bit
Git-Commit-ID: 2c82c3ad56921c47f28af9eb8ed96b6d99b47623
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c82c3ad56921c47f28af9eb8ed96b6d99b47623
Gitweb:     http://git.kernel.org/tip/2c82c3ad56921c47f28af9eb8ed96b6d99b47623
Author:     Chang Hyun Park <heartinpiece@gmail.com>
AuthorDate: Fri, 26 Sep 2014 21:54:01 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Sep 2014 15:25:36 -0300

perf trace: Fix mmap return address truncation to 32-bit

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
index c70e69e..09bcf23 100644
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
 
