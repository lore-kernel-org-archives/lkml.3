Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaE2D7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:59:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53561 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbaE2D6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 23/27] perf ui/stdio: Fix invalid percentage value of cumulated hist entries
Date: Thu, 29 May 2014 12:58:26 +0900
Message-Id: <1401335910-16832-24-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On stdio, there's a problem that it shows invalid values for
callchains in cumulated hist entries.  It's because it only cares
about the self period.  But with --children behavior, we always add
callchain info to the cumulated entries so it should use the value in
that case.

Before:

  # Children      Self  Command      Shared Object            Symbol
  # ........  ........  .......  .................  ................
  #
      61.22%     0.32%  swapper  [kernel.kallsyms]      [k] cpu_idle
                    |
                    --- cpu_idle
                       |
                       |--16530.76%-- start_secondary
                       |
                       |--2758.70%-- rest_init
                       |          start_kernel
                       |          x86_64_start_reservations
                       |          x86_64_start_kernel
                        --6837850969203030.00%-- [...]

After:

  # Children      Self  Command      Shared Object            Symbol
  # ........  ........  .......  .................  ................
  #
      61.22%     0.32%  swapper  [kernel.kallsyms]      [k] cpu_idle
                    |
                    --- cpu_idle
                       |
                       |--85.70%-- start_secondary
                       |
                        --14.30%-- rest_init
                                  start_kernel
                                  x86_64_start_reservations
                                  x86_64_start_kernel

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/stdio/hist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 475d2f5c7e16..90122abd3721 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -271,7 +271,9 @@ static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
 {
 	switch (callchain_param.mode) {
 	case CHAIN_GRAPH_REL:
-		return callchain__fprintf_graph(fp, &he->sorted_chain, he->stat.period,
+		return callchain__fprintf_graph(fp, &he->sorted_chain,
+						symbol_conf.cumulate_callchain ?
+						he->stat_acc->period : he->stat.period,
 						left_margin);
 		break;
 	case CHAIN_GRAPH_ABS:
-- 
1.9.2

