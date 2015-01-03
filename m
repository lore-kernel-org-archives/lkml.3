Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbbACC4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 21:56:04 -0500
Received: from mail.kernel.org ([198.145.29.136]:42887 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbbACCzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 21:55:51 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf probe: Fix to fall back to find probe point in symbols
Date: Fri,  2 Jan 2015 23:55:34 -0300
Message-Id: <1420253737-2488-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420253737-2488-1-git-send-email-acme@kernel.org>
References: <1420253737-2488-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix to fall back to find a probe point in symbols if perf fails to find
it in debuginfo.

This can happen when the target function is an alias of another
function. Such alias doesn't have an entry in debuginfo but in symbols.

David Ahern reported this problem in https://lkml.org/lkml/2014/12/29/355

I ensured the problem and deeper investigation discovers it.
 -----
 eu-readelf --debug-dump=info /usr/lib/debug/lib/x86_64-linux-gnu/libc-2.19.so | grep \"malloc\" -A6
             name                 (strp) "malloc"
             decl_file            (data1) 25
             decl_line            (data2) 466
             prototyped           (flag_present)
             type                 (ref4) [  81b5]
             declaration          (flag_present)
 [  8f58]      formal_parameter
 --
             name                 (strp) "malloc"
             decl_file            (data1) 23
             decl_line            (data2) 466
             prototyped           (flag_present)
             type                 (ref4) [  9f4a]
             declaration          (flag_present)
             sibling              (ref4) [  bb29]
 ...
 -----
All these entires have no instances (all of them are declarations)
This is why the perf probe failed to find it in debuginfo.

However, there are some malloc instances in symbols.
 -----
 eu-readelf --symbols /usr/lib/debug/lib/x86_64-linux-gnu/libc-2.19.so | grep malloc$
  1181: 0000000000080700   5332 FUNC    LOCAL  DEFAULT       12 _int_malloc
  4537: 00000000000831d0    339 FUNC    LOCAL  DEFAULT       12 __GI___libc_malloc
  5545: 00000000000831d0    339 FUNC    LOCAL  DEFAULT       12 __malloc
  6063: 00000000000831d0    339 FUNC    GLOBAL DEFAULT       12 malloc
  7302: 00000000000831d0    339 FUNC    GLOBAL DEFAULT       12 __libc_malloc
 -----
As you an see, malloc and __libc_malloc have same address, and actually
__libc_malloc has an entry in debuginfo. So you can set up a probe on
__libc_malloc.

To fix this problem shortly, perf probe simply falls back to find probe
point(malloc) in symbols if it is not found in debuginfo.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20141231062747.2087.80961.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 28eb1417cb2a..7f9b8632e433 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -495,9 +495,11 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	if (ntevs == 0)	{	/* No error but failed to find probe point. */
-		pr_warning("Probe point '%s' not found.\n",
+		pr_warning("Probe point '%s' not found in debuginfo.\n",
 			   synthesize_perf_probe_point(&pev->point));
-		return -ENOENT;
+		if (need_dwarf)
+			return -ENOENT;
+		return 0;
 	}
 	/* Error path : ntevs < 0 */
 	pr_debug("An error occurred in debuginfo analysis (%d).\n", ntevs);
-- 
1.9.3

