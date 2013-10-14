Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3JNUUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39016 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 103/161] perf trace: Don't supress zeroed args when there is an strarray entry for it
Date: Mon, 14 Oct 2013 17:01:32 -0300
Message-Id: <1381780950-25642-104-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Case in hand:

   9.682 ( 0.001 ms): Xorg/13079 setitimer(which: REAL, value: 0x7fffede42470) = 0

ITIMER_REAL is zero.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6hnoqsjh99t4hxi3xu2nlwep@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8855207deae8..27b0ec88cb23 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -940,8 +940,15 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 		     field = field->next, ++arg.idx, bit <<= 1) {
 			if (arg.mask & bit)
 				continue;
-
-			if (args[arg.idx] == 0)
+			/*
+ 			 * Suppress this argument if its value is zero and
+ 			 * and we don't have a string associated in an
+ 			 * strarray for it.
+ 			 */
+			if (args[arg.idx] == 0 &&
+			    !(sc->arg_scnprintf &&
+			      sc->arg_scnprintf[arg.idx] == SCA_STRARRAY &&
+			      sc->arg_parm[arg.idx]))
 				continue;
 
 			printed += scnprintf(bf + printed, size - printed,
-- 
1.8.1.4

