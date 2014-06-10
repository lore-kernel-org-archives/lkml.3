Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaFJOqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:46:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:53704 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaFJOq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/7] perf probe: Improve error message for unknown member of data structure
Date: Tue, 10 Jun 2014 11:46:00 -0300
Message-Id: <1402411564-3303-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402411564-3303-1-git-send-email-acme@infradead.org>
References: <1402411564-3303-1-git-send-email-acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Improve the error message if we can not find given member in the given
structure. Currently perf probe shows a wrong error message as below.

  -----
  # perf probe getname_flags:65 "result->BOGUS"
  result(type:filename) has no member BOGUS.
  Failed to find 'result' in this function.
    Error: Failed to add events. (-22)
  -----

The first message is correct, but the second one is not, since we didn't
fail to find a variable but fails to find the member of given variable.

  -----
  # perf probe getname_flags:65 "result->BOGUS"
  result(type:filename) has no member BOGUS.
    Error: Failed to add events. (-22)
  -----

With this patch, the error message shows only the first one.  And if we
really failed to find given variable, it tells us so.

  -----
  # perf probe getname_flags:65 "BOGUS"
  Failed to find 'BOGUS' in this function.
    Error: Failed to add events. (-2)
  -----

Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140606071345.6788.23744.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9d8eb26f0533..ce8faf47691a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -573,14 +573,13 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 	if (!die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die)) {
 		/* Search again in global variables */
 		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0, &vr_die))
+			pr_warning("Failed to find '%s' in this function.\n",
+				   pf->pvar->var);
 			ret = -ENOENT;
 	}
 	if (ret >= 0)
 		ret = convert_variable(&vr_die, pf);
 
-	if (ret < 0)
-		pr_warning("Failed to find '%s' in this function.\n",
-			   pf->pvar->var);
 	return ret;
 }
 
-- 
1.9.3

