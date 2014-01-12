Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaALSbk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:31:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:31:36 -0500
Date: Sun, 12 Jan 2014 10:31:08 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-68f6d0224b2a19a4da4a12a5081f01776e5150df@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, rodrigo@sdfg.com.ar, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        asharma@fb.com
In-Reply-To: <1387344086-12744-3-git-send-email-namhyung@kernel.org>
References: <1387344086-12744-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Do not compare dso again
Git-Commit-ID: 68f6d0224b2a19a4da4a12a5081f01776e5150df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:31:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68f6d0224b2a19a4da4a12a5081f01776e5150df
Gitweb:     http://git.kernel.org/tip/68f6d0224b2a19a4da4a12a5081f01776e5150df
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 18 Dec 2013 14:21:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 18 Dec 2013 14:43:04 -0300

perf sort: Do not compare dso again

The commit 09600e0f9ebb ("perf tools: Compare dso's also when comparing
symbols") added a comparison of dso when comparing symbol.

But if the sort key already has dso, it doesn't need to do it again
since entries have a different dso already filtered out.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1387344086-12744-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 68a4fd2..635cd8f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -13,6 +13,7 @@ int		have_ignore_callees = 0;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
 int		sort__has_sym = 0;
+int		sort__has_dso = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
 enum sort_type	sort__first_dimension;
@@ -194,9 +195,11 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * comparing symbol address alone is not enough since it's a
 	 * relative address within a dso.
 	 */
-	ret = sort__dso_cmp(left, right);
-	if (ret != 0)
-		return ret;
+	if (!sort__has_dso) {
+		ret = sort__dso_cmp(left, right);
+		if (ret != 0)
+			return ret;
+	}
 
 	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
@@ -1061,6 +1064,8 @@ int sort_dimension__add(const char *tok)
 			sort__has_parent = 1;
 		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
+		} else if (sd->entry == &sort_dso) {
+			sort__has_dso = 1;
 		}
 
 		__sort_dimension__add(sd, i);
