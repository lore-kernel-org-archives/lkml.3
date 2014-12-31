Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLaG1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 01:27:52 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57863 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaLaG1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 01:27:51 -0500
X-AuditID: 85900ec0-bdef2b9000002d32-11-54a3973d264f
Subject: [PATCH] [BUGFIX] perf-probe: Fix to fall back to find probe point
 in symbols
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>
Cc: namhyung@kernel.org, yrl.pp-manager.tt@hitachi.com,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 31 Dec 2014 15:27:47 +0900
Message-ID: <20141231062747.2087.80961.stgit@localhost.localdomain>
In-Reply-To: <54A2285F.3040200@gmail.com>
References: <54A2285F.3040200@gmail.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to fall back to find a probe point in symbols if perf fails
to find it in debuginfo.

This can happen when the target function is an alias of another
function. Such alias doesn't have an entry in debuginfo but in
symbols.

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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/probe-event.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 28eb141..7f9b863 100644
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

