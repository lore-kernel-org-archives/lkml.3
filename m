Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3LJUbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:31:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34275 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3LJUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:31:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ben Cheng <bccheng@google.com>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/34 v3] perf symbols: Fix bug in usage of the basename() function
Date: Tue, 10 Dec 2013 17:31:14 -0300
Message-Id: <1386707476-12370-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386707476-12370-1-git-send-email-acme@infradead.org>
References: <1386707476-12370-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The basename() implementation varies a lot between systems.

The Linux man page says: "basename may modify the content of the path,
so it may be desirable to pass a copy when calling the function".

On some other systems, the returned address may come from an internal
buffer which can be reused in subsequent calls, thus the results should
also be copied.

The dso__set_basename() function was not doing this causing problems
on some systems with wrong library names being shown by perf report,
such as on Android systems.

This patch fixes the problem.
The patch is relative to tip.git.

In v2, we clean up the comments based on Ingo's feedback.

Reported-by: Ben Cheng <bccheng@google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ben Cheng <bccheng@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131205182642.GA14614@quad
[ v3: Fixed up wrt allocated flag now being set in dso__set_short_name ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 582b5d344aa3..436922f1f9d9 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -413,7 +413,28 @@ void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
 
 static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(dso, basename((char *)dso->long_name), false);
+       /*
+        * basename() may modify path buffer, so we must pass
+        * a copy.
+        */
+       char *base, *lname = strdup(dso->long_name);
+
+       if (!lname)
+               return;
+
+       /*
+        * basename() may return a pointer to internal
+        * storage which is reused in subsequent calls
+        * so copy the result.
+        */
+       base = strdup(basename(lname));
+
+       free(lname);
+
+       if (!base)
+               return;
+
+       dso__set_short_name(dso, base, true);
 }
 
 int dso__name_len(const struct dso *dso)
-- 
1.8.1.4

