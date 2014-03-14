Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaCNRYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:24:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48295 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbaCNRYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:24:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Patrick Palka <patrick@parcs.ath.cx>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf bench numa: Make no args mean 'run all tests'
Date: Fri, 14 Mar 2014 14:23:58 -0300
Message-Id: <1394817839-26310-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394817839-26310-1-git-send-email-acme@infradead.org>
References: <1394817839-26310-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If we call just:

  perf bench numa mem

it will present the same output as:

  perf bench numa mem -h

i.e. ask for instructions about what to run.

While that is kinda ok, using 'run all tests' as the default, i.e.
making 'no parms' be equivalent to:

  perf bench numa mem -a

Will allow:

  perf bench numa all

to actually do what is asked: i.e. run all the 'bench' tests, instead of
responding to that by asking what to do.

That, in turn, allows:

  perf bench all

to actually complete, for the same reasons.

And after that, the tests that come after that, and that at some point
hit a NULL deref, will run, allowing me to reproduce a recently reported
problem.

That when you have the needed numa libraries, which wasn't the case for
the reporter, making me a bit confused after trying to reproduce his
report.

So make no parms mean -a.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Patrick Palka <patrick@parcs.ath.cx>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-x7h0ghx4pef4n0brywg21krk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/numa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index d4c83c60b9b2..97d86d828190 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1593,6 +1593,7 @@ static void init_params(struct params *p, const char *name, int argc, const char
 	p->data_rand_walk		= true;
 	p->nr_loops			= -1;
 	p->init_random			= true;
+	p->run_all			= argc == 1;
 }
 
 static int run_bench_numa(const char *name, const char **argv)
-- 
1.8.1.4

