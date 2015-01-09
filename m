Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687AbbAIMcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:32:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60155 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbbAIMcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:32:08 -0500
Date: Fri, 9 Jan 2015 04:31:27 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c09e31cc128cf1aec3a6cd47203508fbf0082873@git.kernel.org>
Cc: eranian@google.com, namhyung@kernel.org, mingo@kernel.org,
        fweisbec@gmail.com, andi@firstfloor.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        jolsa@redhat.com, tglx@linutronix.de, a.p.zijlstra@chello.nl
Reply-To: hpa@zytor.com, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, acme@redhat.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, andi@firstfloor.org, namhyung@kernel.org,
        eranian@google.com, fweisbec@gmail.com, mingo@kernel.org
In-Reply-To: <1419401076-21700-1-git-send-email-namhyung@kernel.org>
References: <1419401076-21700-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists browser:
  Fix segfault when showing callchain
Git-Commit-ID: c09e31cc128cf1aec3a6cd47203508fbf0082873
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

Commit-ID:  c09e31cc128cf1aec3a6cd47203508fbf0082873
Gitweb:     http://git.kernel.org/tip/c09e31cc128cf1aec3a6cd47203508fbf0082873
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 24 Dec 2014 15:04:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 8 Jan 2015 11:59:16 -0300

perf hists browser: Fix segfault when showing callchain

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
index e6bb04b..788506e 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -550,7 +550,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	bool need_percent;
 
 	node = rb_first(root);
-	need_percent = !!rb_next(node);
+	need_percent = node && rb_next(node);
 
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
