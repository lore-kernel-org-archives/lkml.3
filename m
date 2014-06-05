Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaFEIoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:44:32 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37173 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFEIoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:44:30 -0400
Date: Thu, 5 Jun 2014 10:44:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes for v3.15
Message-ID: <20140605084424.GA14595@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: 22c91aa23547a4363fd2a9ffddde95c899ac8aa0 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/urgent

Two last minute tooling fixes.

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (2):
      perf probe: Fix a segfault if asked for variable it doesn't find
      perf probe: Fix perf probe to find correct variable DIE


 tools/perf/util/dwarf-aux.c    | 7 +++++--
 tools/perf/util/probe-finder.c | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 7defd77..cc66c40 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -747,14 +747,17 @@ struct __find_variable_param {
 static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 {
 	struct __find_variable_param *fvp = data;
+	Dwarf_Attribute attr;
 	int tag;
 
 	tag = dwarf_tag(die_mem);
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
-	    die_compare_name(die_mem, fvp->name))
+	    die_compare_name(die_mem, fvp->name) &&
+	/* Does the DIE have location information or external instance? */
+	    (dwarf_attr(die_mem, DW_AT_external, &attr) ||
+	     dwarf_attr(die_mem, DW_AT_location, &attr)))
 		return DIE_FIND_CB_END;
-
 	if (dwarf_haspc(die_mem, fvp->addr))
 		return DIE_FIND_CB_CONTINUE;
 	else
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
