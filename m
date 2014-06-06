Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaFFHOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:14:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60783 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaFFHOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:14:08 -0400
Subject: [PATCH -tip 3/4] perf/probe: Improve an error message of perf probe
 --vars mode
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Date: Fri, 06 Jun 2014 07:13:59 +0000
Message-ID: <20140606071359.6788.84716.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
References: <20140606071338.6788.799.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an error message when failed to find given address in --vars
mode.

Without this fix, perf probe -V doesn't show the final "Error"
message if it fails to find given source line. Moreover, it
tells it fails to find "variables" instead of the source line.
  -----
  # perf probe -V foo@bar
  Failed to find variables at foo@bar (0)
  -----
The result also shows mysterious error code. Actually the error
returns 0 or -ENOENT means that it just fails to find the address
of given source line. (0 means there is no matching address,
and -ENOENT means there is an entry(DIE) but it has no instance,
e.g. an empty inlined function)

This fixes it to show what happened and the final error message
as below.
  -----
  # perf probe -V foo@bar
  Failed to find the address of foo@bar
    Error: Failed to show vars.
  -----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/probe-event.c  |    7 ++++++-
 tools/perf/util/probe-finder.c |    6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0d1542f..44c7141 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -721,9 +721,14 @@ static int show_available_vars_at(struct debuginfo *dinfo,
 	ret = debuginfo__find_available_vars_at(dinfo, pev, &vls,
 						max_vls, externs);
 	if (ret <= 0) {
-		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
+		if (ret == 0 || ret == -ENOENT) {
+			pr_err("Failed to find the address of %s\n", buf);
+			ret = -ENOENT;
+		} else
+			pr_warning("Debuginfo analysis failed.\n");
 		goto end;
 	}
+
 	/* Some variables are found */
 	fprintf(stdout, "Available variables at %s\n", buf);
 	for (i = 0; i < ret; i++) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ce8faf4..98e3047 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1280,7 +1280,11 @@ out:
 	return ret;
 }
 
-/* Find available variables at given probe point */
+/*
+ * Find available variables at given probe point
+ * Return the number of found probe points. Return 0 if there is no
+ * matched probe point. Return <0 if an error occurs.
+ */
 int debuginfo__find_available_vars_at(struct debuginfo *dbg,
 				      struct perf_probe_event *pev,
 				      struct variable_list **vls,


