Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3LRKiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:38:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab3LRKbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:31:18 -0500
Date: Wed, 18 Dec 2013 02:30:45 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-8b6dcca017aa53fe13066411a653b5997c158a2c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        stfomichev@yandex-team.ru, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, stfomichev@yandex-team.ru,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1385995056-20158-2-git-send-email-stfomichev@yandex-team.ru>
References: <1385995056-20158-2-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart: Add backtrace support to CPU info
Git-Commit-ID: 8b6dcca017aa53fe13066411a653b5997c158a2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 18 Dec 2013 02:30:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b6dcca017aa53fe13066411a653b5997c158a2c
Gitweb:     http://git.kernel.org/tip/8b6dcca017aa53fe13066411a653b5997c158a2c
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Mon, 2 Dec 2013 18:37:33 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Dec 2013 16:33:14 -0300

perf timechart: Add backtrace support to CPU info

Add backtrace info to the CPU usage timechart.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/1385995056-20158-2-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 10 ++++++++--
 tools/perf/util/svghelper.c    |  4 +++-
 tools/perf/util/svghelper.h    |  2 +-
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 0bda620..d955095 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -837,8 +837,14 @@ static void draw_cpu_usage(struct timechart *tchart)
 		while (c) {
 			sample = c->samples;
 			while (sample) {
-				if (sample->type == TYPE_RUNNING)
-					svg_process(sample->cpu, sample->start_time, sample->end_time, "sample", c->comm);
+				if (sample->type == TYPE_RUNNING) {
+					svg_process(sample->cpu,
+						    sample->start_time,
+						    sample->end_time,
+						    "sample",
+						    c->comm,
+						    sample->backtrace);
+				}
 
 				sample = sample->next;
 			}
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index 8b79d3a..740f032 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -285,7 +285,7 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 	fprintf(svgfile, "</g>\n");
 }
 
-void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name)
+void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name, const char *backtrace)
 {
 	double width;
 
@@ -295,6 +295,8 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
 
 	fprintf(svgfile, "<g transform=\"translate(%4.8f,%4.8f)\">\n", time2pixels(start), cpu2y(cpu));
 	fprintf(svgfile, "<title>%s %s</title>\n", name, time_to_string(end - start));
+	if (backtrace)
+		fprintf(svgfile, "<desc>Switched because:\n%s</desc>\n", backtrace);
 	fprintf(svgfile, "<rect x=\"0\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
 		time2pixels(end)-time2pixels(start), SLOT_MULT+SLOT_HEIGHT, type);
 	width = time2pixels(end)-time2pixels(start);
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
index fad79ce..7db6ae9 100644
--- a/tools/perf/util/svghelper.h
+++ b/tools/perf/util/svghelper.h
@@ -11,7 +11,7 @@ extern void svg_waiting(int Yslot, int cpu, u64 start, u64 end, const char *back
 extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
 
 
-extern void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name);
+extern void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name, const char *backtrace);
 extern void svg_cstate(int cpu, u64 start, u64 end, int type);
 extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
 
