Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3KAQ2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:28:14 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:44050 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab3KAQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:28:13 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] perf timechart: use proc_num to implement --power-only
Date: Fri,  1 Nov 2013 20:25:47 +0400
Message-Id: <1383323151-19810-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use special flag to indicate power-only mode,
just set proc_num to 0.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-timechart.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 51a5532b3382..74c040abb3af 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -911,7 +911,7 @@ static int determine_display_tasks(u64 threshold)
 		/* no exit marker, task kept running to the end */
 		if (p->end_time == 0)
 			p->end_time = last_time;
-		if (p->total_time >= threshold && !power_only)
+		if (p->total_time >= threshold)
 			p->display = 1;
 
 		c = p->all;
@@ -922,7 +922,7 @@ static int determine_display_tasks(u64 threshold)
 			if (c->start_time == 1)
 				c->start_time = first_time;
 
-			if (c->total_time >= threshold && !power_only) {
+			if (c->total_time >= threshold) {
 				c->display = 1;
 				count++;
 			}
@@ -949,6 +949,8 @@ static void write_svg_file(const char *filename)
 
 	numcpus++;
 
+	if (power_only)
+		proc_num = 0;
 
 	/* We'd like to show at least proc_num tasks;
 	 * be less picky if we have fewer */
@@ -966,9 +968,11 @@ static void write_svg_file(const char *filename)
 		svg_cpu_box(i, max_freq, turbo_frequency);
 
 	draw_cpu_usage();
-	draw_process_bars();
+	if (proc_num)
+		draw_process_bars();
 	draw_c_p_states();
-	draw_wakeups();
+	if (proc_num)
+		draw_wakeups();
 
 	svg_close();
 }
-- 
1.8.3.2

