Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFWDRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 23:17:23 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55145 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaFWDRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 23:17:22 -0400
Subject: [PATCH -tip ] [BUGFIX]: Fix to add a missing pair of braces for
 error path.
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Patrick Palka <patrick@parcs.ath.cx>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 23 Jun 2014 03:17:12 +0000
Message-ID: <20140623031712.6541.39111.stgit@kbuild-fedora.novalocal>
In-Reply-To: <53A78F14.8070705@hitachi.com>
References: <53A78F14.8070705@hitachi.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to add a missing pair of braces for error path.
Commit 36d789a4d75f (perf probe: Improve error message for
unknown member of data structure) introduced this bug.

Without this fix, defining an event with global variables
is always failed, because it always returns -ENOENT if
the argument is not a local variable.

  ----
  # perf probe -na "vfs_read smp_found_config"
    Error: Failed to add events.
  ----

With this fix, you can set a global variable for the
argument of new event.

  ----
  # perf probe -na "vfs_read smp_found_config"
  Added new event:
    probe:vfs_read       (on vfs_read with smp_found_config)

  You can now use it in all perf tools, such as:

          perf record -e probe:vfs_read -aR sleep 1
  ----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Reported-by: Patrick Palka <patrick@parcs.ath.cx>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-finder.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 98e3047..10560fc 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -572,10 +572,12 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 	/* Search child die for local variables and parameters. */
 	if (!die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die)) {
 		/* Search again in global variables */
-		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0, &vr_die))
+		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0,
+					  &vr_die)) {
 			pr_warning("Failed to find '%s' in this function.\n",
 				   pf->pvar->var);
 			ret = -ENOENT;
+		}
 	}
 	if (ret >= 0)
 		ret = convert_variable(&vr_die, pf);


