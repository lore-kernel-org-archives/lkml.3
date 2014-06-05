Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaFEIPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:15:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44303 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaFEIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:15:43 -0400
Date: Thu, 5 Jun 2014 01:15:21 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-0c188a07b6a399e3df66534c29fef0a2082aaf57@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, acme@kernel.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Fix a segfault if asked for variable it doesn't find
Git-Commit-ID: 0c188a07b6a399e3df66534c29fef0a2082aaf57
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

Commit-ID:  0c188a07b6a399e3df66534c29fef0a2082aaf57
Gitweb:     http://git.kernel.org/tip/0c188a07b6a399e3df66534c29fef0a2082aaf57
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 29 May 2014 19:52:32 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 4 Jun 2014 14:48:03 +0200

perf probe: Fix a segfault if asked for variable it doesn't find

Fix a segfault bug by asking for variable it doesn't find.
Since the convert_variable() didn't handle error code returned
from convert_variable_location(), it just passed an incomplete
variable field and then a segfault was occurred when formatting
the field.

This fixes that bug by handling success code correctly in
convert_variable(). Other callers of convert_variable_location()
are correctly checking the return code.

This bug was introduced by following commit. But another hidden
erroneous error handling has been there previously (-ENOMEM case).

 commit 3d918a12a1b3088ac16ff37fa52760639d6e2403

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20140529105232.28251.30447.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/probe-finder.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5627621..9d8eb26 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -511,12 +511,12 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 
 	ret = convert_variable_location(vr_die, pf->addr, pf->fb_ops,
 					&pf->sp_die, pf->tvar);
-	if (ret == -ENOENT)
+	if (ret == -ENOENT || ret == -EINVAL)
 		pr_err("Failed to find the location of %s at this address.\n"
 		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
 	else if (ret == -ENOTSUP)
 		pr_err("Sorry, we don't support this variable location yet.\n");
-	else if (pf->pvar->field) {
+	else if (ret == 0 && pf->pvar->field) {
 		ret = convert_variable_fields(vr_die, pf->pvar->var,
 					      pf->pvar->field, &pf->tvar->ref,
 					      &die_mem);
