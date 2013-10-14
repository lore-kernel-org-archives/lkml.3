Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3JNUas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38908 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 116/161] perf stat: Don't print bogus data on -e instructions
Date: Mon, 14 Oct 2013 17:01:45 -0300
Message-Id: <1381780950-25642-117-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

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

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1380616604-4077-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ce2266c5cd52..fb02b53b0e3d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -930,11 +930,10 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 
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
1.8.1.4

