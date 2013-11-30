Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab3K3Mvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:51:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59634 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3K3Mvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:50 -0500
Date: Sat, 30 Nov 2013 04:51:34 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-753c505dc49a87a4421d452bda048e4b93e8e42b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, stfomichev@yandex-team.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de
In-Reply-To: <1383323151-19810-4-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-4-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Use proc_num to implement --power-only
Git-Commit-ID: 753c505dc49a87a4421d452bda048e4b93e8e42b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:51:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  753c505dc49a87a4421d452bda048e4b93e8e42b
Gitweb:     http://git.kernel.org/tip/753c505dc49a87a4421d452bda048e4b93e8e42b
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Fri, 1 Nov 2013 20:25:47 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:36 -0300

perf timechart: Use proc_num to implement --power-only

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
index c352be4..6410c9e 100644
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
