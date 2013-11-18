Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3KRCU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:20:56 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51109 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3KRCUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:20:49 -0500
X-AuditID: 9c930179-b7ba7ae000000e31-06-5289797f97c6
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/2] perf header: Fix bogus group name
Date: Mon, 18 Nov 2013 11:20:43 +0900
Message-Id: <1384741244-7271-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When processing event group descriptor in perf file header, we reuse
an allocated group name but forgot to prevent it from freeing.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 369c03648f88..559c516f1cec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2078,8 +2078,10 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 		if (evsel->idx == (int) desc[i].leader_idx) {
 			evsel->leader = evsel;
 			/* {anon_group} is a dummy name */
-			if (strcmp(desc[i].name, "{anon_group}"))
+			if (strcmp(desc[i].name, "{anon_group}")) {
 				evsel->group_name = desc[i].name;
+				desc[i].name = NULL;
+			}
 			evsel->nr_members = desc[i].nr_members;
 
 			if (i >= nr_groups || nr > 0) {
-- 
1.7.11.7

