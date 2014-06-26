Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbaFZQMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:12:31 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:45401 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932314AbaFZQLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:11:36 -0400
X-Yandex-Uniq: 24f386a6-4848-48b5-9a8b-33a8bc26f2b1
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, stfomichev@yandex-team.ru, namhyung@kernel.org,
        artagnon@gmail.com, jolsa@redhat.com, bp@suse.de,
        rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] perf timechart: add more options to IO mode
Date: Thu, 26 Jun 2014 20:11:11 +0400
Message-Id: <1403799071-1252-5-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403799071-1252-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--io-skip-eagain - don't show EAGAIN errors
--io-min-time    - make small io bursts visible
--io-merge-dist  - merge adjacent events

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt | 13 +++++
 tools/perf/builtin-timechart.c              | 75 ++++++++++++++++++++++++++++-
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index ec6b46c7bca0..df98d1c82688 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -64,6 +64,19 @@ TIMECHART OPTIONS
 	duration or tasks with given name. If number is given it's interpreted
 	as number of nanoseconds. If non-numeric string is given it's
 	interpreted as task name.
+--io-skip-eagain::
+	Don't draw EAGAIN IO events.
+--io-min-time=<nsecs>::
+	Draw small events as if they lasted min-time. Useful when you need
+	to see very small and fast IO. It's possible to specify ms or us
+	suffix to specify time in milliseconds or microseconds.
+	Default value is 1ms.
+--io-merge-dist=<nsecs>::
+	Merge events that are merge-dist nanoseconds apart.
+	Reduces number of figures on the SVG and makes it more render-friendly.
+	It's possible to specify ms or us suffix to specify time in
+	milliseconds or microseconds.
+	Default value is 1us.
 
 RECORD OPTIONS
 --------------
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 011569becc65..732dc408ee0b 100644
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
 
@@ -1842,6 +1879,30 @@ parse_highlight(const struct option *opt __maybe_unused, const char *arg,
 	return 0;
 }
 
+static int
+parse_time(const struct option *opt, const char *arg, int __maybe_unused unset)
+{
+	char unit = 'n';
+	u64 *value = opt->value;
+
+	if (sscanf(arg, "%" PRIu64 "%cs", value, &unit) > 0) {
+		switch (unit) {
+		case 'm':
+			*value *= 1000000;
+			break;
+		case 'u':
+			*value *= 1000;
+			break;
+		case 'n':
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 int cmd_timechart(int argc, const char **argv,
 		  const char *prefix __maybe_unused)
 {
@@ -1854,6 +1915,8 @@ int cmd_timechart(int argc, const char **argv,
 			.ordered_samples = true,
 		},
 		.proc_num = 15,
+		.min_time = 1000000,
+		.merge_dist = 1000,
 	};
 	const char *output_name = "output.svg";
 	const struct option timechart_options[] = {
@@ -1875,6 +1938,14 @@ int cmd_timechart(int argc, const char **argv,
 		    "min. number of tasks to print"),
 	OPT_BOOLEAN('t', "topology", &tchart.topology,
 		    "sort CPUs according to topology"),
+	OPT_BOOLEAN(0, "io-skip-eagain", &tchart.skip_eagain,
+		    "skip EAGAIN errors"),
+	OPT_CALLBACK(0, "io-min-time", &tchart.min_time, "time",
+		     "all IO faster than min-time will visually appear longer",
+		     parse_time),
+	OPT_CALLBACK(0, "io-merge-dist", &tchart.merge_dist, "time",
+		     "merge events that are merge-dist us apart",
+		     parse_time),
 	OPT_END()
 	};
 	const char * const timechart_usage[] = {
-- 
1.9.1

