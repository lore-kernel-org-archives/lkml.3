Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbaFANcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaFANcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:32:25 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 23/27] perf ui/stdio: Fix invalid percentage value of cumulated hist entries
Date: Sun,  1 Jun 2014 15:31:34 +0200
Message-Id: <1401629498-8726-24-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
References: <1401629498-8726-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1401335910-16832-24-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/stdio/hist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 475d2f5..90122ab 100644
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
1.8.3.1

