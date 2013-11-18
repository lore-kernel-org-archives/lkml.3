Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab3KRCVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:21:06 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51109 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab3KRCUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:20:50 -0500
X-AuditID: 9c930179-b7ba7ae000000e31-0b-5289797fdd42
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf header: Fix possible memory leaks in process_group_desc()
Date: Mon, 18 Nov 2013 11:20:44 +0900
Message-Id: <1384741244-7271-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1384741244-7271-1-git-send-email-namhyung@kernel.org>
References: <1384741244-7271-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

After processing all group descriptors or encountering an error, it
frees all descriptors.  However, current logic can leak memory since
it might not traverse all descriptors.

Note that the 'i' can have different value than nr_groups when an
error occurred and it's safe to call free(desc[i].name) for every desc
since we already make it NULL when it's reused for group names.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 559c516f1cec..1cd035708931 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2107,7 +2107,7 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 
 	ret = 0;
 out_free:
-	while ((int) --i >= 0)
+	for (i = 0; i < nr_groups; i++)
 		free(desc[i].name);
 	free(desc);
 
-- 
1.7.11.7

