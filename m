Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798Ab3GSHop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:44:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575Ab3GSHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:44:41 -0400
Date: Fri, 19 Jul 2013 00:44:17 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-r79fn89bhqz16ixa5zmyflrd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Do not elide parent symbol column
Git-Commit-ID: ad3d6f508738323c0e843c4dbdd421c1aeb59cd8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:44:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad3d6f508738323c0e843c4dbdd421c1aeb59cd8
Gitweb:     http://git.kernel.org/tip/ad3d6f508738323c0e843c4dbdd421c1aeb59cd8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 17 Jun 2013 18:02:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:05 -0300

perf tools: Do not elide parent symbol column

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
