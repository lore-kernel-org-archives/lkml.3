Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab3DBJ7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:59:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3DBJ7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:59:48 -0400
Date: Tue, 2 Apr 2013 02:59:30 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-hg4s6e5txiwqe00h8rdg1sin@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] Revert "perf sched:
  Handle PERF_RECORD_EXIT events"
Git-Commit-ID: 1c6763cb9962d6d83a8470934c20ed525ef62355
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 02:59:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1c6763cb9962d6d83a8470934c20ed525ef62355
Gitweb:     http://git.kernel.org/tip/1c6763cb9962d6d83a8470934c20ed525ef62355
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 27 Mar 2013 10:34:49 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:22:34 -0300

Revert "perf sched: Handle PERF_RECORD_EXIT events"

This reverts commit 0439539f72ea222fbfe511b47318b9c1815a7108.

This caused this segfault:

[root@sandy linux]# perf sched rec
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 1.306 MB perf.data (~57062 samples) ]
perf
[root@sandy linux]# perf sched lat
perf: builtin-sched.c:781: thread_atoms_search: Assertion `!(thread != atoms->thread)' failed.
Aborted (core dumped)
[root@sandy linux]#

Further investigation is needed to check that even with machine__remove_thread()
not really deleting the thread referenced in the PERF_RECORD_EXIT (it goes to
machine->dead_threads, because references may still exist to them in things like
 hist, etc) some event later comes for this dead thread and then
machine__findnew_thread() will create a new thead instance that will not be the
same as the one referenced by work_atoms->thread in thread_atoms_search().

For now just revert this patch to get the 'perf sched lat' back working.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
echo Link: http://lkml.kernel.org/n/tip-`ranpwd -l 24`@git.kernel.org
Link: http://lkml.kernel.org/n/tip-hg4s6e5txiwqe00h8rdg1sin@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 1382294..2da2a6c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1671,7 +1671,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 			.sample		 = perf_sched__process_tracepoint_sample,
 			.comm		 = perf_event__process_comm,
 			.lost		 = perf_event__process_lost,
-			.exit		 = perf_event__process_exit,
 			.fork		 = perf_event__process_fork,
 			.ordered_samples = true,
 		},
