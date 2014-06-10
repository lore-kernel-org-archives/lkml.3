Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaFJOqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:46:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:53747 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbaFJOqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:46:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/7] perf probe: Improve an error message of perf probe --vars mode
Date: Tue, 10 Jun 2014 11:46:02 -0300
Message-Id: <1402411564-3303-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402411564-3303-1-git-send-email-acme@infradead.org>
References: <1402411564-3303-1-git-send-email-acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140606071359.6788.84716.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  | 7 ++++++-
 tools/perf/util/probe-finder.c | 6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 0d1542f33d87..44c71417262f 100644
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
index ce8faf47691a..98e304766416 100644
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
-- 
1.9.3

