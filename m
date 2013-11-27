Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab3K0UV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:21:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32816 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907Ab3K0URE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/34] perf timechart: Use proc_num to implement --power-only
Date: Wed, 27 Nov 2013 17:16:16 -0300
Message-Id: <1385583394-3703-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Don't use special flag to indicate power-only mode, just set proc_num to
0.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383323151-19810-4-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c352be418f98..6410c9ead9e2 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -912,7 +912,7 @@ static int determine_display_tasks(u64 threshold)
 		/* no exit marker, task kept running to the end */
 		if (p->end_time == 0)
 			p->end_time = last_time;
-		if (p->total_time >= threshold && !power_only)
+		if (p->total_time >= threshold)
 			p->display = 1;
 
 		c = p->all;
@@ -923,7 +923,7 @@ static int determine_display_tasks(u64 threshold)
 			if (c->start_time == 1)
 				c->start_time = first_time;
 
-			if (c->total_time >= threshold && !power_only) {
+			if (c->total_time >= threshold) {
 				c->display = 1;
 				count++;
 			}
@@ -950,6 +950,8 @@ static void write_svg_file(const char *filename)
 
 	numcpus++;
 
+	if (power_only)
+		proc_num = 0;
 
 	/* We'd like to show at least proc_num tasks;
 	 * be less picky if we have fewer */
@@ -967,9 +969,11 @@ static void write_svg_file(const char *filename)
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
1.8.1.4

