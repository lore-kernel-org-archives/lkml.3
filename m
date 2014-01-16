Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaAPNjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:39:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaAPNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:39:33 -0500
Date: Thu, 16 Jan 2014 05:38:54 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-f39056f9c3275e648e2fb353561aeb377dd351f7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, rodrigo@sdfg.com.ar,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1389677157-30513-5-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Convert hist entry functions to use struct he_stat
Git-Commit-ID: f39056f9c3275e648e2fb353561aeb377dd351f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:39:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f39056f9c3275e648e2fb353561aeb377dd351f7
Gitweb:     http://git.kernel.org/tip/f39056f9c3275e648e2fb353561aeb377dd351f7
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 14 Jan 2014 14:25:37 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Jan 2014 15:34:00 -0300

perf hists: Convert hist entry functions to use struct he_stat

The hist_entry__add_cpumode_period() and hist_entry__decay() functions
are dealing with hist_entry's stat fields only.

Make them he_stat methods then.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rodrigo Campos <rodrigo@sdfg.com.ar>
Link: http://lkml.kernel.org/r/1389677157-30513-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 4ed3e88..e4e6249 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -181,21 +181,21 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 	}
 }
 
-static void hist_entry__add_cpumode_period(struct hist_entry *he,
-					   unsigned int cpumode, u64 period)
+static void he_stat__add_cpumode_period(struct he_stat *he_stat,
+					unsigned int cpumode, u64 period)
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		he->stat.period_sys += period;
+		he_stat->period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		he->stat.period_us += period;
+		he_stat->period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		he->stat.period_guest_sys += period;
+		he_stat->period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		he->stat.period_guest_us += period;
+		he_stat->period_guest_us += period;
 		break;
 	default:
 		break;
@@ -222,10 +222,10 @@ static void he_stat__add_stat(struct he_stat *dest, struct he_stat *src)
 	dest->weight		+= src->weight;
 }
 
-static void hist_entry__decay(struct hist_entry *he)
+static void he_stat__decay(struct he_stat *he_stat)
 {
-	he->stat.period = (he->stat.period * 7) / 8;
-	he->stat.nr_events = (he->stat.nr_events * 7) / 8;
+	he_stat->period = (he_stat->period * 7) / 8;
+	he_stat->nr_events = (he_stat->nr_events * 7) / 8;
 	/* XXX need decay for weight too? */
 }
 
@@ -236,7 +236,7 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	if (prev_period == 0)
 		return true;
 
-	hist_entry__decay(he);
+	he_stat__decay(&he->stat);
 
 	if (!he->filtered)
 		hists->stats.total_period -= prev_period - he->stat.period;
@@ -402,7 +402,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	hist_entry__add_cpumode_period(he, al->cpumode, period);
+	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
 	return he;
 }
 
