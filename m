Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3JOCCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 22:02:14 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62654 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3JOCCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 22:02:00 -0400
X-AuditID: 9c93017d-b7b2eae000005519-99-525ca216e03f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [RFC/PATCH 2/2] perf tools: Sort dso using pointers
Date: Tue, 15 Oct 2013 11:01:57 +0900
Message-Id: <1381802517-18812-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
References: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The dso's in a perf session are maintained machine-wide so same dso is
shared by hist entries.  Thus just checking pointer should be enough
to comparing dso's.

It may change behavior of 'perf report -s dso' when there're two or
more dso's that have same basename - the dso's which have same name
used to merged to one unless -v option was given.  But I don't think
it's a big problem. ;)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 1f9821db9e77..70658a0834e3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -114,20 +114,8 @@ static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
 {
 	struct dso *dso_l = map_l ? map_l->dso : NULL;
 	struct dso *dso_r = map_r ? map_r->dso : NULL;
-	const char *dso_name_l, *dso_name_r;
 
-	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
-
-	if (verbose) {
-		dso_name_l = dso_l->long_name;
-		dso_name_r = dso_r->long_name;
-	} else {
-		dso_name_l = dso_l->short_name;
-		dso_name_r = dso_r->short_name;
-	}
-
-	return strcmp(dso_name_l, dso_name_r);
+	return (int64_t)(dso_l - dso_r);
 }
 
 static int64_t
-- 
1.7.11.7

