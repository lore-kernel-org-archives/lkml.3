Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3K3Mvh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:51:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3K3Mva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:30 -0500
Date: Sat, 30 Nov 2013 04:51:14 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-0a8eb275cbdb8462854d5f7e1168d86cee4cc9ea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, stfomichev@yandex-team.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de
In-Reply-To: <1383323151-19810-2-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-2-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Always try to print at least 15 tasks
Git-Commit-ID: 0a8eb275cbdb8462854d5f7e1168d86cee4cc9ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:51:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a8eb275cbdb8462854d5f7e1168d86cee4cc9ea
Gitweb:     http://git.kernel.org/tip/0a8eb275cbdb8462854d5f7e1168d86cee4cc9ea
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Fri, 1 Nov 2013 20:25:45 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:36 -0300

perf timechart: Always try to print at least 15 tasks

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
index 41c9bde..bb21e57 100644
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
 
