Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbaFLMEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:04:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60642 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105AbaFLME2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:04:28 -0400
Date: Thu, 12 Jun 2014 05:04:08 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-36d789a4d75f3826faa6e75b018942b63ffed1a0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
In-Reply-To: <20140606071345.6788.23744.stgit@kbuild-fedora.novalocal>
References: <20140606071345.6788.23744.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Improve error message for unknown member of data structure
Git-Commit-ID: 36d789a4d75f3826faa6e75b018942b63ffed1a0
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

Commit-ID:  36d789a4d75f3826faa6e75b018942b63ffed1a0
Gitweb:     http://git.kernel.org/tip/36d789a4d75f3826faa6e75b018942b63ffed1a0
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 6 Jun 2014 07:13:45 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Jun 2014 12:15:07 -0300

perf probe: Improve error message for unknown member of data structure

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
 
