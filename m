Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaIWBCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 21:02:05 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59155 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbaIWBCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 21:02:02 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Milian Wolff <mail@milianw.de>
Subject: [PATCH 1/5] perf hists browser: Fix callchain print bug on TUI
Date: Tue, 23 Sep 2014 10:01:40 +0900
Message-Id: <1411434104-5307-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
References: <1411434104-5307-1-git-send-email-namhyung@kernel.org>
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

Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
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

