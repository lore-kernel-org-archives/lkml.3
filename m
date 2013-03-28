Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3C1RIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:08:18 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47752
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897Ab3C1RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 31/36] Revert "perf sched: Handle PERF_RECORD_EXIT events"
Date: Thu, 28 Mar 2013 14:02:31 -0300
Message-Id: <1364490156-32064-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 tools/perf/builtin-sched.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
-- 
1.7.1

