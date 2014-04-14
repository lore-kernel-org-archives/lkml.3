Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaDNOx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:53:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaDNOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:53:20 -0400
Date: Mon, 14 Apr 2014 07:53:00 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-202c7c123c96a1c193149b7fa2718d7fb143efb2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1396327677-3657-1-git-send-email-namhyung@kernel.org>
References: <1396327677-3657-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix --line option behavior
Git-Commit-ID: 202c7c123c96a1c193149b7fa2718d7fb143efb2
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

Commit-ID:  202c7c123c96a1c193149b7fa2718d7fb143efb2
Gitweb:     http://git.kernel.org/tip/202c7c123c96a1c193149b7fa2718d7fb143efb2
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 1 Apr 2014 13:47:57 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Mon, 14 Apr 2014 12:55:39 +0200

perf probe: Fix --line option behavior

The commit 5a62257a3ddd1 ("perf probe: Replace line_list with
intlist") replaced line_list to intlist but it has a problem that if a
same line was added again, it'd return -EEXIST rather than 1.

Since line_range_walk_cb() only checks the result being negative, it
resulted in failure or segfault sometimes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/1396327677-3657-1-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/probe-finder.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index df02386..3bf0c8c 100644
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
