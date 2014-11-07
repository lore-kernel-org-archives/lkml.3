Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKGFUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:20:32 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33223 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaKGFUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:20:30 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/3] perf tools: Allow vmlinux to fallback to kallsyms on NO_LIBELF=1
Date: Fri,  7 Nov 2014 14:20:04 +0900
Message-Id: <1415337606-2186-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When libelf is not used, perf cannot not show symbol names since it
doesn't access the ELF symbol table.  But kernel is different as it
can fallback to kallsyms.

It worked w/o libelf, but recent change to use vmlinux for kernel
symbols break it.

With this change, it now can show kernel symbols again:

  # Overhead  Command  Shared Object      Symbol
  # ........  .......  .................  ........................
  #
      34.51%  swapper  [kernel.kallsyms]  [k] intel_idle
      12.54%  perf     [kernel.kallsyms]  [k] generic_exec_single
      10.11%  swapper  [kernel.kallsyms]  [k] int_sqrt
       9.83%  swapper  [kernel.kallsyms]  [k] hrtimer_interrupt
       7.25%  emacs    [kernel.kallsyms]  [k] __switch_to
       7.06%  sleep    [kernel.kallsyms]  [k] find_next_iomem_res
       7.02%  swapper  [kernel.kallsyms]  [k] run_timer_softirq
       2.55%  swapper  [kernel.kallsyms]  [k] _raw_spin_unlock_irq
       1.90%  swapper  [kernel.kallsyms]  [k] lapic_next_deadline
       1.75%  swapper  [kernel.kallsyms]  [k] native_sched_clock
       1.49%  swapper  [kernel.kallsyms]  [k] __schedule
       1.20%  swapper  [kernel.kallsyms]  [k] read_tsc
       1.10%  sleep    [kernel.kallsyms]  [k] current_kernel_time
       0.99%  swapper  [kernel.kallsyms]  [k] pick_next_task_rt
       0.36%  swapper  [kernel.kallsyms]  [k] group_sched_in
       0.24%  swapper  [kernel.kallsyms]  [k] x86_pmu_commit_txn
       0.06%  swapper  [kernel.kallsyms]  [k] intel_pmu_enable_all
       0.03%  perf     [kernel.kallsyms]  [k] intel_pmu_enable_all

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c9541fea9514..226cf41ed7e6 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -335,6 +335,9 @@ int dso__load_sym(struct dso *dso, struct map *map __maybe_unused,
 	unsigned char *build_id[BUILD_ID_SIZE];
 	int ret;
 
+	if (dso->kernel)
+		return 0;  /* always use kallsyms */
+
 	ret = fd__is_64_bit(ss->fd);
 	if (ret >= 0)
 		dso->is_64_bit = ret;
-- 
2.1.2

