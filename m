Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaDAFDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 01:03:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:35237 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaDAFDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 01:03:05 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2014 01:03:04 EDT
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH] perf probe: Fix --line option behavior
Date: Tue,  1 Apr 2014 13:47:57 +0900
Message-Id: <1396327677-3657-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 5a62257a3ddd1 ("perf probe: Replace line_list with
intlist") replaced line_list to intlist but it has a problem that if a
same line was added again, it'd return -EEXIST rather than 1.

Since line_range_walk_cb() only checks the result being negative, it
resulted in failure or segfault sometimes.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/probe-finder.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index df0238654698..3bf0c8cdccb7 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1441,13 +1441,15 @@ static int line_range_walk_cb(const char *fname, int lineno,
 			      void *data)
 {
 	struct line_finder *lf = data;
+	int err;
 
 	if ((strtailcmp(fname, lf->fname) != 0) ||
 	    (lf->lno_s > lineno || lf->lno_e < lineno))
 		return 0;
 
-	if (line_range_add_line(fname, lineno, lf->lr) < 0)
-		return -EINVAL;
+	err = line_range_add_line(fname, lineno, lf->lr);
+	if (err < 0 && err != -EEXIST)
+		return err;
 
 	return 0;
 }
-- 
1.7.11.7

