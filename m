Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256Ab3GRUC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:02:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41616 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446Ab3GRTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/76] perf tests: Omit end of the symbol check failure for test 1
Date: Thu, 18 Jul 2013 16:48:51 -0300
Message-Id: <1374177003-3706-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Omitting end of the function check failure for test 1, since there's no
way to get exact symbol end via kallsyms.

Leaving the debug message.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1370612223-19188-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index 7b4c4d2..add1539 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -139,11 +139,18 @@ next_pair:
 				 * _really_ have a problem.
 				 */
 				s64 skew = sym->end - pair->end;
-				if (llabs(skew) < page_size)
-					continue;
+				if (llabs(skew) >= page_size)
+					pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
+						 sym->start, sym->name, sym->end, pair->end);
+
+				/*
+				 * Do not count this as a failure, because we
+				 * could really find a case where it's not
+				 * possible to get proper function end from
+				 * kallsyms.
+				 */
+				continue;
 
-				pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
-					 sym->start, sym->name, sym->end, pair->end);
 			} else {
 				struct rb_node *nnd;
 detour:
-- 
1.8.1.4

