Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaFDN1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:27:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbaFDN1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:27:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 1/2] perf probe: Fix a segfault if asked for variable it doesn't find
Date: Wed,  4 Jun 2014 15:26:59 +0200
Message-Id: <1401888420-23191-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401888420-23191-1-git-send-email-jolsa@kernel.org>
References: <1401888420-23191-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.8.3.1

