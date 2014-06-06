Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaFFHN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:13:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58874 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaFFHNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:13:54 -0400
Subject: [PATCH -tip 1/4] perf/probe: Improve error message for unknown
 member of data structure
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Date: Fri, 06 Jun 2014 07:13:45 +0000
Message-ID: <20140606071345.6788.23744.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
References: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the error message if we can not find given member in
the given structure. Currently perf probe shows a wrong error
message as below.

  -----
  # perf probe getname_flags:65 "result->BOGUS"
  result(type:filename) has no member BOGUS.
  Failed to find 'result' in this function.
    Error: Failed to add events. (-22)
  -----

The first message is correct, but the second one is not, since
we didn't fail to find a variable but fails to find the member
of given variable.

  -----
  # perf probe getname_flags:65 "result->BOGUS"
  result(type:filename) has no member BOGUS.
    Error: Failed to add events. (-22)
  -----

With this patch, the error message shows only the first one.
And if we really failed to find given variable, it tells us so.

  -----
  # perf probe getname_flags:65 "BOGUS"
  Failed to find 'BOGUS' in this function.
    Error: Failed to add events. (-2)
  -----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/probe-finder.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9d8eb26..ce8faf4 100644
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
 


