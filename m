Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab3LES0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:26:40 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:49416 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328Ab3LES0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:26:38 -0500
Date: Thu, 5 Dec 2013 19:26:42 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com, dsahern@gmail.com,
        bccheng@google.com
Subject: [PATCH v2] perf tools: fix bug in usage of the basename() function
Message-ID: <20131205182642.GA14614@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

---
 tools/perf/util/dso.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index af4c687c..976fac0 100644
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
1.7.9.5

