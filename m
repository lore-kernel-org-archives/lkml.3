Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbbAHPhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:37:38 -0500
Received: from mail.kernel.org ([198.145.29.136]:48882 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642AbbAHPhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:37:10 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf hists browser: Fix segfault when showing callchain
Date: Thu,  8 Jan 2015 12:36:48 -0300
Message-Id: <1420731408-8631-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420731408-8631-1-git-send-email-acme@kernel.org>
References: <1420731408-8631-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When perf report on TUI shows callchain it checks first node has
siblings to determine whether it needs to print percentage value.

But it missed a case that first node is NULL.  So sometimes it segfaults
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Fixes: 4087d11cd945 ("perf hists browser: Print overhead percent value for first-level callchain")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1419401076-21700-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

