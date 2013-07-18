Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965252Ab3GRUDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:03:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab3GRTuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:25 -0400
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
Subject: [PATCH 11/76] perf tools: Do not elide parent symbol column
Date: Thu, 18 Jul 2013 16:48:58 -0300
Message-Id: <1374177003-3706-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

I found the parent symbol column data interesting even
if there's another sorting enabled. Switching it on.

Previous behaviour:
  $ perf report -i perf.data.delete -p perf_session__delete -x

  +   3.60%  perf  perf               [.] __rb_change_child
  +   1.89%  perf  perf               [.] rb_erase
  +   1.89%  perf  perf               [.] rb_erase
  +   1.83%  perf  perf               [.] free@plt

Current behaviour:
  $ perf report -i perf.data.delete -p perf_session__delete -x

  +   3.60%  perf  perf               [.] __rb_change_child        perf_session__delete
  +   1.89%  perf  perf               [.] rb_erase                 perf_session__delete_dead_threads
  +   1.89%  perf  perf               [.] rb_erase                 perf_session__delete_threads
  +   1.83%  perf  perf               [.] free@plt                 perf_session__delete

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-r79fn89bhqz16ixa5zmyflrd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3662047..6ab49da 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -931,14 +931,6 @@ repeat:
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
 			goto error;
-
-		/*
-		 * Only show the parent fields if we explicitly
-		 * sort that way. If we only use parent machinery
-		 * for filtering, we don't want it.
-		 */
-		if (!strstr(sort_order, "parent"))
-			sort_parent.elide = 1;
 	}
 
 	if (argc) {
-- 
1.8.1.4

