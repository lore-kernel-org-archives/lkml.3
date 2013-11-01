Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3KAQfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:35:42 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:33651 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752958Ab3KAQfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:35:41 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] perf timechart: always try to print at least 15 tasks
Date: Fri,  1 Nov 2013 20:25:45 +0400
Message-Id: <1383323151-19810-2-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always try to print at least 15 tasks no matter how long they run.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c2e02319347a..c68ed44c2319 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -944,15 +944,17 @@ static void write_svg_file(const char *filename)
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
1.8.3.2

