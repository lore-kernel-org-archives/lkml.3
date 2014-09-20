Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaITQSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:18:43 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39595 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaITQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:18:33 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Milian Wolff <mail@milianw.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] perf hists browser: Fix callchain print bug on TUI
Date: Sun, 21 Sep 2014 01:18:02 +0900
Message-Id: <1411229886-24390-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf report -g graph option doesn't work as expected and
always work as same as -g fractal.  This was a bug during recent
callchain print code cleanup.

Before:
  $ perf report -g graph

    Children      Self  Command  Shared Object      Symbol
  ================================================================
  -   56.19%    35.41%  sleep    [kernel.kallsyms]  [k] page_fault
     - page_fault
        + 63.02% _dl_relocate_object
        + 36.98% clear_user

After:
    Children      Self  Command  Shared Object      Symbol
  ================================================================
  -   56.19%    35.41%  sleep    [kernel.kallsyms]  [k] page_fault
     - page_fault
        + 35.41% _dl_relocate_object
        + 20.78% clear_user

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d4cef68176da..8f60a970404f 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -804,9 +804,6 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.is_current_entry = current_entry,
 		};
 
-		if (symbol_conf.cumulate_callchain)
-			total = entry->stat_acc->period;
-
 		printed += hist_browser__show_callchain(browser,
 					&entry->sorted_chain, 1, row, total,
 					hist_browser__show_callchain_entry, &arg,
-- 
2.1.0

