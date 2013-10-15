Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab3JOF2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3JOF2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:10 -0400
Date: Mon, 14 Oct 2013 22:27:32 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6hnoqsjh99t4hxi3xu2nlwep@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Don'
 t supress zeroed args when there is an strarray entry for it
Git-Commit-ID: 4aa5823225c70efba758750029504807cd30b925
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4aa5823225c70efba758750029504807cd30b925
Gitweb:     http://git.kernel.org/tip/4aa5823225c70efba758750029504807cd30b925
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Sep 2013 12:19:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:41:02 -0300

perf trace: Don't supress zeroed args when there is an strarray entry for it

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
index 8855207..27b0ec8 100644
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
