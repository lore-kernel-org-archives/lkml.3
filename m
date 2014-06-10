Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaFJPFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:05:09 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:44537 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbaFJPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:05:06 -0400
X-Yandex-Uniq: ec873bbd-0e78-4f4b-b4d8-4166a7d387e8
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: acme@kernel.org, namhyung@kernel.org, artagnon@gmail.com, jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf timechart: add more options to IO mode
Date: Tue, 10 Jun 2014 19:04:54 +0400
Message-Id: <1402412694-5996-4-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
References: <1402412694-5996-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--io-skip-eagain - don't show EAGAIN errors
--io-min-time    - make small io bursts visible
--io-merge-dist  - merge adjacent events

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt |  9 ++++++
 tools/perf/builtin-timechart.c              | 49 +++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index ec6b46c7bca0..62c29656ad95 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -64,6 +64,15 @@ TIMECHART OPTIONS
 	duration or tasks with given name. If number is given it's interpreted
 	as number of nanoseconds. If non-numeric string is given it's
 	interpreted as task name.
+--io-skip-eagain::
+	Don't draw EAGAIN IO events.
+--io-min-time::
+	Draw small events as if they lasted min-time. Useful when you need
+	to see very small and fast IO. Default value is 1ms.
+--io-merge-dist::
+	Merge events that are merge-dist nanoseconds apart.
+	Reduces number of figures on the SVG and makes it more render-friendly.
+	Default value is 1us.
 
 RECORD OPTIONS
 --------------
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 6941da0cb302..c818b35e3290 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -62,7 +62,10 @@ struct timechart {
 				topology;
 	/* IO related settings */
 	u64			io_events;
-	bool			io_only;
+	bool			io_only,
+				skip_eagain;
+	u64			min_time,
+				merge_dist;
 };
 
 struct per_pidcomm;
@@ -755,7 +758,7 @@ static int pid_end_io_sample(struct timechart *tchart, int pid, int type,
 {
 	struct per_pid *p = find_create_pid(tchart, pid);
 	struct per_pidcomm *c = p->current;
-	struct io_sample *sample;
+	struct io_sample *sample, *prev;
 
 	if (!c) {
 		pr_err("Invalid pidcomm!\n");
@@ -778,6 +781,18 @@ static int pid_end_io_sample(struct timechart *tchart, int pid, int type,
 	}
 
 	sample->end_time = end;
+	prev = sample->next;
+
+	/* we want to be able to see small and fast transfers, so make them
+	 * at least min_time long, but don't overlap them */
+	if (sample->end_time - sample->start_time < tchart->min_time)
+		sample->end_time = sample->start_time + tchart->min_time;
+	if (prev && sample->start_time < prev->end_time) {
+		if (prev->err) /* try to make errors more visible */
+			sample->start_time = prev->end_time;
+		else
+			prev->end_time = sample->start_time;
+	}
 
 	if (ret < 0) {
 		sample->err = ret;
@@ -792,6 +807,24 @@ static int pid_end_io_sample(struct timechart *tchart, int pid, int type,
 		sample->bytes = ret;
 	}
 
+	/* merge two requests to make svg smaller and render-friendly */
+	if (prev &&
+	    prev->type == sample->type &&
+	    prev->err == sample->err &&
+	    prev->fd == sample->fd &&
+	    prev->end_time + tchart->merge_dist >= sample->start_time) {
+
+		sample->bytes += prev->bytes;
+		sample->merges += prev->merges + 1;
+
+		sample->start_time = prev->start_time;
+		sample->next = prev->next;
+		free(prev);
+
+		if (!sample->err && sample->bytes > c->max_bytes)
+			c->max_bytes = sample->bytes;
+	}
+
 	tchart->io_events++;
 
 	return 0;
@@ -1112,6 +1145,10 @@ static void draw_io_bars(struct timechart *tchart)
 			for (sample = c->io_samples; sample; sample = sample->next) {
 				double h = (double)sample->bytes / c->max_bytes;
 
+				if (tchart->skip_eagain &&
+				    sample->err == -EAGAIN)
+					continue;
+
 				if (sample->err)
 					h = 1;
 
@@ -1848,6 +1885,8 @@ int cmd_timechart(int argc, const char **argv,
 			.ordered_samples = true,
 		},
 		.proc_num = 15,
+		.min_time = 1000000,
+		.merge_dist = 1000,
 	};
 	const char *output_name = "output.svg";
 	const struct option timechart_options[] = {
@@ -1869,6 +1908,12 @@ int cmd_timechart(int argc, const char **argv,
 		    "min. number of tasks to print"),
 	OPT_BOOLEAN('t', "topology", &tchart.topology,
 		    "sort CPUs according to topology"),
+	OPT_BOOLEAN(0, "io-skip-eagain", &tchart.skip_eagain,
+		    "skip EAGAIN errors"),
+	OPT_U64(0, "io-min-time", &tchart.min_time,
+		"all IO faster than min-time will visually appear longer"),
+	OPT_U64(0, "io-merge-dist", &tchart.merge_dist,
+		"merge events that are merge-dist us apart"),
 	OPT_END()
 	};
 	const char * const timechart_usage[] = {
-- 
1.8.3.2

