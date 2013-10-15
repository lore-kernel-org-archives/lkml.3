Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab3JOF3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:29:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3JOF3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:40 -0400
Date: Mon, 14 Oct 2013 22:29:25 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-3e7a081796146f97f166d77a655c0eb585065077@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1380616604-4077-1-git-send-email-artagnon@gmail.com>
References: <1380616604-4077-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Don'
 t print bogus data on -e instructions
Git-Commit-ID: 3e7a081796146f97f166d77a655c0eb585065077
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:29:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e7a081796146f97f166d77a655c0eb585065077
Gitweb:     http://git.kernel.org/tip/3e7a081796146f97f166d77a655c0eb585065077
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Tue, 1 Oct 2013 14:06:44 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:35 -0300

perf stat: Don't print bogus data on -e instructions

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
index ce2266c..fb02b53 100644
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
 
