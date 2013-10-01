Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3JAIoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 04:44:01 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48016 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3JAIn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 04:43:59 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tool: don't print bogus data on -e instructions
Date: Tue,  1 Oct 2013 14:06:44 +0530
Message-Id: <1380616604-4077-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When only the instructions event is requested:

$ perf stat -e instructions git s
M  builtin-stat.c

 Performance counter stats for 'git s':

       917,453,420 instructions              #    0.00  insns per cycle

       0.213002926 seconds time elapsed

The 0.00 insns per cycle comment in the output is totally bogus and
misleading. It happens because update_shadow_stats() doesn't touch
runtime_cycles_stats when only the instructions event is requested. So,
omit printing the bogus data altogether.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-stat.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index cc167ae..0b747a5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -852,11 +852,10 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 
 	if (perf_evsel__match(evsel, HARDWARE, HW_INSTRUCTIONS)) {
 		total = avg_stats(&runtime_cycles_stats[cpu]);
-		if (total)
+		if (total) {
 			ratio = avg / total;
-
-		fprintf(output, " #   %5.2f  insns per cycle        ", ratio);
-
+			fprintf(output, " #   %5.2f  insns per cycle        ", ratio);
+		}
 		total = avg_stats(&runtime_stalled_cycles_front_stats[cpu]);
 		total = max(total, avg_stats(&runtime_stalled_cycles_back_stats[cpu]));
 
-- 
1.8.4.477.g5d89aa9

