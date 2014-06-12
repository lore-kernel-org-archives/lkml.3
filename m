Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906AbaFLMEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:04:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60667 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964870AbaFLMEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:04:47 -0400
Date: Thu, 12 Jun 2014 05:04:32 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-69e96eaa4fef04ad543eda3eab787dbae99d8912@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140606071359.6788.84716.stgit@kbuild-fedora.novalocal>
References: <20140606071359.6788.84716.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe:
  Improve an error message of perf probe --vars mode
Git-Commit-ID: 69e96eaa4fef04ad543eda3eab787dbae99d8912
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

Commit-ID:  69e96eaa4fef04ad543eda3eab787dbae99d8912
Gitweb:     http://git.kernel.org/tip/69e96eaa4fef04ad543eda3eab787dbae99d8912
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 6 Jun 2014 07:13:59 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Jun 2014 14:35:58 -0300

perf probe: Improve an error message of perf probe --vars mode

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
