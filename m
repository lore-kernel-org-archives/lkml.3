Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3KYOVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:21:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964Ab3KYOSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:18:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/25] perf timechart: Always try to print at least 15 tasks
Date: Mon, 25 Nov 2013 11:17:44 -0300
Message-Id: <1385389075-7989-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385389075-7989-1-git-send-email-acme@infradead.org>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Always try to print at least 15 tasks no matter how long they run.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383323151-19810-2-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 41c9bde2fb67..bb21e57ff9bb 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -945,15 +945,17 @@ static void write_svg_file(const char *filename)
 {
 	u64 i;
 	int count;
+	int thresh = TIME_THRESH;
 
 	numcpus++;
 
 
-	count = determine_display_tasks(TIME_THRESH);
-
-	/* We'd like to show at least 15 tasks; be less picky if we have fewer */
-	if (count < 15)
-		count = determine_display_tasks(TIME_THRESH / 10);
+	/* We'd like to show at least proc_num tasks;
+	 * be less picky if we have fewer */
+	do {
+		count = determine_display_tasks(thresh);
+		thresh /= 10;
+	} while (!process_filter && thresh && count < 15);
 
 	open_svg(filename, numcpus, count, first_time, last_time);
 
-- 
1.8.1.4

