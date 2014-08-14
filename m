Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbaHNGCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:02:10 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60568 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaHNGBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:01:43 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 3/3] perf callchain: Prune misleading callchains for self entries
Date: Thu, 14 Aug 2014 15:01:40 +0900
Message-Id: <1407996100-6359-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
References: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "perf report -g" displays callchains callee-first order.  That
means it can see the callers of the sample in a reverse order.  For
example, "intel_idle" entry shows following callchain on my data.

  Children      Self  Command          Shared Object       Symbol
  --------  --------  ---------------  ------------------  ----------------
    40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
              |
               --- intel_idle
                   cpuidle_enter
                   cpuidle_wrap_enter
                   cpuidle_enter_tk
                   cpuidle_idle_call
                   cpu_idle
                  |
                  |--85.25%-- start_secondary
                  |
                   --14.75%-- rest_init
                             start_kernel
                             x86_64_start_reservations
                             x86_64_start_kernel

So "intel_idle" was called by "cpuidle_enter", and in turn, it's
called by "cpuidle_wrap_enter" and so on.

When with -g "caller", it shows callchains in a reversed order -
"caller-first".  I know it's sometimes useful but never used it.

    40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
                    |
                    |--85.25%-- start_secondary
                    |          cpu_idle
                    |          cpuidle_idle_call
                    |          cpuidle_enter_tk
                    |          cpuidle_wrap_enter
                    |          cpuidle_enter
                    |          intel_idle
                    |
                     --14.75%-- x86_64_start_kernel
                               x86_64_start_reservations
                               start_kernel
                               rest_init
                               cpu_idle
                               cpuidle_idle_call
                               cpuidle_enter_tk
                               cpuidle_wrap_enter
                               cpuidle_enter
                               intel_idle

However, with --children feature added, it now can show all callees of
the entry.  For example, "start_kernel" entry now can display it calls
rest_init and in turn cpu_idle and then cpuidle_idle_call (95.72%).

     6.14%     0.00%  swapper          [kernel.kallsyms]   [k] start_kernel
                   |
                    --- start_kernel
                        rest_init
                        cpu_idle
                       |
                       |--97.52%-- cpuidle_idle_call
                       |          cpuidle_enter_tk
                       |          |
                       |          |--99.91%-- cpuidle_wrap_enter
                       |          |          cpuidle_enter
                       |          |          intel_idle
                       |           --0.09%-- [...]
                        --2.48%-- [...]

Note that start_kernel has no self overhead - meaning that it never
get sampled by itself but constructs such a nice callgraph.  But,
sadly, if an entry has self overhead, callchain will get confused with
generated callchain (like above) and self callchains (which reversed
order) like the eariler example.

To be consistent with other entries, I'd like to make it just to show
a single entry - itself - like below since it doesn't have callees
(children) at all.  But still use the whole callchain to construct
children entries (like the start_kernel) as usual.

    40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
                    |
                    --- intel_idle

Note that this is just for --children is enabled.  Without that, it
will do the original behavior.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 30df6187ee02..67f249daf34e 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -716,7 +716,28 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &callchain_cursor, sample->period);
+	if (callchain_param.order == ORDER_CALLER) {
+		struct callchain_cursor cursor;
+		int nr = callchain_cursor.nr;
+
+		/*
+		 * When --children with -g caller, it just adds noise to
+		 * self entries.  Just adding last node (self) is enough
+		 * and it'd privide a consistent view with other (cumulative)
+		 * entries.
+		 */
+		while (--nr) {
+			callchain_cursor_advance(&callchain_cursor);
+		}
+
+		BUG_ON(callchain_cursor.nr != callchain_cursor.pos + 1);
+
+		callchain_cursor_snapshot(&cursor, &callchain_cursor);
+
+		callchain_append(he->callchain, &cursor, sample->period);
+	} else {
+		callchain_append(he->callchain, &callchain_cursor, sample->period);
+	}
 
 	/*
 	 * We need to re-initialize the cursor since callchain_append()
-- 
2.0.0

