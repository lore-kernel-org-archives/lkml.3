Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3H2KJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab3H2KJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:09:56 -0400
Date: Thu, 29 Aug 2013 03:09:17 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Simplify sys_exit return printing
Git-Commit-ID: da3c9a448af7ab2beab62cfff42bdea9590d9bea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:09:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da3c9a448af7ab2beab62cfff42bdea9590d9bea
Gitweb:     http://git.kernel.org/tip/da3c9a448af7ab2beab62cfff42bdea9590d9bea
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 26 Aug 2013 11:28:34 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Aug 2013 17:25:50 -0300

perf trace: Simplify sys_exit return printing

Avoiding multiple sc->fmt != NULL tests.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-w28d1o3uslden0k57653kda7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 86568ed..9e23660 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -464,16 +464,19 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		fprintf(trace->output, "]: %s()", sc->name);
 	}
 
-	if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
+	if (sc->fmt == NULL) {
+signed_print:
+		fprintf(trace->output, ") = %d", ret);
+	} else if (ret < 0 && sc->fmt->errmsg) {
 		char bf[256];
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
 			   *e = audit_errno_to_name(-ret);
 
 		fprintf(trace->output, ") = -1 %s %s", e, emsg);
-	} else if (ret == 0 && sc->fmt && sc->fmt->timeout)
+	} else if (ret == 0 && sc->fmt->timeout)
 		fprintf(trace->output, ") = 0 Timeout");
 	else
-		fprintf(trace->output, ") = %d", ret);
+		goto signed_print;
 
 	fputc('\n', trace->output);
 out:
