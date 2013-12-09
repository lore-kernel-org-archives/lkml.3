Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416Ab3LITlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:41:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54977 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761302Ab3LIThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, bccheng@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/21] perf symbols: fix bug in usage of the basename() function
Date: Mon,  9 Dec 2013 16:37:10 -0300
Message-Id: <1386617830-18926-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
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
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: bccheng@google.com
Link: http://lkml.kernel.org/r/20131205182642.GA14614@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index a0c7c591f4b2..9fae484853c1 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -404,7 +404,34 @@ void dso__set_short_name(struct dso *dso, const char *name)
 
 static void dso__set_basename(struct dso *dso)
 {
-	dso__set_short_name(dso, basename(dso->long_name));
+	char *lname, *base;
+
+	/*
+	 * basename() may modify path buffer, so we must pass
+	 * a copy.
+	 */
+	lname = strdup(dso->long_name);
+	if (!lname)
+		return;
+
+	/*
+	 * basename() may return a pointer to internal
+	 * storage which is reused in subsequent calls
+	 * so copy the result.
+	 */
+	base = strdup(basename(lname));
+
+	free(lname);
+
+	if (!base)
+		return;
+
+	if (dso->sname_alloc)
+		free((char *)dso->short_name);
+	else
+		dso->sname_alloc = 1;
+
+	dso__set_short_name(dso, base);
 }
 
 int dso__name_len(const struct dso *dso)
-- 
1.8.1.4

