Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965151AbaFCSgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:36:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857AbaFCSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:36:11 -0400
Date: Tue, 3 Jun 2014 11:35:56 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-56772ad4750e23460a4b80f7ece5377d8c922ee1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1401335910-16832-24-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-24-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/stdio:
  Fix invalid percentage value of cumulated hist entries
Git-Commit-ID: 56772ad4750e23460a4b80f7ece5377d8c922ee1
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

Commit-ID:  56772ad4750e23460a4b80f7ece5377d8c922ee1
Gitweb:     http://git.kernel.org/tip/56772ad4750e23460a4b80f7ece5377d8c922ee1
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 23 May 2014 18:31:52 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Sun, 1 Jun 2014 14:35:09 +0200

perf ui/stdio: Fix invalid percentage value of cumulated hist entries

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
