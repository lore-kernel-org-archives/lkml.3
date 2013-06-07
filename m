Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab3FGNhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:37:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3FGNha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:37:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/3] perf tests: Omit end of the symbol check failure for test 1
Date: Fri,  7 Jun 2013 15:37:02 +0200
Message-Id: <1370612223-19188-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1370612223-19188-1-git-send-email-jolsa@redhat.com>
References: <1370612223-19188-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Omitting end of the function check failure for test 1,
since there's no way to get exact symbol end via kallsyms.

Leaving the debug message.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

