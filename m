Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaI0H0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:26:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41225 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaI0H0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:26:16 -0400
Date: Sat, 27 Sep 2014 00:25:37 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-72f72ed21e56c386dd92118e5da3ce06752b1614@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mail@milianw.de, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        mail@milianw.de, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1411434104-5307-2-git-send-email-namhyung@kernel.org>
References: <1411434104-5307-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Fix callchain print bug on TUI
Git-Commit-ID: 72f72ed21e56c386dd92118e5da3ce06752b1614
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

Commit-ID:  72f72ed21e56c386dd92118e5da3ce06752b1614
Gitweb:     http://git.kernel.org/tip/72f72ed21e56c386dd92118e5da3ce06752b1614
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 23 Sep 2014 10:01:40 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Sep 2014 12:38:02 -0300

perf hists browser: Fix callchain print bug on TUI

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
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1411434104-5307-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d4cef68..8f60a97 100644
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
