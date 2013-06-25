Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3FYLyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:54:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794Ab3FYLys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:54:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/5] perf tools: Do not elide parent symbol column
Date: Tue, 25 Jun 2013 13:54:11 +0200
Message-Id: <1372161253-22081-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
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
1.7.11.7

