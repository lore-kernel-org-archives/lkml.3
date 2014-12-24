Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaLXGDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:03:55 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62799 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXGDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:03:53 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf hists browser: Fix segfault when showing callchain
Date: Wed, 24 Dec 2014 15:04:36 +0900
Message-Id: <1419401076-21700-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When perf report on TUI shows callchain it checks first node has
siblings to determine whether it needs to print percentage value.  But
it missed a case that first node is NULL.  So sometimes it segfaults
like below:

  $ perf top -g
  perf: Segmentation fault
  -------- backtrace --------
  perf[0x4fcefb]
  /usr/lib/libc.so.6(+0x33b20)[0x7f2a35839b20]
  perf(rb_next+0x8)[0x47d3d8]
  perf[0x4f6058]
  perf[0x4f833b]
  perf[0x4f8610]
  perf[0x4f209e]
  perf(ui_browser__run+0x3a)[0x4f2e6a]
  perf[0x4f94ee]
  perf(perf_evlist__tui_browse_hists+0x94)[0x4fbbf4]
  perf[0x444d10]
  /usr/lib/libpthread.so.0(+0x7314)[0x7f2a37070314]
  /usr/lib/libc.so.6(clone+0x6d)[0x7f2a358ee5bd]

  $ addr2line -e `which perf` 0x4f6058
  /home/namhyung/project/linux/tools/perf/ui/browsers/hists.c:553

I don't know why the backtrace didn't print some symbols..

Fixes: 4087d11cd945 ("perf hists browser: Print overhead percent value for first-level callchain")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index e6bb04b5b09b..788506eef567 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -550,7 +550,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	bool need_percent;
 
 	node = rb_first(root);
-	need_percent = !!rb_next(node);
+	need_percent = node && rb_next(node);
 
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
-- 
2.1.3

